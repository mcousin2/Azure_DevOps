# Azure Application Gateway (Private)

Creates a private Application Gateway.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| common\_tags | The tags to apply to all resources. | `map` | `{}` | no |
| hostname | FQDN of the tfe application (i.e. tfe.company.com). | `any` | n/a | yes |
| ip\_address | The static IP address to assign the App Gateway on the private network. | `any` | n/a | yes |
| location | The Azure region to deploy all infrastructure to. | `any` | n/a | yes |
| namespace | Name to assign to resources for easy organization. | `any` | n/a | yes |
| resource\_group\_name | Name of the Resource Group to place resources in. | `any` | n/a | yes |
| subnet\_id | The subnet id to place the External Services in. | `any` | n/a | yes |
| tls | TLS Certificate configuration. | <pre>object({<br>    name         = string<br>    pfx_b64      = string<br>    pfx_password = string<br>    cert_b64     = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| application\_gateway\_id | Application Gateway id. |
| backend\_address\_pool\_id | Backend addresss pool, for use with the VM Scale Set. |
| health\_probe\_id | Health Probe Id for the health checks on the load balancer. |
| private\_ip | Private IP of the Application Gateway. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->