##Amazon Infrastructure
provider "aws" {
  region = var.aws_region
  shared_credentials_file = var.aws_credentials_path
}

##Create MLLSGD security group
resource "aws_security_group" "MLLSGD" {
  name        = "MLLSGD"
  description = "Allow all inbound traffic necessary"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags = {
    Name = "MLLSGD"
  }
}

##Find latest Ubuntu 16.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

##Create MLLSGD worker instances.
resource "aws_instance" "MLLSGD-workers" {
  depends_on             = ["aws_security_group.MLLSGD"]
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.aws_instance_size
  vpc_security_group_ids = [aws_security_group.MLLSGD.id]
  key_name               = var.aws_key_name
  count                  = var.aws_worker_count
  tags = {
    Name = "MLLSGD-worker-${count.index}"
  }
}

##KeyvaluePairs
resource "aws_key_pair" "terraform-keys" {
  key_name = "terraform-keys"
  public_key = file("./terraform-keys.pub")
}