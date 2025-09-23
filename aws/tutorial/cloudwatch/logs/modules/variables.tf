variable "service_name" {
    type = string
    description = "Service name"
}

variable "env" {
    type = string
    description = "Environment Identifier"

    validation {
        condition = contains(["dev", "stg", "prod"], var.env)
        error_message = "Specify the environment identifier as 'dev', 'stg', or 'prod'"
    }
}

variable "log_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the CloudWatch Logs"
}

variable "log_retention_in_days" {
    description = "CloudWatch Logs Log Retain days period."
    type = number
    default = 30
}
