
locals {
   homeoffice_cidr_block = "192.168.0.0/16"
 }

resource "aws_ec2_client_vpn_endpoint" "MyVPNDemo" {
  description            = "terraform-clientvpn-demo"
  server_certificate_arn = "arn:aws:acm:us-east-1:204995021158:certificate/2712e838-7df3-498c-908b-cae2b1202965"
  client_cidr_block      = local.homeoffice_cidr_block
  split_tunnel           = true
  dns_servers            = ["8.8.8.8", "8.8.4.4"]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:us-east-1:204995021158:certificate/e975d338-fdce-4e7f-ac4d-206ff9a36975"
  }

  connection_log_options {
    enabled               = false
    # cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }

  tags = {
    Name = "MyVPN-Endpoint"
    ManagedBy = "Terraform"
  }
}

##########################################################
# Route VPN ClientEndpoint to private subnets
##########################################################
resource "aws_ec2_client_vpn_network_association" "MyVPNDemo_Network_Assoc1" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.MyVPNDemo.id
  subnet_id              = data.terraform_remote_state.devVPC.outputs.private_subnets[0]
  security_groups        = [aws_security_group.my_vpn_sg.id]
  lifecycle {
    ignore_changes = [subnet_id] # This is a hack to fix a bug: https://github.com/terraform-providers/terraform-provider-aws/issues/7597
  }
}

resource "aws_ec2_client_vpn_network_association" "MyVPNDemo_Network_Assoc2" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.MyVPNDemo.id
  subnet_id              = data.terraform_remote_state.devVPC.outputs.private_subnets[1]
  security_groups        = [aws_security_group.my_vpn_sg.id]
  lifecycle {
    ignore_changes = [subnet_id] # This is a hack to fix a bug: https://github.com/terraform-providers/terraform-provider-aws/issues/7597
  }
}

resource "aws_ec2_client_vpn_network_association" "MyVPNDemo_Network_Assoc3" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.MyVPNDemo.id
  subnet_id              = data.terraform_remote_state.devVPC.outputs.private_subnets[2]
  security_groups        = [aws_security_group.my_vpn_sg.id]
  lifecycle {
    ignore_changes = [subnet_id] # This is a hack to fix a bug: https://github.com/terraform-providers/terraform-provider-aws/issues/7597
  }
}

##########################################################
# Add authorization rules to grant clients access to the networks.
##########################################################
resource "aws_ec2_client_vpn_authorization_rule" "MyVPC_Authorize" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.MyVPNDemo.id
  target_network_cidr    = data.terraform_remote_state.devVPC.outputs.vpc_cidr_block
  authorize_all_groups   = true
  description            = "Allow vpn client to related VPC network only"
}

##########################################################
# Security Group(SG) for VPN
# Allow all inbound/outbout traffic within private subnets
##########################################################
resource "aws_security_group" "my_vpn_sg" {
  name        = "MyVPNSG"
  description = "Allow all inbound/outbout traffic within private subnets"
  vpc_id      = data.terraform_remote_state.devVPC.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MyVPNSG"
  }
}

output "my_vpn_sg" {
  value = aws_security_group.my_vpn_sg
}