provider "aws" {
  region  = "us-east-1"
}

resource "aws_security_group" "k8s-masters" {
  name        = "${var.prefix}-k8s-masters"
  description = "Kubernetes Masters"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-k8s-masters"
  }
}

resource "aws_security_group" "k8s-workers" {
  name        = "${var.prefix}-k8s-workers"
  description = "Kubernetes Workers"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-k8s-workers"
  }
}

resource "aws_instance" "k8s-master" {
  ami           = var.image_id
  instance_type = var.instance_size
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.k8s-masters.id]

  tags = {
    Name = "${var.prefix}-k8s-master"
  }

  user_data = <<EOF
#!/bin/bash
/usr/local/bin/k8s-master-init
/usr/bin/kubeadm token create ${var.k8s_join_token}
  EOF
}

resource "aws_instance" "k8s-workers" {
  count = var.worker_count
  ami           = var.image_id
  instance_type = var.instance_size
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.k8s-workers.id]

  tags = {
    Name = "${var.prefix}-k8s-worker-${count.index}"
  }
  
  user_data = <<EOF
#!/bin/bash
/usr/bin/kubeadm join ${aws_instance.k8s-master.private_ip}:6443 --token ${var.k8s_join_token} --discovery-token-unsafe-skip-ca-verification
  EOF
}
