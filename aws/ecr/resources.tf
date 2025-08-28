module "ecr" {
  source       = "./modules"
  service_name = "ecr"
  role = ""
  env          = terraform.workspace
}
