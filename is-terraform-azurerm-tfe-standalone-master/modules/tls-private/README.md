# Private TLS Certificates

Creates private CA, then creates a private TLS cert from that CA.

Not recommended for production, but provides a good base for testing common scenarios with private certificate authorities.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| local | n/a |
| null | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| certificate\_duration | Length in hours for the certificate and authority to be valid. Defaults to 6 months. | `number` | `4320` | no |
| certificate\_password | The PFX certificate password. | `any` | n/a | yes |
| certificate\_path | The path on disk that has the PFX certificate. | `any` | n/a | yes |
| domain | The domain you wish to use, this will be subdomained. `example.com` | `any` | n/a | yes |
| hostname | The full hostname that will be used. `tfe.example.com` | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cert | Full chain certificate in PEM format. |
| cert\_b64 | The PEM certification in base64. |
| key | Certification key in PEM format. |
| name | Readable name of the certificate. |
| password | The password used to create the PFX. |
| pfx\_b64 | The PFX certification in base64. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->