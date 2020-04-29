#!/bin/bash

set -e -u -o pipefail

%{ if bash_debug_b64 != "" }# Bash debugging (optional)
echo ${bash_debug_b64} | base64 -d >> /etc/profile.d/tfe.sh
%{ endif ~}

${function-install-software}
${function-get-tfe-settings}
${download-airgap}
${download-tfe-installer}
${install-tfe}
${wait-for-ready}

# Set intial start time - used to calculate total time
SECONDS=0 #Start Time

install-software
get-tfe-settings
%{ if airgapped }download-airgap%{ endif }
download-tfe-installer

# Get instance private IP
private_ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | jq -r .network.interface[0].ipv4.ipAddress[0].privateIpAddress)

install-tfe $private_ip
wait-for-ready $private_ip

duration=$SECONDS #Stop Time
echo "[$(date +"%FT%T")]  Finished TFE startup script."
echo "  $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
