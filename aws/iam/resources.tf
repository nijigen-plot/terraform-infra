data "terraform_remote_state" "ecs" {
  backend = "s3"
  workspace = "dev"
  config = {
    bucket = "nijipro-terraform"
    key = "aws/ecs/ecs.tfstate"
    region = "ap-northeast-1"
  }
}


module "iam" {
  source                   = "./modules"
  service_name             = "terraform-tutorial"
  env                      = terraform.workspace
  github_repository_name   = "terraform-infra"
  github_organization_name = "nijigen-plot"
  ecs_service_arn = data.terraform_remote_state.ecs.outputs.ecs_service_arn
  task_role_arn = data.terraform_remote_state.ecs.outputs.task_definition_arn
  task_definition_arn_without_revision = data.terraform_remote_state.ecs.outputs.task_definition_arn_without_revision
}
