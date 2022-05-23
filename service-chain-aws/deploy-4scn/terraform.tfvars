# name           = ""   # Name of every resource's name tag
# region         = ""   # AWS region name to create all resources
# scn_subnet_ids = ["", ""]   # A list of subnets to place SCN instance nodes. It could be better set to private subnet if it need to run without public IPs
# en_subnet_ids  = ["", ""]   # A list of subnets to place EN instance nodes. It usually set to public subnet contrary to scn_subnet_ids
# grafana_subnet_ids  = ["", ""]   # A list of subnets to place grafana instance nodes. It should be set to public subnet in order to access grafana web UI via browser
# vpc_id         = ""   # VPC id where the SCN, EN instance nodes will be created
# ssh_client_ips = [""] # A list of CIDRs to access SCN, EN, grafana instance nodes by SSH
# ssh_pub_key    = ""   # SSH Public key to access SCN instance nodes, EN instance nodes
