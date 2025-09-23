variable "oicd_additional_tags" {
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

variable "iam_role_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the IAM Role"

    validation {
        condition = length(setintersection(keys(var.iam_role_additional_tags), ["Env", "ServiceName"])) == 0
        error_message = "Key names, Name and Env, ServiceName is reserved. Not allowed to use them."
    }
}

variable "github_organization_name" {
    type = string
}

variable "github_repository_name" {
    type = string
}

variable "managed_iam_policy_arns" {
    type = list(string)
    default = []
    description = "List of managed IAM policy ARNs to attach to the IAM Role"
}


variable "ecr_manipulation_iam_policy_arn" {
    type = string
    description = "The ARN of the IAM policy that allows ECR manipulation"
    default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"

    validation {
        condition = can(regex("^arn:aws:iam::aws:policy/.*", var.ecr_manipulation_iam_policy_arn))
        error_message = "Specify the ARN of an AWS managed IAM policy."
    }
}

variable "ecs_task_role_managed_policy_arns" {
    type = list(string)
    description = "Specify Arn list for ECS task role managed policy."
    # ここにポリシー入れる。アプリが何をするかに依存する。参考書ではただhtml配置してるだけなので全く要らない
    default = [
    ]
    validation {
        condition = length(var.ecs_task_role_managed_policy_arns) <= 10
        error_message = "Number of managed policies attached must be at most 10."
    }
}

variable "ecs_service_arn" {
    type = string
}

variable "task_role_arn" {
    type = string
}

variable "task_definition_arn_without_revision" {
    type = string
}
