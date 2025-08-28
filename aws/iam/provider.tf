terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.10.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Resource = "Terraform"
    }
  }
}

provider "tls" {
}

provider "http" {
}
