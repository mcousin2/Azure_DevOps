# Implementation Service TFE v4 (Standalone) Accelerator

Terraform modules for deploying production ready Terraform Enterprise platform.

## Goals vs. !Goals

*What is this repository meant to do?*

The goal of this repository is to accelerate the installation of TFE for our clients across several common scenarios. In other words, this should get you 80% (or more) of what you need to deploy TFE v4.

*What is this repository **NOT** meant to do?*

This repository does not claim or meant to be the single golden standard for the installation of TFE.
It is not expected that this repository can be used as-is, with zero modification, rather is customized per installation by swapping out and modifying the existing submodules.

## How to use this repository for a client

> Note: This is by no means the only way to interact with this repository, but simply the general idea of how it is intended to be used.

1. Create a branch off of master.
2. Pick the example that matches your use case the closest (see below).
3. Create a folder specific to the client (i.e. ./clients/SOME-BIG_COMPANY) and copy over the example.
4. Customize the code to your use case, testing in a sandbox environment.
5. Test and Validate things work as expected.
6. Zip up the code and ship to the client for code review, getting the code into their source control.
7. Deploy and Validate in the client environment.
8. Contribute back to master and example, submodule, or documentation changes that could be helpful.

## All Examples

All examples are very similar but differ by the choice of load balancing.

This section is applicable for each example.

### How to Run (quick)

- `cd` into an example folder.
- Create a `terraform.tfvars` file (check out the README.md in the examples folder for a complete list of variables)
```
namespace            = "USERNAME-tfe"
location             = "centralus"
domain               = "company.com"
subdomain            = "tfe"
distribution         = "ubuntu"
public_ip_allowlist  = [
  "x.x.x.x", # Your current IP
]
tags = {
  owner = "USERNAME"
}
```

- Place your TFE License file in `./keys/tfe-license.rli`
- If using the `tls` module provided, please do the following first:
  - Create a blank pfx file `touch ./keys/certificate.pfx`.
  - Target apply the TLS module `terraform apply -target module.tls`
  - There is a concurrency issue, this will generate the PFX file format from the created cert.
  - NOTE: Fix for this is in progress, feel free to create your own certs instead of using the provided tls module
- `terraform plan` and `terraform apply`

### Potential Issues

One potential issue is the need for TLS certificates that are publicly trusted, these examples use Let's Encrypt (sub-module `modules/tls-acme`) for such tasks however it does require you own a domain. You can instead use self-signed certificate (also available as a sub-module `modules/tls-private`), however this will lead to VCS integration challenges for Public SaaS Git Repo's.

### Modules

Examples are just wired up modules from the `/modules/` directory.

#### tls

Helpful modules to generate TLS certificates.

Optionally you can bring your own keys.

There are two in this repository:

* tls-acme
  * Uses Let's Encrypt.
  * You must own a domain and have access to update DNS for the challenge.
* tls-private
  * Creates a private CA and then generates a cert from that.

#### networking

Creates the needed Azure Networking layer that is needed for the example to run.

Resources created:

* Azure Virtual Network (Vnet)
* Azure Subnets
* Azure Network Security Group (NSG)
* Associated NSG Rules
* Bastion (Azure VM)
  * Needed to access underlying TFE Instance.
  * Optional if you can network route by other means (Express Route, etc...)

#### external-services

Creates the external services needed, specifically the database and object storage.

Resources created:

* Azure Postgres
* Azure Storage Account

#### configs

Creates the configuration files and startup script needed to install TFE.

To enable debugging, by default this module will create files in `.terraform/*` that have the exact same contents as what will be deployed to the instance.

Specifically these files are created:

* `.terraform/replicated-conf.json`
  * replicated config file
* `.terraform/replicated-tfe-conf.json`
  * TFE config files
* `.terraform/startup_script.sh`
  * startup script to run on VM first boot

One handy trick to quickly develop/change these configs is to run a `terraform apply -target module.configs` and validate that these files look correct.

To configure TLS use this block:

```hcl
tls_config = {
  self-signed = false # When true, the replicated config will be "self-signed", when false it will be "server-path"
  cert        = "FULL CHAIN PEM ENCODED CERT"
  key         = "CERT PRIVATE KEY"
}
```

To configure Airgap (if desired) use this block:

```hcl
tfe_airgap = {
  enabled        = true # When true adds airgap bits to startup script
  url            = "URL TO DOWNLOAD AIRGAP BUNDLE"
  replicated_url = "URL TO DOWNLOAD REPLICATED TAR"
}
```

#### key-vault

Creates an Azure Key Vault and write secrets to it.

This is helpful when you wish to keep secrets out of the startup script and rather have the instance pull these during first boot.

Resource created:

* Azure Key Vault
  * Firewall active to restrict to the subnet the instance is running on

#### load-balancer

Helpful modules to create the load-balancer level.

This will vary based on which example you are using.

More details are in the "Specific Examples" section

There are three in this repository:

* public-load-balancer
  * TLS Pass-through
  * Requires public IP
* public-application-gateway
  * TLS Termination and Pass-through (Cert must be on both AAG and the instance)
  * App Gateway v2
* private-application-gateway
  * TLS Termination and Pass-through (Cert must be on both AAG and the instance)
  * App Gateway v1

#### tfe

Creates the infrastructure to run Terraform Enterprise.

Resource created:

* Azure VM Scale Set (VMSS)
  * Creates an Managed Service Identity (MSI)
  * Authorizes the VMSS MSI to read secrets from Azure Key Vault

##  Specific Examples

There are several end to end examples to demonstrate a few common scenarios.

Each example can be run to go from nothing, to deployed TFE application.

### Public Load Balancer

The Azure Public Load Balancer is a layer-4 LB and offers the simplest solution Azure has to offer. In this mode you must do TLS pass-through and can not use a Web Application Firewall (WAF), although this is often mitigated with other firewall appliances that sit in front of the Load Balancer.

**Requirements**

* TFE License (*.rli)
* Publicly Trusted TLS [VCS Integration and SSO]
* Public DNS Entry [VCS Integration and SSO]

For more details view the example [README](examples/public-load-balancer/README.md)

### Public Application Gateway

The Azure Public Application Gateway is a layer-7 LB and offers more features at the cost of complexity (and reliability). In this mode you can do TLS termination, however, you must also serve the same certificate on the backend instances essentially creating a pass-through scenario. You can use a Web Application Firewall (WAF) in this configuration, however we do not at this time have specific configurations for TFE specifically, rather generic OWASP Top 10 type attack vector protections. Overall the Application Gateway typically causes more problems than it solves. In the Public configuration, Application Gateway can utilize version 2 of the PaaS in Azure.

**Requirements**

* TFE License (*.rli)
* Publicly Trusted TLS [VCS Integration and SSO]
* Public DNS Entry [VCS Integration and SSO]

For more details view the example [README](examples/public-application-gateway/README.md)

### Private Application Gateway

The Azure Private Application Gateway is a layer-7 LB and offers more features at the cost of complexity (and reliability). In this mode you can do TLS termination, however, you must also serve the same certificate on the backend instances essentially creating a pass-through scenario, you must also upload a private CA bundle to the Application Gateway. Overall the Application Gateway typically causes more problems than it solves. In the Private configuration, Application Gateway can utilize **ONLY** version 1 of the PaaS in Azure.

**Requirements**

* TFE License (*.rli)

For more details view the example [README](examples/private-application-gateway/README.md)

## Azure Highlights & Gotchas

Notes around Azure specifics.

### Virtual Machine Scale Sets

The Azure VMSS is used in an attempt to self heal, but also recover from a zonal outage.
These should **always** be kept to a scale of 1.

### Public Azure Load Balancer

The Public Azure Load Balancer is not capable of doing TLS Termination so you must place the full chain TLS Cert/Key in PEM format on the instance running TFE.

### Private Azure Load Balancer

For a completely private TFE installation that is not reachable by the internet, the Private Azure Load Balancer will **not** work. Instead you must opt for the Private Application Gateway.

This is due to a limitation with the Private Azure Load Balancer's inability to do loopback (i.e. the instance running TFE must be able to resolve to itself, from itself, through the Load Balancer)

### Azure Application Gateway

There are two versions indicated by SKU's such as "Standard" and "Standard_v2".

Both versions are rather difficult to work with and lacking consistency found in other cloud providers.

* Private Application Gateway - must use v1 ("Standard") SKU's

## TODO

- [x] Add RHEL support
- [x] Add airgap support
- [ ] Add WAF examples to the AAG's
- [ ] Figure out proper VMSS self healing configuration (i.e. can kill replicated/TFE, and the app will rebuild)
- [ ] Determine cleaner way to generate a PFX from PEM encoded cert/issuer/keys

## Known Issues

Some Known Issues

### Private Azure Application Gateway unable to set specific Zones

```
Error: Error Creating/Updating Application Gateway "tfe-aag-appgateway" (Resource Group "tfe-aag-rg"): network.ApplicationGatewaysClient#CreateOrUpdate: Failure sending request: StatusCode=400 -- Original Error: Code="SubscriptionNotRegisteredForFeature" Message="Subscription /subscriptions//resourceGroups//providers/Microsoft.Network/subscriptions/ is not registered for feature AllowApplicationGatewayZonePinning required to carry out the requested operation." Details=[]
```

## Tools

Here are a few helpful tools for working with this repository.

### [sshuttle](https://github.com/sshuttle/sshuttle)

Poor man's VPN, allows proxy access through a bastion to get to private network instances.

**config**
```sh
ssh_ident="./.terraform/id_rsa.pem"
ssh_username="tfeadmin"
ssh_bastion="bastion-credible-kitten.centralus.cloudapp.azure.com"
ssh_cidr="10.0.0.0/24"
ssh_instance="10.0.0.6"
```

**bastion**
```sh
ssh-add $ssh_ident && sshuttle -r "${ssh_username}@${ssh_bastion}" $ssh_cidr
```

**client**
```sh
ssh-add $ssh_ident && ssh "${ssh_username}@${ssh_instance}"
```

### [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform)

Great utility for keep documentation up to date, also used for formatting and light validation.

```sh
brew install pre-commit terraform-docs
```

Ensure versions are at least:
* pre-commit >= 1.20.0
* terraform-docs >= 0.8.2

```sh
brew upgrade pre-commit terraform-docs
```

[terraform-docs](https://github.com/segmentio/terraform-docs)

### [openssl](https://www.openssl.org/)

TLS certificate manipulation.

**Inspect a PFX for full chain**
```sh
openssl pkcs12 -info -in certificate.pfx
```
