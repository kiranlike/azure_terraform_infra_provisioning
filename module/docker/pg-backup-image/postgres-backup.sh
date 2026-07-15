#!/bin/bash
cd /home/root

# NOTE: working restore commands
# psql -d cms_dev -f 20240531-0200-db-backup/20240531-0200-cms_staging.sql
# psql -d charge_fleet_development -f 20240531-0200-db-backup/20240531-0200-true_power_staging.sql

# TODO: add -Fc flag to pg_dump command to use custom format
# checkout: https://sqlbackupandftp.com/blog/how-to-backup-and-restore-postgresql-database/

mkdir $AZURE_CONTAINER_NAME

DATE_SUFFIX=$(date +%Y%m%d-%H%M)

# Backup 1 - Main DB for admin and backend
PGPASSWORD=$PG_PASSWORD pg_dump -U $PG_USER -h $PG_HOST -p $PG_PORT $PG_DB_MAIN > $AZURE_CONTAINER_NAME/$DATE_SUFFIX-$PG_DB_MAIN.sql

# Backup 2 - CMS DB
PGPASSWORD=$PG_PASSWORD pg_dump -U $PG_USER -h $PG_HOST -p $PG_PORT $PG_DB_PAPERTRAIL > $AZURE_CONTAINER_NAME/$DATE_SUFFIX-$PG_DB_PAPERTRAIL.sql

# Backup 3 - Papertrail DB
PGPASSWORD=$PG_PASSWORD pg_dump -U $PG_USER -h $PG_HOST -p $PG_PORT $PG_DB_CMS > $AZURE_CONTAINER_NAME/$DATE_SUFFIX-$PG_DB_CMS.sql

# Backup 1 - Main DB for admin and backend
PGPASSWORD=$PG_PASSWORD pg_dump -U $PG_USER -h $PG_HOST -p $PG_PORT $PG_DB_MAIN > $AZURE_CONTAINER_NAME/$DATE_SUFFIX-$PG_DB_MAIN.dump

# Backup 2 - CMS DB
PGPASSWORD=$PG_PASSWORD pg_dump -U $PG_USER -h $PG_HOST -p $PG_PORT $PG_DB_PAPERTRAIL > $AZURE_CONTAINER_NAME/$DATE_SUFFIX-$PG_DB_PAPERTRAIL.dump

# Backup 3 - Papertrail DB
PGPASSWORD=$PG_PASSWORD pg_dump -U $PG_USER -h $PG_HOST -p $PG_PORT $PG_DB_CMS > $AZURE_CONTAINER_NAME/$DATE_SUFFIX-$PG_DB_CMS.dump

# Backup all Databases
PGPASSWORD=$PG_PASSWORD pg_dumpall -U $PG_USER -h $PG_HOST -p $PG_PORT --exclude-database=azure_maintenance --exclude-database=azure_sys --exclude-database=postgres --clean --no-role-passwords > $AZURE_CONTAINER_NAME/$DATE_SUFFIX-all.sql

 # encrypt files with password
cd $AZURE_CONTAINER_NAME
zip -P $SECURE_FILE_PASSWORD $DATE_SUFFIX-db-backup.zip $DATE_SUFFIX-$PG_DB_MAIN.sql $DATE_SUFFIX-$PG_DB_PAPERTRAIL.sql $DATE_SUFFIX-$PG_DB_CMS.sql $DATE_SUFFIX-$PG_DB_MAIN.dump $DATE_SUFFIX-$PG_DB_PAPERTRAIL.dump $DATE_SUFFIX-$PG_DB_CMS.dump $DATE_SUFFIX-all.sql

# Uploading to Azure storage container
az storage blob upload --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_ACCESS_KEY --container-name $AZURE_CONTAINER_NAME --file $DATE_SUFFIX-db-backup.zip
# Check the exit status of az upload command
if [ $? -eq 0 ]; then
  echo "✓ Backup file is added for date - $DATE_SUFFIX-db-backup.zip"
else
  echo "Backup not successful!."
fi

DELETE_DATE_SUFFIX=$(date -d "$(echo $DATE_SUFFIX | cut -d'-' -f1) - 100 days" "+%Y%m%d")

# Iterate through blob names in the container
for BLOB_NAME in $(az storage blob list --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_ACCESS_KEY --container-name $AZURE_CONTAINER_NAME --query "[].name" --output tsv)
do
    # Extract the date part from the blob name using cut
    EXTRACTED_DATE=$(echo "$BLOB_NAME" | cut -d'-' -f1)

    # Compare the extracted date with the date part you want to match
    if [ "$EXTRACTED_DATE" = "$DELETE_DATE_SUFFIX" ]; then
        # Delete the blob
        az storage blob delete --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_ACCESS_KEY --container-name $AZURE_CONTAINER_NAME --name "$BLOB_NAME"
        # Check the exit status of az delete command
        if [ $? -eq 0 ]; then
          echo "✓ Backup file is deleted for date - $BLOB_NAME"
        else
          echo "Backup file not deleted"
        fi
    fi
done