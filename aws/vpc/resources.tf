locals {
    vpc_cidr = "10.0.0.0/16"
}

module "vpc" {
  source         = "./modules"
  service_name   = "terraform-vpc"
  env            = terraform.workspace
  vpc_cidr_block = local.vpc_cidr
  subnet_cidrs = {
    public = [
        cidrsubnet(local.vpc_cidr, 6, 1),
        cidrsubnet(local.vpc_cidr, 6, 2),
    ]
    private = [
        cidrsubnet(local.vpc_cidr, 6, 10),
        cidrsubnet(local.vpc_cidr, 6, 20),
    ]
  }
  vpc_additional_tags = {
    Resource = "Terraform"
  }
}
