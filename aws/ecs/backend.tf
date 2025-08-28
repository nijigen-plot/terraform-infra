terraform {
  backend "s3" {
    bucket       = "nijipro-terraform"
    key          = "aws/ecs/ecs.tfstate"
    region       = "ap-northeast-1"
    profile      = "terraform"
    use_lockfile = true
  }
}
