# terraform_remote_stateで参照するoutput tfstateのルートにないと読まれないため、modules下に入れてるoutputからコッチにも持ってこないといけない
# 設計ミスったかな・・・
output "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = module.log_group.log_group_name
}
