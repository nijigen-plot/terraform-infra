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
}
