terraform {
  backend "s3" {
    bucket       = "nijipro-terraform"
    key          = "aws/cloudwatch-logs/cloudwatch-logs.tfstate"
    region       = "ap-northeast-1"
    profile      = "terraform"
    use_lockfile = true
  }
}
