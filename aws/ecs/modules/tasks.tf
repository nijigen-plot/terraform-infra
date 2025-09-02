locals {
    task_resource_tags = merge(
        var.task_additional_tags,
        {
            ServiceName = var.service_name
            Env = var.env
        }
    )
    task_family_name = "${var.service_name}-${var.env}-task"
    container_base = jsondecode(var.container_base)
    container_definition = merge(
        jsondecode(local.container_base),
        {
            logConfiguration = merge(
                local.container_base.logConfiguration, {
                    options = merge(
                        local.container_base.logConfiguration.options, {
                            "awslogs-group" = var.log_group_name
                            "awslogs-stream-prefix" = var.service_name
                        }
                    )
                }
            )
        }
    )
}

resource "aws_ecs_task_definition" "task_definition" {
    family = local.task_family_name
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = var.task_cpu_allocation
    memory = var.task_memory_allocation
    task_role_arn = var.task_role_arn
    execution_role_arn = var.task_exec_role_arn
    container_definitions = local.container_definition
    tags = local.task_resource_tags
    lifecycle {
        ignore_changes = [
            container_definitions
        ]
    }
}
