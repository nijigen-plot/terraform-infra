module "vpc" {
  source         = "./modules"
  service_name   = "terraform-ecs"
  env            = terraform.workspace
  cluster_additional_tags = {
    Resource = "Terraform"
  }
}
