module "log_group" {
  source       = "./modules"
  service_name = "cloudwatch-log"
  env          = terraform.workspace
}
