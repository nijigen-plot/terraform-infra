locals {
    iam_role_tags = merge(
        var.iam_role_additional_tags,
        {
            ServiceName = var.service_name
            Env = var.env
        }
    )
}

# AWS CLIのaws sts get-caller-identityみたいなもん
data "aws_caller_identity" "caller_identity" {}

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        effect = "Allow"
        principals {
            type = "Federated"
            identifiers = [
                "arn:aws:iam::${data.aws_caller_identity.caller_identity.account_id}:oidc-provider/token.actions.githubusercontent.com"
            ]
        }
        actions = [
            "sts:AssumeRoleWithWebIdentity"
        ]

        # 特定のリポジトリからのアクセスを許可
        condition {
            test = "StringLike"
            # :subはJWT標準クレームの一つ OIDCには必須
            variable = "token.actions.githubusercontent.com:sub"
            values = [
                "repo:${var.github_organization_name}/${var.github_repository_name}:*"
            ]
        }

        # sts.amazonaws.comに限定
        condition {
            test = "StringEquals"
            variable = "token.actions.githubusercontent.com:aud"
            values = [
                "sts.amazonaws.com"
            ]
        }
    }
}

data "aws_iam_policy_document" "assume_role_document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "ecs-tasks.amazonaws.com"
            ]
        }
        actions = [
            "sts:AssumeRole"
        ]
    }
}

resource "aws_iam_role" "role" {
    name = "${var.service_name}-${var.env}-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "managed_policy_attachments" {
    role = aws_iam_role.role.name
    policy_arn = "${var.ecr_manipulation_iam_policy_arn}"
}

resource "aws_iam_role" "ecs_task_role" {
    name = "${var.service_name}-${var.env}-ecs-task-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
    for_each = toset(var.ecs_task_role_managed_policy_arns)
    role = aws_iam_role.ecs_task_role.arn
    policy_arn = each.key
}

resource "aws_iam_role" "ecs_task_exec_role" {
    name = "${var.service_name}-${var.env}-ecs-task-exec-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role_document.json
}

data "aws_iam_policy_document" "ecs_task_exec_role_policy_document" {
    version = "2012-10-17"
    statement {
        sid = "ECRPullImage"
        actions = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid = "CloudWatchPutLog"
        actions = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [
            "*"
        ]
    }
}

resource "aws_iam_role_policy" "ecs_task_exec_role_policy" {
    role = aws_iam_role.ecs_task_exec_role.id
    policy = data.aws_iam_policy_document.ecs_task_exec_role_policy_document.json
}
