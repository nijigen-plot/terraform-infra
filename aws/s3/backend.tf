terraform {
    backend "s3" {
        bucket = "nijipro-terraform"
        key = "aws/s3/s3.tfstate"
        region = "ap-northeast-1"
        profile = "terraform"
        use_lockfile = true
    }
}
