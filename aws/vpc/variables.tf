variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "VPC CIDR block"

    validation {
        condition = can(regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}", var.vpc_cidr_block))
        error_message = "Specify VPC CIDR block with the CIDR format."
    }
}

variable "vpc_name" {
    type = string
    description = "VPC name"
}

variable "env" {
    type = string
    description = "Environment Identifier"

    validation {
        condition = contains(["dev", "stg", "prod"], var.env)
        error_message = "Specify the environment identifier as 'dev', 'stg', or 'prod'."
    }
}

variable "vpc_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the VPC"
}
