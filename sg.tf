# Creates Security Group for Backend Components

resource "aws_security_group" "allows_app" {
    name                    = "roboshop-${var.COMPONENT}-${var.ENV}"
    description             = "roboshop-${var.COMPONENT}-${var.ENV}"
    vpc_id                  = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description             = "SSH for Default and Robot VPC"
    from_port               = 22
    to_port                 = 22
    protocol                = "tcp"
    cidr_blocks             = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR, data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

   ingress {
    description             = "App only Traffic"
    from_port               = 8080
    to_port                 = 8080
    protocol                = "tcp"
    cidr_blocks             = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR, data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  tags = {
    Name                    = "roboshop-${var.COMPONENT}-${var.ENV}"
  }
}
