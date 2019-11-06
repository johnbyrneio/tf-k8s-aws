# Kubernetes on AWS Using Terraform

The Terraform config that deploys a basic Kubernetes cluster on AWS. It's intented for testing and 
demos, not for production.

You will need an AMI with Docker, kubectl, and kubeadm installed. You can build one using the Packer
template found at https://github.com/johnbyrneio/packer-kubeadm