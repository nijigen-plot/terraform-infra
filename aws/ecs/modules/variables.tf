# localsのdomain系だけややこしいのでメモ
# 1. まず空文字の状態でterraform applyしてECS/ALB作成
# 2. ALBのDNS名でHTTPアクセス確認
# 3. Route53でホストゾーン作成（terraform-sample.quark-hardcore.com）
# 4. LightsailでNSレコード追加（Route53のネームサーバーを指定）
# 5. certificate_domain = "terraform-sample.quark-hardcore.com"に変更
# 6. terraform applyでSSL証明書作成
# 7. Route53でAliasレコード作成（ALBのDNS名を指定）
locals {
    ecs_cluster_name = "${var.service_name}-${var.env}-cluster"
    ecs_task_family = "${var.service_name}-${var.env}-task"
    certificate_domain = ""
    dns_hosted_zone_domain = ""
    dns_a_record = ""
    ecs_service_is_load_balancer_active = var.ecs_service_alb_target_group_arn != "" ? [1] : []
}

data "aws_acm_certificate" "certificate" {
    domain = local.certificate_domain
}

data "aws_ecs_task_definition" "task_definition" {
    task_definition = local.ecs_task_family
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

variable "ecs_service_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the ECS Service"
    validation {
        condition = length(setintersection(keys(var.ecs_service_additional_tags),
        ["ServiceName", "Env"])) == 0
        error_message = "Key names, ServiceName and Env is reserved. Not allowed to use them."
    }
}

variable "alb_target_group_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the ALB Target Group"
    validation {
        condition = length(setintersection(keys(var.alb_target_group_additional_tags),
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
        condition = can(regex("^arn:aws:iam::[0-9]{12}:role/.*", var.task_role_arn))
        error_message = "Specify the ARN of an AWS managed IAM Role."
    }
}

variable "task_exec_role_arn" {
    type = string
    description = "The ARN of the IAM role that the task can assume for execution. Reference from outside of this module."

    validation {
        condition = can(regex("^arn:aws:iam::[0-9]{12}:role/.*", var.task_exec_role_arn))
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

variable "alb_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the ALB"
    validation {
        condition = length(setintersection(keys(var.alb_additional_tags),
        ["ServiceName", "Env"])) == 0
        error_message = "Key names, ServiceName and Env is reserved. Not allowed to use them."
    }
}

variable "alb_subnet_ids" {
    type = list(string)
    description = "Subnet ID list for ALB arrangement."

    validation {
        condition = length(var.alb_subnet_ids) > 0
        error_message = "Specify at least 1 subnet to place application load balancer."
    }
}

variable "alb_security_group_ids" {
    type = list(string)
    description = "Security Group ID list for ALB attachment"
    default = []
}

variable "alb_enable_http_listener" {
    type = bool
    description = "Specify Enable or Disable ALB HTTP Listener"
    default = true
}

variable "alb_enable_https_listener" {
    type = bool
    description = "Specify Enable or Disable ALB HTTPS Listener"
    default = true
}
variable "alb_enable_redirect_http_to_https" {
    type = bool
    description = "Specify Enable or Disable ALB HTTP to HTTPS redirect."
    default = true
}

variable "alb_https_listener_ssl_policy" {
    type = string
    description = "Specify SSL policy for ALB HTTP Listener"
    default = "ELBSecurityPolicy-2016-08"
}

variable "alb_https_certificate_arn" {
    type = string
    description = "SSL for ALB HTTP listener"
    default = "" # ここ依存関係を持ちつつ今の構成難しいので発行後確認してハードコードする
}

variable "alb_vpc_id" {
    type = string
    description = "VPC ID for ALB arrangement. Need a target group settings."
}

variable "alb_target_group_port" {
    type = string
    description = "Listening port number of target group"
    default = 80
}

variable "alb_target_group_health_check_path" {
    type = string
    description = "target group health check path"
    default = "/"
}

variable "alb_target_group_health_check_interval" {
    type = number
    description = "once health check interval (sec)"
    default = 30
}

variable "alb_target_group_health_check_healthy_threshold" {
    type = number
    description = "health check limit number"
    default = 3
}

variable "alb_log_bucket_name" {
    type = string
    description = "ALB Log S3 Bucket Name"
}

variable "alb_log_bucket_arn" {
    type = string
    description = "ALB Log S3 Bucket Arn"
}

variable "alb_log_bucket_id" {
    type = string
    description = "ALB Log S3 Bucket ID"
}

variable "ecs_service_enable_execute_command" {
    type = bool
    description = "ECS Execの有効化の有無。docker execみたいなやつ"
    default = false
}

variable "ecs_service_alb_target_group_container_port" {
    type = number
    description = "ecs_service_alb_target_group_container_nameでリッスンしているポート番号を指定します。"
    default = 80
}

variable "ecs_service_task_desired_count" {
    type = number
    description = "ECSサービスで実行するECSタスクの希望多重度"
    default = 3
}

variable "ecs_service_task_maximum_percent" {
    type = number
    description = "ECSサービスで実行するECSタスクの希望多重度(ecs_service_task_desired_count)に対して最大で何%までのタスク実行を許容するか？"
    default = 200
}

variable "ecs_service_task_minimum_percent" {
    type = number
    description = "ECSサービスで実行するECSタスクの希望多重度(ecs_service_task_desired_count)に対して最小で何%までのタスク実行を許容するか？"
    default = 100
}

variable "ecs_service_cluster_arn" {
    type = string
    description = "The ARN of the ECS cluster to which the ECS service belongs"
}

variable "ecs_service_subnets" {
    type = list(string)
    description = "List of the Subnet ID to which the ECS service belongs"
}

variable "ecs_service_security_groups" {
    type = list(string)
    description = "List of the Security Group ID to which the ECS service belongs"
}

variable "ecs_service_alb_target_group_arn" {
    type = string
    description = "ALB Target group ARN for ECS Service arrangement"
    default = ""
}

variable "ecs_service_deployment_controller" {
    type = string
    description = "Deploy use Controller setting of ECS Service"
    default = "ECS"
}

variable "ecs_service_alb_target_group_container_name" {
    type = string
}

variable "ecs_service_task_definition_arn" {
    type = string
    description = "The ARN of the ECS task definition to run in the ECS service."
    default = "" # ここ依存関係を持ちつつ今の構成難しいので発行後確認してハードコードする
}
