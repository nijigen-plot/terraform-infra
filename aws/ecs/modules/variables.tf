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

variable "cluster_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the ECS Cluster"
    validation {
        condition = length(setintersection(keys(var.cluster_additional_tags),
        ["ServiceName", "Env"])) == 0
        error_message = "Key names, ServiceName and Env is reserved. Not allowed to use them."
    }
}
