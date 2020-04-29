# Terraform Enterprise

Creates the infrastructure to host TFE.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| common\_tags | The tags to apply to all resources. | `map` | `{}` | no |
| keyvault\_id | The Azure KeyVault id to use for secrets. | `string` | `""` | no |
| lb | Load balancer to attach to the VMSS. Type must be one of the following ['ALB', 'AAG']. | <pre>object({<br>    type                    = string<br>    backend_address_pool_id = string<br>    health_probe_id         = string<br>  })</pre> | n/a | yes |
| location | The Azure region to deploy all infrastructure to. | `any` | n/a | yes |
| namespace | Name to assign to resources for easy organization. | `any` | n/a | yes |
| resource\_group\_name | Name of the Resource Group to place resources in. | `any` | n/a | yes |
| startup\_script | Startup script to install and configure TFE. | `string` | `""` | no |
| subnet\_id | The subnet id to place the External Services in. | `any` | n/a | yes |
| tfe\_image | Marketplace image for VMSS. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | <pre>{<br>  "offer": "UbuntuServer",<br>  "publisher": "Canonical",<br>  "sku": "18.04-LTS",<br>  "version": "latest"<br>}</pre> | no |
| vm\_sku | The VM instance SKU to use. | `string` | `"Standard_D2s_v3"` | no |
| vm\_user | VM username and public ssh key. | <pre>object({<br>    username   = string<br>    public_key = string<br>  })</pre> | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->