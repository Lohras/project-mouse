output vpcid {
  value       = module.vpc.default_vpc_id
}

output securitygroupid {
  value       = module.vpc.default_security_group_id

}

output publicsubnet {
  value       = module.vpc.public_subnets

}

output privatesubnet {
  value       = module.vpc.private_subnets
}

output privatert {
  value       = module.vpc.private_route_table_ids

}
