# Public Application Gateway

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.0 |
| local | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| certificate\_password | The PFX certificate password. | `string` | `""` | no |
| certificate\_path | The path on disk that has the PFX certificate. | `string` | `"./keys/certificate.pfx"` | no |
| distribution | The images tested for the TFE submodule. (ubuntu or rhel). | `any` | n/a | yes |
| domain | The domain you wish to use, this will be subdomained. `example.com`. | `any` | n/a | yes |
| location | The location to place all the resources. | `any` | n/a | yes |
| namespace | The name to prefix to resources to keep them unique. | `any` | n/a | yes |
| public\_ip\_allowlist | List of public IP addresses to allow into the network. This is required for access to the PaaS services (AKV, SA, Postgres) and the bastion. | `list` | `[]` | no |
| subdomain | The subdomain you wish to use `mycompany-tfe` | `any` | n/a | yes |
| tags | Tags to apply to the resource group/resources. | `map` | `{}` | no |
| tfe\_airgap\_url | The encoded Storage Account SAS URL to download an airgap bundle. | `string` | `""` | no |
| tfe\_license\_file | Full local path to a valid TFE license file (\*.rli) | `string` | `"./keys/tfe-license.rli"` | no |
| tfe\_replicated\_url | The encoded Storage Account SAS URL to download an replicated tar. | `string` | `""` | no |
| vm\_admin\_username | The username to login to the TFE Virtual Machines | `string` | `"tfeadmin"` | no |
| vnet\_address\_space | The virtual network address CIDR. | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion | Bastion access values. |
| tfe | TFE access values. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->