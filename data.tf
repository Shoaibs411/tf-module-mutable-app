# Ensure the AMI that you use has ANSIBLE Installed.

data "aws_ami" "image" {
  most_recent      = true
  name_regex       = "centos7-with-ansible"
  owners           = ["355449129696"]              # Use your account number
}

# Datasource to fetch the information from the VPC Remote Statefile
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "b56-terraform-state--bucket"
    key     = "vpc/${var.ENV}/terraform.tfstate"
    region  = "us-east-1"
  }
}

# Datasource to fetch the information from the ALB Remote Statefile
data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket  = "b56-terraform-state--bucket"
    key     = "alb/${var.ENV}/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket  = "b56-terraform-state--bucket"
    key     = "${var.ENV}/dbs/terraform.tfstate"
    region  = "us-east-1"
  }
}

# Extracting the information of the secrects
data "aws_secretsmanager_secret" "secrets" {
  name = "roboshop/secrets"
}

# Extracting the secrect version(value) from the secrets
data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}