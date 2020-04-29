# Azure External Services

Create the database and object storage external servics in Azure.

* Azure Postgres
* Azure Storage Account

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
| location | The Azure region to deploy all infrastructure to. | `any` | n/a | yes |
| namespace | Name to assign to resources for easy organization. | `any` | n/a | yes |
| postgres\_sku\_name | SKU Short name: tier + family + cores | `string` | `"GP_Gen5_2"` | no |
| postgres\_user | Postgres user name. | `string` | `"psqladmin"` | no |
| public\_ip\_allowlist | List of public IPs that need direct access to the PaaS in the Vnet (Optional). | `list(string)` | `[]` | no |
| resource\_group\_name | Name of the Resource Group to place resources in. | `any` | n/a | yes |
| storage\_account | Storage Account Azure settings. | <pre>object({<br>    tier = string<br>    type = string<br>  })</pre> | <pre>{<br>  "tier": "Standard",<br>  "type": "LRS"<br>}</pre> | no |
| subnet\_id | The subnet id to place the External Services in. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| object\_storage\_config | Object storage configuration. |
| postgres\_config | Database storage configuration. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->