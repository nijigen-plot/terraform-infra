terraform {
  backend "s3" {
    bucket       = "nijipro-terraform"
    key          = "github/repository/repository.tfstate"
    region       = "ap-northeast-1"
    profile      = "terraform"
    use_lockfile = true
  }
}
