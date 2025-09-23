variable "s3_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the IAM OIDC Provider"
}

variable "service_name" {
    type = string
    description = "Service name"
}

variable "env" {
    type = string
    description = "Environment Identifier"

    validation {
        condition = contains(["dev", "stg", "prod"], var.env)
        error_message = "Specify the environment identifier as 'dev', 'stg', or 'prod'."
    }
}

variable "prefix" {
    type = string
    description = "the prefix for to make it unique"
}

variable "force_destroy" {
    type = bool
    default = false
}

variable "s3_bucket_versioning_status" {
    type = string
    description = "S3 Bucker Versioning setting"

    validation {
        condition = contains(["Enabled", "Disabled"], var.s3_bucket_versioning_status)
        error_message = "Specify the environment identifier as 'Enabled' or 'Disabled'."
    }
}
