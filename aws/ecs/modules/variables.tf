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

variable "ecs_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the ECS Cluster"
    validation {
        condition = length(setintersection(keys(var.ecs_additional_tags),
        ["ServiceName", "Env"])) == 0
        error_message = "Key names, ServiceName and Env is reserved. Not allowed to use them."
    }
}

variable "task_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the ECS Task Definition"
    validation {
        condition = length(setintersection(keys(var.task_additional_tags),
        ["ServiceName", "Env"])) == 0
        error_message = "Key names, ServiceName and Env is reserved. Not allowed to use them."
    }
}

# タスクで割り当てたCPUの量をコンテナが上回ってはいけない。
variable "task_cpu_allocation" {
    type = number
    # 1024ってやったら1vCPUになる
    # https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
    description = "The number of CPU units used by the task"
    default = 1024
}

variable "task_memory_allocation" {
    type = number
    description = "The amount of memory (in MiB) used by the task"
    default = 2048
}

variable "task_role_arn" {
    type = string
    description = "The ARN of the IAM role that the task can assume. Reference from outside of this module."

    validation {
        condition = can(regex("^arn:aws:iam::aws:role/.*", var.task_role_arn))
        error_message = "Specify the ARN of an AWS managed IAM Role."
    }
}

variable "task_exec_role_arn" {
    type = string
    description = "The ARN of the IAM role that the task can assume for execution. Reference from outside of this module."

    validation {
        condition = can(regex("^arn:aws:iam::aws:role/.*", var.task_exec_role_arn))
        error_message = "Specify the ARN of an AWS managed IAM Role."
    }
}

variable "log_group_name" {
    type = string
    description = "The name of the CloudWatch log group to use for the ECS Task logs. Reference from outside of this module."
}

variable "container_base" {
    type = string
    description = "Base container definition of the ECS Task in JSON format without awslogs-stream-prefix and awslogs-group"
    default = <<DEFAULT
    {
        "name": "nginx",
        "image": "nginx:1.21-alpine",
        "cpu": 1024,
        "memory": 2048,
        "essential": true,
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 80
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-region": "ap-northeast-1"
            }
        }
    }
    DEFAULT
    validation {
        condition = can(jsondecode(var.container_base))
        error_message = "Specify the base container definition in JSON format."
    }
}
