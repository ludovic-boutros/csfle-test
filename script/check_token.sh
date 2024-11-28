#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/credentials.sh

TOKEN=$(curl -X POST -H "Content-Type: application/x-www-form-urlencoded" \
-d 'client_id='"${CLIENT_ID}"'&scope=https://vault.azure.net/.default&client_secret='"${CLIENT_SECRET}"'&grant_type=client_credentials' \
"https://login.microsoftonline.com/$AZURE_TENANT/oauth2/v2.0/token" | jq -r .access_token)

echo "$TOKEN"

curl -H "Authorization: Bearer $TOKEN" "https://$KEY_VAULT_NAME.vault.azure.net/keys/$KEY_NAME/$KEY_ID?api-version=7.4" | jq .
