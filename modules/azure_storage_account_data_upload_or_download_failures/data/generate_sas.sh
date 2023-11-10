bash
#!/bin/bash

# Set the parameters
connection_string=${CONNECTION_STRING}


end=$(date -u -d "30 minutes" '+%Y-%m-%dT%H:%MZ')
# Generate a Shared Access Signtature for the account

az storage account generate-sas --coonection-string '$connection_string' --expiry $end --https-only --permission acwudt --resource-types co --services bfqt