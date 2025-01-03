#!/bin/bash

###############################################################################
# Script to Create Azure Resources
# Author: Revathi Mohan # Date : December - 21st - 2024
# Version: v1.0.0
###############################################################################

# Exit the script if any command fails
set -e

# Define variables
RESOURCE_GROUP="Shell_Project_Group"
LOCATION="eastus"
VM_NAME="Shell-Script-VM"
STORAGE_ACCOUNT="shellsa$(date +%s)"
SQL_SERVER_NAME="mySqlServer$(date +%s)"
SQL_DB_NAME="MyDatabase"
ADMIN_USER="myadmin"
ADMIN_PASSWORD="MyP@ssword123"

# Function to check if Azure CLI is logged in
check_az_login() {
    if ! az account show &> /dev/null; then
        echo "Azure CLI is not logged in. Please log in to Azure CLI using 'az login'."
        exit 1
    fi
}

# Function to register Microsoft.Sql provider
register_sql_provider() {
    echo "Registering Microsoft.Sql provider..."
    az provider register --namespace Microsoft.Sql
    while true; do
        status=$(az provider show --namespace Microsoft.Sql --query "registrationState" -o tsv)
        if [ "$status" == "Registered" ]; then
            echo "Microsoft.Sql provider is registered."
            break
        else
            echo "Waiting for Microsoft.Sql provider to register..."
            sleep 10
        fi
    done
}

# Log in check
check_az_login

# Step 1: Create Resource Group
echo "Creating Resource Group: $RESOURCE_GROUP..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Step 2: Create Virtual Machine
echo "Creating Virtual Machine: $VM_NAME..."
az vm create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$VM_NAME" \
    --image Ubuntu2204 \
    --admin-username azureuser1 \
    --generate-ssh-keys

# Step 3: Create Storage Account
echo "Creating Storage Account: $STORAGE_ACCOUNT..."
az storage account create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$STORAGE_ACCOUNT" \
    --location "$LOCATION" \
    --sku Standard_LRS

# Step 4: Register Microsoft.Sql Provider
register_sql_provider

# Step 5: Create SQL Server
echo "Creating SQL Server: $SQL_SERVER_NAME..."
az sql server create \
    --name "$SQL_SERVER_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --admin-user "$ADMIN_USER" \
    --admin-password "$ADMIN_PASSWORD"

# Step 6: Create SQL Database
echo "Creating SQL Database: $SQL_DB_NAME..."
az sql db create \
    --resource-group "$RESOURCE_GROUP" \
    --server "$SQL_SERVER_NAME" \
    --name "$SQL_DB_NAME" \
    --service-objective S0

echo "All resources have been created successfully!"

