# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "wp_sg" {
  name   = "wp-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Local variables block for configuration values
locals {
    aws_key = "east1-key"   # SSH key pair name for EC2 instance access
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   user_data = file("${path.module}/wp_install.sh")
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name
  
   vpc_security_group_ids = [aws_security_group.wp_sg.id]

   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }                  
}
