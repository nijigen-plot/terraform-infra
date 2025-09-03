# terraform_remote_stateで参照するoutput tfstateのルートにないと読まれないため、modules下に入れてるoutputからコッチにも持ってこないといけない
# 設計ミスったかな・・・
output "ecs_task_iam_role_arn" {
  description = "The ARN of the ECS Task IAM Role"
  value       = module.iam.ecs_task_iam_role_arn
}

output "ecs_task_exec_iam_role_arn" {
  description = "The ARN of the ECS Task execution IAM Role"
  value       = module.iam.ecs_task_exec_iam_role_arn
}
