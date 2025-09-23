locals {
    alb_target_group_tags = merge(
        var.alb_target_group_additional_tags,
        {
            ServiceName = var.service_name
            Env = var.env
        }
    )
}
resource "aws_alb_target_group" "target_group" {
    name = "${var.service_name}-${var.env}-alb-tg"
    vpc_id = var.alb_vpc_id
    target_type = "ip"

    port = var.alb_target_group_port
    protocol = "HTTP"

    health_check {
        enabled = true
        port = var.alb_target_group_port # portは共有で
        path = var.alb_target_group_health_check_path
        interval = var.alb_target_group_health_check_interval
        healthy_threshold = var.alb_target_group_health_check_healthy_threshold
        unhealthy_threshold= var.alb_target_group_health_check_healthy_threshold # チェック回数も共有で
        matcher = "200-299"
    }

    tags = local.alb_target_group_tags
}
