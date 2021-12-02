variable publicinstance_name {
  type        = string
  default     = "public instance"
}



variable "normalami" {
  type        = string
  default     = "ami-002068ed284fb165b"
  description = "normal ami with SSD volume type"
}

variable "natami" {
  type        = string
  default     = "ami-001e4628006fd3582"
  description = "nat ami for connecting to private instance/db's"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "this is for instance type"
}

variable "zerocidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable ipv6cidr {
  type        = string
  default     = "::/0"
}
