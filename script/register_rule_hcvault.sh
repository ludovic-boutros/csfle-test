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
               "encrypt.kek.name": "kafka",
               "encrypt.kms.key.id": "http://127.0.0.1:8200/transit/keys/kafka",
               "encrypt.kms.type": "hcvault"
              },
            "onFailure": "ERROR,NONE"
          }
        ]
      }
    }' | jq .