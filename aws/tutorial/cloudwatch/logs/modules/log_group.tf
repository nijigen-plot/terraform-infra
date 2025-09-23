resource "aws_cloudwatch_log_group" "log_group" {
    name = "${var.service_name}-${var.env}-log-group"
    retention_in_days = var.log_retention_in_days
    tags = merge(
        var.log_additional_tags,
        {
            Name = var.service_name
            Env = var.env
        }
    )
}
