variable "vpcname" {
  type        = string
  default     = "mouse-vpc"
  description = "VPC for project mouse"
}


variable "vpccidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "privatesubnetname" {
  type    = string
  default = "private"
}

variable "privatesubnet" {
  type        = list(string)
  default     = ["192.168.3.0/24"]
  description = "private subnet for private/db instances"
}

variable "publicsubnetname" {
  type    = string
  default = "public"
}


variable "publicsubnet" {
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
  description = "public subnet"
}
