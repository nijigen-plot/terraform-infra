module "ecr" {
  source       = "./modules"
  service_name = "ecr"
  # このroleはECRのリポジトリがどのロールかという意味。AWS IAM Roleじゃないよ
  role = "app"
  env          = terraform.workspace
}
