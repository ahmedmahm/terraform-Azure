#!/bin/bash 
az account set --subscription ${1?Error: no given subscription}
cd $1
terraform init
echo Terraform initialized!
echo Appling Changes to $1 ...

terraform apply 