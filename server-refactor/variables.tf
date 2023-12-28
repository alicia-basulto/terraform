variable "server_port" {
  description = "Puerto para las instancias EC2"
  type        = number
  default     = 8080

  validation {
    condition     = var.server_port > 0 && var.server_port <= 65536
    error_message = "El valor del puerto debe estar comprendido entre 1 y 65536."
  }
}
# we use a for each loop instead a count loop 
# because two servers have different names and AZ

variable "servers" {
  description = "Map of servers with names and AZs"
  type = map(object({name = string, az = string}))
  default = {
    server1 = {
      name = "server-1"
      az = "a"
    }
    server2 = {
      name = "server-2"
      az = "b"
    }
  }
}
variable "lb_port" {
  description = "Puerto para el Load Balancer"
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "Tipo de la instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "ubuntu_ami" {
  description = "AMI por region"
  type        = map(string)

  default = {
    eu-west-1 = "ami-0aef57767f5404a3c" # Ubuntu en Dublin
    us-west-2 = "ami-005383956f2e5fb96" # Ubuntu en London
  }
}