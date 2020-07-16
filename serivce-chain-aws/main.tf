terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.43"
  region  = var.region
}

