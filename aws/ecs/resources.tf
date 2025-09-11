data "terraform_remote_state" "log_group" {
  backend = "s3"
  workspace = "dev"
  config = {
    bucket = "nijipro-terraform"
    key = "aws/cloudwatch-logs/cloudwatch-logs.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  workspace = "dev"
  config = {
    bucket = "nijipro-terraform"
    key = "aws/iam/iam.tfstate"
    region = "ap-northeast-1"
  }
}



module "ecs" {
  source             = "./modules"
  service_name       = "terraform-tutorial"
  env                = terraform.workspace
  task_role_arn      = data.terraform_remote_state.iam.outputs.ecs_task_iam_role_arn
  task_exec_role_arn = data.terraform_remote_state.iam.outputs.ecs_task_exec_iam_role_arn
  log_group_name     = data.terraform_remote_state.log_group.outputs.log_group_name
  alb_subnet_ids = data.aws_subnets.public_subnets.ids
  alb_security_group_ids = [
    module.alb_security_group.security_group_id
  ]
  alb_https_certificate_arn = module.ecs.aws_acm_certificate_arn
  alb_vpc_id = data.aws_vpc.vpc.id
  ecs_service_cluster_arn = data.aws_ecs_cluster.cluster.arn
  ecs_service_subnets = data.aws_subnets.private_subnets.ids
  ecs_service_security_groups = [
    module.ecs_security_group.security_group_id
  ]
  ecs_service_alb_target_group_arn = module.alb.alb_target_group_arn
  ecs_service_alb_target_group_container_name = "nginx"
}
