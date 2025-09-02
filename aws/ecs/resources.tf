module "ecs" {
  source = "./modules"
  service_name = "ecs"
  env = terraform.workspace
  task_role_arn = module.roles.task_role_arn
  task_exec_role_arn = module.roles.task_exec_role_arn
  log_group_name = module.log_group.log_group_name
}
