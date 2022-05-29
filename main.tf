provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "customesecuritygroup" {
  name = "SecGroup"
  description = "SecGroup"
  vpc_id = "vpc-0bf361f11d863dcf9"

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
// To Allow Port 8080 Transport
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "master" {
  ami = "ami-09d56f8956ab235b3"
  instance_type = "t2.micro"
  subnet_id = "subnet-07ebcdbf37e9fab2e"
  associate_public_ip_address = true
  key_name = "DemoPub"


  vpc_security_group_ids = [
    aws_security_group.customesecuritygroup.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
  }
  tags = {
    Name = "Master"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.customesecuritygroup ]
}

resource "aws_instance" "node" {
count = 2
  ami = "ami-09d56f8956ab235b3"
  instance_type = "t2.micro"
  subnet_id = "subnet-07ebcdbf37e9fab2e"
  associate_public_ip_address = true
  key_name = "DemoPub"


  vpc_security_group_ids = [
    aws_security_group.customesecuritygroup.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
  }
  tags = {
    Name ="NODE-${count.index}"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.customesecuritygroup ]
}


output "ec2instance" {
  value = aws_instance.master.public_ip
}
