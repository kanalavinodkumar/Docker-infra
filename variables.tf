variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  type = string
  default = "default"
}

variable "common_tags" {
    type = map
    default = {
        Name = "Infra"
        Environment = "DEV"
        Terraform = "TRUE"
    }
}

variable "public_subnet_cidr" {
  type = list
  description = "Provide 2 public subnet cidr"
  validation {
    condition = (
      length(var.public_subnet_cidr) == 2
      )
      error_message = "CIDR list must be 2"
  }
}

variable "public_subnet_name" {
  type = list
  validation {
    condition = (
      length(var.public_subnet_name) == 2
      )
      error_message = "Subnet name list must be 2"
  }
}


variable "private_subnet_cidr" {
  type = list
  description = "Provide 2 private subnet cidr"
  validation {
    condition = (
      length(var.private_subnet_cidr) == 2
      )
      error_message = "CIDR list must be 2"
  }
}

variable "private_subnet_name" {
  type = list
  validation {
    condition = (
      length(var.private_subnet_name) == 2
      )
      error_message = "Subnet name list must be 2"
  }
}


variable "ingress" {
  type = map
  default = {
    
    postgress = {
    description      = "Allow 443 port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    http = {
    description      = "Allow 80 port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    Jenkins = {
    description      = "Allow 8080 port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    ssh = {
    description      = "Allow 22 port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  
}