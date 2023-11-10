#!/bin/bash

# Set the variables
user_or_application_object_id=${USER_OR_APPLICATION_OBJECT_ID}
scope=${SCOPE}
permission="Storage Blob Data Contributor"

# Grant the specified permission to the user or application for the storage account
az role assignment create --assignee-object-id $user_or_application_object_id --role $permission --scope $scope
# Check if the permission has been granted successfully
if [ $? -eq 0 ]; then
  echo "Permission '$permission' has been granted to the user or application with object ID '$user_or_application_object_id' for the storage account '$storage_account' in the resource group '$resource_group'"
else
  echo "Failed to grant permission '$permission' to the user or application with object ID '$user_or_application_object_id' for the storage account '$storage_account' in the resource group '$resource_group'"
fi