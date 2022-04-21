provider "aws" {
  region = "ap-northeast-2"
}

locals {
  name = "service-chain-test"
  tags = {
    Terraform   = "true"
    Environment = "service-chain-vpc"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = local.name
  cidr               = "10.0.0.0/16"
  azs                = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
  tags               = local.tags
}

module "klaytn-service-chain" {
  source = "github.com/klaytn/klaytn-terraform/serivce-chain-aws"

  name           = local.name
  region         = "ap-northeast-2"
  scn_subnet_ids = slice(module.vpc.private_subnets, 0, 2)
  en_subnet_ids  = module.vpc.public_subnets
  vpc_id         = module.vpc.vpc_id
  ssh_client_ips = ["132.122.144.33/32"]
  ssh_pub_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSUGPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XAt3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/EnmZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbxNrRFi9wrf+M7Q== mypublicsshkey@mylaptop.local"
  tags           = local.tags
}
