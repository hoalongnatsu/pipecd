terraform {
  backend "s3" {
    bucket                  = ""
    key                     = "pipecd"
    region                  = "ap-southeast-1"
    encrypt                 = true
    role_arn                = ""
    dynamodb_table          = ""
    shared_credentials_file = "/etc/piped-secret/credentials"
  }
}

provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["/etc/piped-secret/credentials"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical Ubuntu AWS account id
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Hello PipeCD"
  }
}
