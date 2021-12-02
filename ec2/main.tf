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

resource "aws_instance" "privateinstance" {
  ami                         = var.normalami
  instance_type               = var.instance_type
  subnet_id                   = module.network.privatesubnet[0]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.deployer.id
  vpc_security_group_ids      = tolist([module.network.securitygroupid])
  tags = {
    Name = "private instance/db instance"
  }
}

resource "aws_route" "privateroute" {
  route_table_id         = module.network.privatert[0]
  destination_cidr_block = var.zerocidr
  instance_id            = aws_instance.natinstance.id

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9FVZci53q2H7qQE6aVZ07EBTr7s6oWAzr3G6PPyLDG4kKQCfgtU/mQCQ4M+6yUMYh6c3y4aHs35rriuXSsID2VPPsVu3u53AN15k/y8CukqaEhDc2XirNNyH8by0XRzsyZ8jcd5thUUdhovfG6FQyFLHOJ0XDD4l64kWnTBzEyYxYVqCUHA7Jy4m6FEEOML3yPj84peHdhdx6l3TpJvbD1wMB3AWimtn+2JKjFHjKfpkxP3BTagreHxdj/kENa//y6O99Z0pilyxFeJN/6Cf7Y42VHrKdYhDKEiMkvZOa97+hkGK+fzQ3UQVqcIzSq5sOO+oB5orcpJp/0szco93SSco6ONxGlaXCiwJZ0d0a92dp1I+ixO/6KNmasHEF44CypUH1celY0DOZsd5iqhkum5nOHmYiCkwqLQkMcn7U2DJNd7FmgTTriA1E2GJLKUvKpJ/pCDVCW34vcIw3KIRFesN7yvQokSIqwhdQW/MvgXxLVEGp20VSiNjU5vwOc10= aravinth@Aravinth"
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