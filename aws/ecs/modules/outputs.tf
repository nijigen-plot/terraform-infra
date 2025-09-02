output "ecs_cluster_name" {
    value = aws_ecs_cluster.cluster.name
}

output "ecs_cluster_arn" {
    value = aws_ecs_cluster.cluster.arn
}

output "task_definition_arn" {
    value = aws_ecs_task_definition.task_definition.arn
}

output "task_family_name" {
    value = aws_ecs_task_definition.task_definition.family
}
