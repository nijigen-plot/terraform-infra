locals {
    alb_tags = merge(
        var.alb_additional_tags,
        {
            ServiceName = var.service_name
            Env = var.env
        }
    )
}

resource "aws_lb" "alb" {
    name = "${var.service_name}-${var.env}-alb"
    internal = false
    enable_deletion_protection = var.env == "prod" ? true : false
    load_balancer_type = "application"
    subnets = var.alb_subnet_ids
    security_groups = var.alb_security_group_ids
    access_logs {
        bucket = "${var.alb_log_bucket_name}"
        enabled = true
    }
    tags = local.alb_tags
}

data "aws_iam_policy_document" "log_bucket_policy_document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                # https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/enable-access-logging.html
                # ALBのアクセスログをS3に書き込みたい場合、東京リージョンは以下アカウントIDが対象となる。
                "arn:aws:iam::582318560864:root"
            ]
        }
        actions = [
            "s3:PutObject"
        ]
        resources = [
            "${var.alb_log_bucket_arn}",
            "${var.alb_log_bucket_arn}/*"
        ]
    }
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
    bucket = "${var.alb_log_bucket_id}"
    policy = data.aws_iam_policy_document.log_bucket_policy_document.json
}

resource "aws_alb_listener" "http_listener_forward" {
    # countが0の場合リソースは作られない
    count = (
        var.alb_enable_http_listener
        && !var.alb_enable_redirect_http_to_https) ? 1 : 0
    load_balancer_arn = aws_lb.alb.arn
    protocol = "HTTP"
    port = 80
    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.target_group_arn
    }
    tags = local.alb_tags
}

resource "aws_alb_listener" "http_listener_redirect" {
    count = (
        var.alb_enable_http_listener
        && var.alb_enable_redirect_http_to_https) ? 1 : 0
    load_balancer_arn = aws_lb.alb.arn
    protocol = "HTTP"
    port = 80
    default_action {
        type = "redirect"

        redirect {
            port = "443"
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
    tags = local.alb_tags
}

resource "aws_alb_listener" "https_listener" {
    count = var.alb_enable_https_listener ? 1 : 0
    load_balancer_arn = aws_lb.alb.arn
    protocol = "HTTPS"
    port = 443
    ssl_policy = var.alb_https_listener_ssl_policy
    certificate_arn = var.alb_https_certificate_arn
    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.target_group.arn
    }
    tags = local.alb_tags
}
