# Let's Encrypt TLS Certificates

Creates publicly trusted TLS Certificates.

Requires access to a domain you own and the ability to provide a DNS challenge request.

This example uses Azure DNS as the challenge, but [many others](https://www.terraform.io/docs/providers/acme/dns_providers/index.html) are supported.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| acme | n/a |
| local | n/a |
| null | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| certificate\_password | The PFX certificate password. | `any` | n/a | yes |
| certificate\_path | The path on disk that has the PFX certificate. | `any` | n/a | yes |
| domain | The domain you wish to use, this will be subdomained. `example.com` | `any` | n/a | yes |
| hostname | The full hostname that will be used. `tfe.example.com`. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cert | Full chain certificate in PEM format. |
| key | Certification key in PEM format. |
| name | Readable name of the certificate. |
| password | The password used to create the PFX. |
| pfx\_b64 | The PFX certification in base64. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->