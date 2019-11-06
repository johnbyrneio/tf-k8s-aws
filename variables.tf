variable "prefix" {
  type = string
  default = "default"
  description = "Each resource's name tag will be prefixed with this"
}

variable "image_id" {
  type = string
  description = "AMI to use. github.com/johnbyrneio/packer-kubeadm can build this for you"
}

variable "instance_size" {
  type = string
  default = "t2.medium"
  description = "EC2 instance size"
}

variable "key_name" {
  type = string
  description = "SSH keypair name"
}

variable "worker_count" {
  type = number
  default = 2
  description = "Number of Kubernetes workers to deploy"
}

variable "k8s_join_token" {
  type = string
  description = "Pre-generated token for joining new worker nodes. Use kubeadm token generate to create one."
}