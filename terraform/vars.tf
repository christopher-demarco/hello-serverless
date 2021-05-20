variable "environment" {
  type = string
  description = <<-EOT
  This is prepended to the `domain` var to generate the
  FQDN at which a given release will be made available. This is set
  automatically via deploy workflows to the value of the current
  branch. Use this default--or set your own value--in development.
  EOT
}

variable "domain" {
  type = string
  description = <<-EOT
  The domain component of the FQDN at which a given
  release will be made available. Set this via the TF_VAR_domain env
  var in development; set automatically via deploy workflows using the
  TF_VAR_domain GitHub Secret.
  EOT
}

variable "state_bucket" {
  type = string
  description = <<-EOT
  The S3 bucket where state will be stored, which must already exist.
  This variable is only used by Terragrunt to configure the backend.
  EOT
}
