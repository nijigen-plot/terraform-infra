module "vpc" {
  source       = "./modules"
  service_name = "ecs"
  env          = terraform.workspace
  ecs_additional_tags = {
  }
}
