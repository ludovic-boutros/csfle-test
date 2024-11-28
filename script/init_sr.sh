#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/credentials.sh

curl -u "$SR_API_KEY:$SR_API_SECRET" --header 'Content-Type: application/json' \
--data '[ { "entityTypes" : [ "cf_entity" ],"name" :  "PII", "description" : "Personal info"} ]' \
--url "$SR_URL/catalog/v1/types/tagdefs" | jq .


curl --request POST --url "$SR_URL/subjects/customers-value/versions"   \
  -u "$SR_API_KEY:$SR_API_SECRET" \
  --header 'content-type: application/octet-stream' \
  --data '{
    "schemaType": "AVRO",
    "schema": "{  \"fields\": [    {      \"name\": \"firstname\",      \"type\": \"string\"    },    {      \"name\": \"name\",      \"type\": \"string\"    },    {      \"name\": \"email\",      \"type\": \"string\",      \"confluent:tags\": [ \"PII\"]    },    {      \"name\": \"age\",      \"type\": \"int\"    }  ],  \"name\": \"Customer\",  \"namespace\": \"io.confluent.demo.csfle.model\",  \"type\": \"record\"}"
  }' | jq .