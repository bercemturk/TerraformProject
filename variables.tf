variable rs_location {
  default = "East US"
}
variable rs_name {
  default = "resource-group-team2"
}
variable security_group {
  default = "team2-security-group"
}
variable vnet_name {
  default = "team2-network"
}
variable vnet_cidr {
  default = ["10.0.0.0/16"]
}

variable public_subnet1 {
  default = "10.0.1.0/24"
}


variable public_subnet2 {
  default = "10.0.2.0/24"
}


variable public_subnet3 {
  default = "10.0.3.0/24"
}

variable tags {
    type =map 
    default = {
        name = "team2"
    }
}