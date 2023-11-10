resource "shoreline_notebook" "azure_storage_account_data_upload_or_download_failures" {
  name       = "azure_storage_account_data_upload_or_download_failures"
  data       = file("${path.module}/data/azure_storage_account_data_upload_or_download_failures.json")
  depends_on = [shoreline_action.invoke_grant_permission,shoreline_action.invoke_generate_sas]
}

resource "shoreline_file" "grant_permission" {
  name             = "grant_permission"
  input_file       = "${path.module}/data/grant_permission.sh"
  md5              = filemd5("${path.module}/data/grant_permission.sh")
  description      = "Update the permissions correctly for the storage account. Ensure that the user or application has the required permissions to upload or download data to/from the storage account."
  destination_path = "/tmp/grant_permission.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "generate_sas" {
  name             = "generate_sas"
  input_file       = "${path.module}/data/generate_sas.sh"
  md5              = filemd5("${path.module}/data/generate_sas.sh")
  description      = "Create a SAS tokens used to access the storage account"
  destination_path = "/tmp/generate_sas.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_grant_permission" {
  name        = "invoke_grant_permission"
  description = "Update the permissions correctly for the storage account. Ensure that the user or application has the required permissions to upload or download data to/from the storage account."
  command     = "`chmod +x /tmp/grant_permission.sh && /tmp/grant_permission.sh`"
  params      = ["USER_OR_APPLICATION_OBJECT_ID","SCOPE"]
  file_deps   = ["grant_permission"]
  enabled     = true
  depends_on  = [shoreline_file.grant_permission]
}

resource "shoreline_action" "invoke_generate_sas" {
  name        = "invoke_generate_sas"
  description = "Create a SAS tokens used to access the storage account"
  command     = "`chmod +x /tmp/generate_sas.sh && /tmp/generate_sas.sh`"
  params      = ["CONNECTION_STRING"]
  file_deps   = ["generate_sas"]
  enabled     = true
  depends_on  = [shoreline_file.generate_sas]
}

