terraform {
  backend "s3" {
    bucket       = "nijipro-terraform"
    key          = "aws/ecr/ecr.tfstate"
    region       = "ap-northeast-1"
    profile      = "terraform"
    use_lockfile = true
  }
}
