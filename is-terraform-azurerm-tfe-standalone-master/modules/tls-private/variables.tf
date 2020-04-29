variable "domain" {
  description = "The domain you wish to use, this will be subdomained. `example.com`"
}

variable "hostname" {
  description = "The full hostname that will be used. `tfe.example.com`"
}

variable "certificate_path" {
  description = "The path on disk that has the PFX certificate."
}

variable "certificate_password" {
  description = "The PFX certificate password."
}

variable "certificate_duration" {
  description = "Length in hours for the certificate and authority to be valid. Defaults to 6 months."
  default     = 24 * 30 * 6
}
