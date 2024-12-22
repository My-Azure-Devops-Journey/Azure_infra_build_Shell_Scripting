#!/bin/bash

###############################################################################
# Script to List Azure Resources and Send Email
# Author: Revathi Mohan
# Date: December - 21st - 2024
# Version: v1.0.0
###############################################################################

# Exit the script if any command fails
set -e

# Define variables
RESOURCE_GROUP="Shell_Project_Group"
EMAIL_RECIPIENT="RevathiMohan0407@hotmail.com"
EMAIL_SUBJECT="Daily Azure Resources Report"

# Function to check if Azure CLI is logged in
check_az_login() {
    if ! az account show &> /dev/null; then
        echo "Azure CLI is not logged in. Please log in to Azure CLI using 'az login'."
        exit 1
    fi
}

# Function to list resources in the resource group
list_resources() {
    echo "Listing Azure resources in the resource group: $RESOURCE_GROUP..."
    az resource list --resource-group "$RESOURCE_GROUP" --output table
}

# Function to send email using msmtp
send_email() {
    echo "Sending email to $EMAIL_RECIPIENT..."

    local email_content="$1"
    
    # Create the email body and send it using msmtp
    echo -e "Subject:$EMAIL_SUBJECT\n$email_content" | msmtp "$EMAIL_RECIPIENT"
}

# Main script execution
check_az_login
resource_list=$(list_resources)
send_email "$resource_list"

echo "Email sent successfully with the list of resources!"
