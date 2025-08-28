variable "service_name" {
    type = string
    description = "Service name"
}

# コンテナイメージリポジトリについてはenvで環境を分ける必要が無いかもしれない。
# 個別で分けて、動作が問題無ければdev→stg→prodの順にプロモーション（昇級・起用の意）していっても良い
variable "env" {
    type = string
    description = "Environment Identifier"

    validation {
        condition = contains(["dev", "stg", "prod"], var.env)
        error_message = "Specify the environment identifier as 'dev', 'stg', or 'prod'."
    }
}

variable "role" {
    type = string
    description = "ECR Repository Role Inside the ECS Task"
}

variable "image_tag_mutability" {
    type = string
    description = "The tag mutability setting for the repository"
    default = "MUTABLE"

    validation {
        condition = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
        error_message = "Specify the image tag mutability as 'MUTABLE' or 'IMMUTABLE'."
    }
}

variable "repository_lifecycle_policy" {
    type = string
    description = "The JSON repository policy text. If this is empty, the default lifecycle_policy.json will be applied."
    default = <<DEFAULT
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Expire untagged images older than 30days",
                "selection": {
                    "tagStatus": "untagged",
                    "countType": "sinceImagePushed",
                    "countUnit": "days",
                    "countNumber": 30
            },
                "aciton": {
                    "type": "expire"
                }
            }
        ]
    }
    DEFAULT
}
