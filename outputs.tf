output "master_public_ip" {
  value = aws_instance.k8s-master.public_ip
}
output "worker_public_ips" {
  value = aws_instance.k8s-workers.*.public_ip
}