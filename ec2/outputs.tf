output "public_instance_ip" {
  value = module.ec2_instance.public_ip
}

output "nat_instance_ip" {
  value = aws_instance.natinstance.public_ip
}


output "private_instance_ip" {
  value = aws_instance.privateinstance.private_ip
}

output public_key {
  value       = aws_key_pair.deployer.public_key
}
