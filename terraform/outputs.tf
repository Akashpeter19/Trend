output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "vpc_id" {
  value = aws_vpc.main.id
}
