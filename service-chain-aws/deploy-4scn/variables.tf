variable "scn_instance_count" {
  description = "The Number of SCN node"
  default     = 4
}

variable "en_instance_count" {
  description = "The Number of EN node"
  default     = 1
}

variable "en_instance_type" {
  description = "EN instance node type"
  default     = "m5.2xlarge"
}

variable "scn_instance_type" {
  description = "SCN instance node type"
  default     = "m5.xlarge"
}

variable "scn_subnet_ids" {
  description = "A list of subnets to place SCN instance nodes. It could be better set to private subnet if it need to run without public IPs"
  type        = list(string)
}

variable "en_subnet_ids" {
  description = "A list of subnets to place EN instance nodes. It usually set to public subnet contrary to scn_subnet_ids"
  type        = list(string)
}


variable "name" {
  description = "Name of every resource's name tag"
  type        = string
  default     = "test"
}

variable "vpc_id" {
  description = "VPC id where the SCN, EN instance nodes will be created"
  type        = string
}

variable "ssh_client_ips" {
  description = "A list of CIDRs to access SCN, EN instance nodes by SSH"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "region" {
  description = "Region where all resources will be created"
  default     = "ap-northeast-2"
  type        = string
}

variable "scn_ebs_volume_size" {
  description = "EBS volume size to attach SCN nodes"
  default     = 50
}

variable "en_ebs_volume_size" {
  description = "EBS volume size to attach EN nodes. default volume indicate minimum size in klaytn docs"
  default     = 500
}

variable "ssh_pub_key" {
  description = "SSH Public key to access SCN instance nodes, EN instance nodes"
  type        = string
}
variable "aws_key_pair_name" {
  description = "A key pair is used to control login access to EC2 instances"
  type        = string
  default     = "ServiceChain-common"
}

variable "scn_public_ip" {
  description = "Whether to create a public IP for the SCN instance nodes. They have public ips by default. EN instance nodes have public IPs"
  type        = bool
  default     = true
}

variable "security_group" {
  description = "Security group name to attach SCN and EN instance nodes"
  type        = string
  default     = "ServiceChain-common"
}
