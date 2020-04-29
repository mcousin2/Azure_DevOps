# Azure Key Vault

Create a Key Vault to store TFE specific settings that can be retrieved during the first boot.

Will also add an access policy to the AKV for the identity creating the AKV, this will allow visibility of secrets in the Azure Portal. However, this can be removed and is only here for debugging purposes.

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
| public\_ip\_allowlist | List of public IPs that need direct access to the PaaS in the Vnet (Optional). | `list(string)` | `[]` | no |
| resource\_group\_name | Name of the Resource Group to place resources in. | `any` | n/a | yes |
| secrets | Secrets to save to the Azure Key Vault. | <pre>list(object({<br>    name         = string<br>    content_type = string<br>    value        = string<br>  }))</pre> | `[]` | no |
| subnet\_id | The subnet id to place the External Services in. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| keyvault | Key vault secrets configuration. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->