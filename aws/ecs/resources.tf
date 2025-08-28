module "vpc" {
  source         = "./modules"
  service_name   = "ecs"
  env            = terraform.workspace
  additional_tags = {
    Resource = "Terraform"
  }
}
