terraform {
  required_version = ">=1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0"
    }
  }

  # TerraformのステートをS3に保管したりできる。一旦ローカルで。
  # backend "s3" {
    # bucket = ""
    # key = ""
    # region = ""
    # use_lockfile = true
    # }
}
provider "aws" {
  region = "ap-northeast-1"
}
