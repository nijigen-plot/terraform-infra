module "log_group" {
  source       = "./modules"
  service_name = "terraform-tutorial"
  env          = terraform.workspace
}
