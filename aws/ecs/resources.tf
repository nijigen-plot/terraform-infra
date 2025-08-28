module "vpc" {
  source         = "./modules"
  service_name   = "terraform-ecs"
  env            = terraform.workspace
  additional_tags = {
    Resource = "Terraform"
  }
}
