#!/bin/bash

set -e

function check_deps() {
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
}

# Get arguments from Terraform
eval "$(jq -r '@sh "export key_file=\(.key_file) cert_file=\(.cert_file) cert_password=\(.cert_password)"')"

# Execute openssl to get PFX
pfx_b64=$(openssl pkcs12 -export -inkey $key_file -in $cert_file -password pass:$cert_password | base64)
JSON=$(cat <<-EOF
{
  "cert_file":    "$cert_file",
  "key_file":     "$key_file",
  "cert_password":"$cert_password",
  "pfx_b64":      "$pfx_b64"
}
EOF
)
echo $JSON