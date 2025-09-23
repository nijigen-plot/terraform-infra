output "iam_role_arn" {
    description = "The ARN of the IAM Role"
    value = aws_iam_role.role.arn
}

output "iam_role_name" {
    description = "The name of the IAM Role Name"
    value = aws_iam_role.role.name
}

output "ecs_task_iam_role_arn" {
    description = "The ARN of the ECS Task IAM Role"
    value = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_iam_role_name" {
    description = "The name of the IAM Role Name"
    value = aws_iam_role.ecs_task_role.name
}

output "ecs_task_exec_iam_role_arn" {
    description = "The ARN of the ECS Task execution IAM Role"
    value = aws_iam_role.ecs_task_exec_role.arn
}

output "ecs_task_exec_iam_role_name" {
    description = "The ARN of the ECS Task execution IAM Role Name"
    value = aws_iam_role.ecs_task_exec_role.name
}
