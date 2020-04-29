#!/bin/bash

# Gets the latest version from replicated, then generates a temporary airgap URL before calling packer.
license_id=$1
channel=$2
password=$3

b64_password=$(echo -n ${password} | base64)
required=false

curl \
-H "Authorization: Basic ${b64_password}" \
-H "X-ReplicatedChannelID: ${channel}" \
-H "Accept: application/json" \
"https://api.replicated.com/market/v1/airgap/releases?license_id=${license_id}" > /tmp/releases.json

sequence=$(jq -r "first(.releases[] | select(.required == ${required}) | .release_sequence)" /tmp/releases.json)
label=$(jq -r "first(.releases[] | select(.required == ${required}) | .label)" /tmp/releases.json)

curl \
-H "Authorization: Basic ${b64_password}" \
-H "X-ReplicatedChannelID: ${channel}" \
-H "Accept: application/json" \
"https://api.replicated.com/market/v1/airgap/images/url?license_id=${license_id}&sequence=${sequence}" > /tmp/airgap.json

url=$(jq -r '.url' /tmp/airgap.json)

echo
echo "Found latest pTFE release:"
echo "  Required: ${required}"
echo "  Sequence: ${sequence}"
echo "  Label: ${label}"
echo
echo "Generated URL:"
echo "  URL: ${url}"
echo

curl ${url} > ptfe-current.airgap