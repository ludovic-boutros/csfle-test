#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/credentials.sh

curl --request POST --url "$SR_URL/subjects/customers-value/versions"   \
  -u "$SR_API_KEY:$SR_API_SECRET" \
  --header 'Content-Type: application/vnd.schemaregistry.v1+json' \
  --data '{
        "ruleSet": {
        "domainRules": [
          {
            "name": "encryptPII",
            "kind": "TRANSFORM",
            "type": "ENCRYPT",
            "mode": "WRITEREAD",
            "tags": ["PII"],
            "params": {
               "encrypt.kek.name": "test-csfle",
               "encrypt.kms.key.id": "'"${KEY_VAULT_KEY_ID}"'",
               "encrypt.kms.type": "azure-kms"
              },
            "onFailure": "ERROR,NONE"
          }
        ]
      }
    }' | jq .