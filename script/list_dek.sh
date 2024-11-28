#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/credentials.sh

curl --request GET --url "$SR_URL/dek-registry/v1/keks/test-csfle/deks/customers-value/versions"   \
  -u "$SR_API_KEY:$SR_API_SECRET" | jq .
