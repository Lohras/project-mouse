module "network" {
  source = "../vpc"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.publicinstance_name

  ami                    = var.normalami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.id
  monitoring             = true
  vpc_security_group_ids = tolist([module.network.securitygroupid])
  subnet_id              = module.network.publicsubnet[0]
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum install http* -y
    sudo systemctl restart httpd
    sudo chown -R $USER:$USER /var/www/html
    sudo echo "<html><body><h1>Hello , This is the webserver</h1></body></html>" >> /var/www/html/index.html
    EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "natinstance" {
  ami                         = var.natami
  instance_type               = var.instance_type
  subnet_id                   = module.network.publicsubnet[1]
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = aws_key_pair.deployer.id
  vpc_security_group_ids      = tolist([module.network.securitygroupid])
  tags = {
    Name = "Nat instance "
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = ""
}

resource "aws_security_group_rule" "myingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [var.zerocidr]
  ipv6_cidr_blocks  = [var.ipv6cidr]
  security_group_id = module.network.securitygroupid
}
