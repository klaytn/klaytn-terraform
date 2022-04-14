output "vpc_id" {
  description = "Created VPC's ID"
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Created public subnets' IDs"
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Created private subnets' IDs"
  value = module.vpc.private_subnets
}
