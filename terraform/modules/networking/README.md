# Azure Networking

Creates a base set of networking infrastructure that can be used to deploy instances to. Also will create a Bastion to allow for access to the private instances.

* Virtual Network
* Subnets (names/CIDR's that are provided)
* Bastion
* Network Security Group rules to provide initial set of security

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| bastion | Bastion public ssh username and key. | <pre>object({<br>    username   = string<br>    public_key = string<br>  })</pre> | <pre>{<br>  "public_key": "",<br>  "username": ""<br>}</pre> | no |
| common\_tags | The tags to apply to all resources. | `map` | `{}` | no |
| location | The Azure region to deploy all infrastructure to. | `any` | n/a | yes |
| namespace | Name to assign to resources for easy organization. | `any` | n/a | yes |
| public\_ip\_allowlist | List of public IPs that need direct access to the PaaS in the Vnet. | `list(string)` | `[]` | no |
| resource\_group\_name | Name of the Resource Group to place resources in. | `any` | n/a | yes |
| subnet\_address\_spaces | A list of subnet address spaces and names. | <pre>list(object({<br>    name          = string<br>    address_space = string<br>  }))</pre> | n/a | yes |
| vnet\_address\_space | The network address CIDR for the Vnet address space. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion | Bastion connectiong configuration. |
| location | n/a |
| networking | Networking configuration. |
| resource\_group\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->