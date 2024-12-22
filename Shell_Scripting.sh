#!/bin/bash

###############################################################################
# Author: Revathi
# Version: v0.0.1

# Script to list specific Azure resources created in a resource group
#
# Below are the resource types included in the listing:
# 1. Virtual Machines
# 2. Virtual Networks
# 3. Network Security Groups
# 4. Public IP Addresses
# 5. Network Interfaces
# 6. Disks
# 7. Storage Accounts
#
# Usage: ./azure_resource_list.sh  <resource_group>
# Example: ./azure_resource_list.sh Shell_Project_Group
###############################################################################

# Check if the required number of arguments are passed
if [ $# -ne 1 ]; then
    echo "Usage: ./azure_resource_list.sh  <resource_group>"
    echo "Example: ./Shell_Scripting.sh Shell_Project_Group"
    exit 1
fi

# Assign the argument to a variable
resource_group=$1

# Check if the Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Azure CLI is not installed. Please install the Azure CLI and try again."
    exit 1
fi

# Check if the Azure CLI is logged in
if ! az account show &> /dev/null; then
    echo "Azure CLI is not logged in. Please log in to Azure CLI using 'az login' and try again."
    exit 1
fi

# List resources by type in the specified resource group
echo "Listing resources in resource group: $resource_group"

echo "Virtual Machines:"
az vm list --resource-group "$resource_group" --query "[].{Name:name, Location:location}" --output table

echo -e "\nStorage Accounts:"
az storage account list --resource-group "$resource_group" --query "[].{Name:name, Location:location}" --output table

