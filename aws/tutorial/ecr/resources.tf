module "ecr" {
  source       = "./modules"
  service_name = "terraform-tutorial"
  # このroleはECRのリポジトリがどのロールかという意味。AWS IAM Roleじゃないよ
  role = "app"
  env          = terraform.workspace
}
