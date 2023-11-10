
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Storage Account Data Upload or Download Failures

This incident type refers to failures in uploading or downloading data to/from an Azure storage account. The issue can be caused due to problems with the connection to the storage account, access keys, or SAS tokens. It is important to check for network issues and ensure that the correct permissions are set to resolve this type of incident.

### Parameters

```shell
export STORAGE_ACCOUNT_NAME="PLACEHOLDER"
export RESOURCE_GROUP_NAME="PLACEHOLDER"
export CONTAINER_NAME="PLACEHOLDER"
export CONNECTION_STRING="PLACEHOLDER"
export USER_OR_APPLICATION_OBJECT_ID="PLACEHOLDER"
export SCOPE="PLACEHOLDER"
```

## Debug

### Check the status of the storage account

```shell
az storage account show --name ${STORAGE_ACCOUNT_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### Check the connection string for the storage account

```shell
az storage account show-connection-string --name ${STORAGE_ACCOUNT_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### Check the list of access keys associated with the storage account

```shell
az storage account keys list --account-name ${STORAGE_ACCOUNT_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### List the blobs in the container to check if the connection is working

```shell
az storage blob list --container-name ${CONTAINER_NAME} --connection-string '${CONNECTION_STRING}'
```

## Repair

### Update the permissions correctly for the storage account. Ensure that the user or application has the required permissions to upload or download data to/from the storage account.

```shell
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
```

### Create a SAS tokens used to access the storage account

```shell
bash
#!/bin/bash

# Set the parameters
connection_string=${CONNECTION_STRING}


end=$(date -u -d "30 minutes" '+%Y-%m-%dT%H:%MZ')
# Generate a Shared Access Signtature for the account

az storage account generate-sas --coonection-string '$connection_string' --expiry $end --https-only --permission acwudt --resource-types co --services bfqt
```