# TFE Configs

Creates all the configuration files needed to install and configure TFE.

Output is simply a BASH script for maximum portability. Not all cloud images support Cloud-Init, so this was an active decision.

## RHEL

[Azure CLI Install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-yum?view=azure-cli-latest)

[Azure RHEL Images](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/redhat/redhat-rhui)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| local | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| add\_bash\_debug | If set to true, write some helpful debugging Bash bits to /etc/profile.d/tfe.sh. | `bool` | `false` | no |
| distribution | Type of linux distribution to use. (ubuntu or rhel). | `string` | `"ubuntu"` | no |
| hostname | FQDN of the tfe application (i.e. tfe.company.com). | `any` | n/a | yes |
| license\_file | Path to license file for the application. | `string` | n/a | yes |
| object\_store\_config | Object storage configuration. | <pre>object({<br>    account_name = string<br>    account_key  = string<br>    container    = string<br>  })</pre> | <pre>{<br>  "account_key": "",<br>  "account_name": "",<br>  "container": ""<br>}</pre> | no |
| postgres\_config | Postgres configuration. | <pre>object({<br>    netloc       = string<br>    dbname       = string<br>    user         = string<br>    password     = string<br>    extra_params = string<br>  })</pre> | <pre>{<br>  "dbname": "",<br>  "extra_params": "",<br>  "netloc": "",<br>  "password": "",<br>  "user": ""<br>}</pre> | no |
| release\_sequence | The sequence ID for the Terraform Enterprise version to pin the cluster to. | `string` | `"latest"` | no |
| settings-source | Source of the settings, either local or azkeyvault. When local, you must pass in tls\_config, postgres\_config, and object\_store\_config. When azkeyvault, settings are read from azure key vault at run time. | `string` | `"local"` | no |
| tfe\_airgap | TFE airgap bundlle url. | <pre>object({<br>    enabled        = bool<br>    url            = string<br>    replicated_url = string<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "replicated_url": "",<br>  "url": ""<br>}</pre> | no |
| tfe\_install\_url | TFE installer script url. Defaults to HashiCorp hosted link. | `string` | `"https://install.terraform.io/ptfe/stable"` | no |
| tls\_config | TLS configuration to use with TFE. Default will use self-signed. | <pre>object({<br>    self-signed = bool<br>    cert        = string<br>    key         = string<br>  })</pre> | <pre>{<br>  "cert": "",<br>  "key": "",<br>  "self-signed": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| console\_password | The generated password for the admin console. |
| key\_vault\_secrets | Secrets that can be written to Azure Key Vault and then read from the instance during first boot. |
| startup\_script | Rendered BASH file to use instead of cloud-init (for cases when cloud-init is not present). |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->