module "iam" {
  source                   = "./modules"
  service_name             = "terraform-tutorial"
  env                      = terraform.workspace
  github_repository_name   = "terraform-infra"
  github_organization_name = "nijigen-plot"
}
