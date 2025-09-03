module "iam" {
  source                   = "./modules"
  service_name             = "iam"
  env                      = terraform.workspace
  github_repository_name   = "terraform-infra"
  github_organization_name = "nijigen-plot"
}
