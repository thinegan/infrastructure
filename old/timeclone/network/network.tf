data "aws_vpc" "devVPC" {
  id = "vpc-0a13318dad0969600"
}

data "aws_subnet" "devVPC_private_1" {
  id = "subnet-0169c42b35dc69382"
}

data "aws_subnet" "devVPC_private_2" {
  id = "subnet-097fd0624c14889b2"
}

data "aws_subnet" "devVPC_private_3" {
  id = "subnet-013a80383ac4e1d63"
}

data "aws_subnet" "devVPC_public_1" {
  id = "subnet-0bf3744387b41d80b"
}

data "aws_subnet" "devVPC_public_2" {
  id = "subnet-0f667940a9f5773af"
}

data "aws_subnet" "devVPC_public_3" {
  id = "subnet-02a3a2ae2798b0703"
}



locals {
  devVPC = {
    vpc = {
      id = data.aws_vpc.devVPC.id
      cidr_block = data.aws_vpc.devVPC.cidr_block
    }
    private_subnet = [
      {
        id = data.aws_subnet.devVPC_private_1.id
      },
      {
        id = data.aws_subnet.devVPC_private_2.id
      },
      {
        id = data.aws_subnet.devVPC_private_3.id
      }
    ]
    public_subnet = [
      {
        id = data.aws_subnet.devVPC_public_1.id
      },
      {
        id = data.aws_subnet.devVPC_public_2.id
      },
      {
        id = data.aws_subnet.devVPC_public_3.id
      }
    ]
  }
}

output "devVPC" {
  value = local.devVPC
}
