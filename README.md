# azure_terraform_infra_provisioning# Infrastructure as a code

* Terraform code to create multiple enviroments on azure

## Azure credentials

* This repo by default uses you system's azure account meaning if you have azure cli installed and logged into your account it will use that account you do not need to do any other configuration.
* Make to login to specific account using

```bash
az login
```

* if you are not logged in to az cli and you want to run this setup. you can set/explore below env varibales on the same termianl where you want to run `terraform apply`

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="20000000-0000-0000-0000-000000000000"
```

### Steps to get above export variables

* For query `https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#configuring-the-service-principal-in-terraform`
* SUBSCRIPTION_ID = it is found in azure portal
* tenant_id = goto azure active directory > properties
* client_id  = goto azure active directory > app registrations > new registration > give terraform name > register and copy  (application_id)
* client_secret  =in terraform app > certificates & secrets  > client secrets > new client secret > give any name and create > copy the value
* Then - go to subscription > acess control > add >add role assignment > contributor > select members > terraform > review and assign


## Usage Steps

### Use existing environment

* go to environment dir. eg,

```bsh
cd <name>-production
```
OR
```
cd <name>-staging
```

* create `terraform.tfstate` files with below values

```tf
# Terraform repo variables
postgres_admin_password=""
vnet_gateway_root_certificate_public_cert_data=""

# DNS Manager repo variables
azure_subscription_id           = ""
dns_manager_azure_client_id     = ""
dns_manager_azure_client_secret = ""
dns_manager_auth_token          = ""

# CMS OCPP Secret Variables
postgres_cms_ocpp_password = ""
cms_ocpp_secret_key        = ""
cms_ocpp_appsignal_key     = ""
cms_ocpp_es_password       = "" // TODO: Remove cms_ocpp_es_password variable when CPO production ES is migrated to terraform
backend_es_password        = "" // TODO: Remove backend_es_password variable when CPO production ES is migrated to terraform
cleanup_es_password        = "" // TODO: Remove cleanup_es_password variable when CPO production ES is migrated to terraform

# Notifications secret variables
notification_secret_key                       = ""
notification_fcm_services_account_json_base64 = ""
temp_eventhub_connection_string               = "" // TODO: remove this variable when we start using correct eventhub
temp_cosmosdb_connection_string               = "" // TODO: remove this variable when we start using correct eventhub

# Analytics Secret Variables
postgres_analytics_password             = ""
analytics_google_client_id              = ""
analytics_google_drive_parent_folder_id = ""
analytics_google_private_key_base64     = ""
analytics_google_private_key_id         = ""
analytics_secret_key                    = ""

# Backend Secret Variables (Some Notifications secret variables as well)
sendgrid_api_key             = ""
twilio_account_sid           = ""
twilio_subaccount_sid        = ""
twilio_auth_token            = ""
fcm_server_key               = ""
bing_api_key                 = ""
matrix_api_key               = ""
qr_dynamic_link_key          = ""
freshworks_crm_token         = ""
backend_webapp_search_key    = ""
backend_api_signup_key       = ""
backend_push_api_key         = ""
backend_delta_token          = ""
razorpay_key_id              = ""
razorpay_secret_key          = ""
sidekiq_password             = ""
postgres_papertrail_password = ""
backend_secret_key_base      = ""
onjuice_host                 = ""
onjuice_username             = ""
onjuice_password             = ""
kiot_host                    = ""
kiot_username                = ""
kiot_password                = ""
riod_host                    = ""
riod_username                = ""
riod_password                = ""
```

* Then run `terraform apply` to apply changes if you have made any.

### Setup a new environment

* create a folder with a new env name. eg,

```bash
mkdir -p <name>-pre-staging
OR
mkdir -p <name>-dev
```

* copy staging dir files to new dir
* `cd` into the new dir
* edit `main.tf` file and set required values for all variables where needed.
* create `terraform.tfstate` files as explained above with same key but different values based on environment.
* Setup state container on existing storage account as per global dir. refer staging and production container resources.
* Update state container information on `providers.tf` file.
* Then, run `terraform init` to setup & install dependencies.
* Then, run `terraform apply` this will prepare state and show resources to be changed or created.
* Read outputs/changes carefully before you press `yes` to procced.

## Outputs

* Check Kubernetes acccess output

```bash
terraform output -json kube | jq
```

* Check all json formatted output

```bash
terraform output -json | jq 'map_values(.value)'
```

* Check Elastic users json formatted output

```bash
terraform output -json elasticsearch | jq
```

## Imports

* incase some existing password import is required use below command with causion

```bash
terraform import module.resources.random_password.postgres_secure_file_password\[0\] <pwd value> 
```
