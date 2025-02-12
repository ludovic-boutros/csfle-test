#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/credentials.sh

# List keks
curl --request GET --url "$SR_URL/dek-registry/v1/keks"   \
  -u "$SR_API_KEY:$SR_API_SECRET" | jq .

# Get the kek named 'kafka'
curl --request GET --url "$SR_URL/dek-registry/v1/keks/kafka"   \
  -u "$SR_API_KEY:$SR_API_SECRET" | jq .

# Delete the kek named 'kafka'
curl --request DELETE --url "$SR_URL/dek-registry/v1/keks/kafka"   \
  -u "$SR_API_KEY:$SR_API_SECRET" | jq .

# Check if it was deleted
curl --request GET --url "$SR_URL/dek-registry/v1/keks"   \
  -u "$SR_API_KEY:$SR_API_SECRET" | jq .