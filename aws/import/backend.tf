terraform {
    backend "s3" {
        bucket = "nijipro-terraform"
        key = "aws/import/import.tfstate"
        region = "ap-northeast-1"
        profile = "terraform"
        use_lockfile = true
    }
}
