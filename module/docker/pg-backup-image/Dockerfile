#file-name: dockerfile
FROM ubuntu:20.04

# Run the Update
RUN apt-get update && apt-get upgrade -y

# Install pre-reqs
RUN apt-get install -y python curl openssh-server gnupg2 zip

# Setup sshd
RUN mkdir -p /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Install azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

EXPOSE 22

# Install posgres cli
RUN echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8
RUN apt update -y
ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y install postgresql-14

RUN service postgresql start
EXPOSE 5432
CMD ["postgres"]

# copy script file
COPY . /home/root/ 

# switch user to give command access (for k8s cron job)
USER root 


# # Build Docker image and push to azure container registry
# docker build -t id-registry.azurecr.io/docker/pg-backup:latest . --platform linux/amd64
# docker login id-registry.azurecr.io
# Enter username and password of ACR
# docker push id-registry.azurecr.io/docker/pg-backup:latest

# Note
#  use `--no-cache` if build is failing
# docker build -t id-registry.azurecr.io/docker/pg-backup:latest --no-cache . --platform linux/amd64