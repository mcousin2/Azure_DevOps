# README

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| common\_tags | The tags to apply to all resources. | `map` | `{}` | no |
| lb\_sku | Load Balancer SKU (Standard or Basic). | `string` | `"Standard"` | no |
| location | The Azure region to deploy all infrastructure to. | `any` | n/a | yes |
| namespace | Name to assign to resources for easy organization. | `any` | n/a | yes |
| resource\_group\_name | Name of the Resource Group to place resources in. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| backend\_address\_pool\_id | Backend addresss pool, for use with the VM Scale Set. |
| health\_probe\_id | Health Probe Id for the health checks on the load balancer. |
| load\_balancer\_domain\_label | Public FQDN of the Load Balancer. DNS provided by Azure. |
| load\_balancer\_id | Load Balancer id. |
| public\_ip | Public IP of the Load Balancer. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->