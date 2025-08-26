module "vpc" {
  source         = "./modules"
  service_name   = "terraform-vpc"
  env            = terraform.workspace
  vpc_cidr_block = "10.0.0.0/16"
  vpc_additional_tags = {
    Resource = "Terraform"
  }
}
