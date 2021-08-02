resource "aws_eks_cluster" "eks-demonstration-cluster" {  
  name     = var.eks-demo-cluster-name
  role_arn = aws_iam_role.eks-demonstration-cluster-role.arn


  vpc_config {
    security_group_ids = [aws_security_group.eks-demonstration-cluster-group.id]
    subnet_ids = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-demonstration-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-demonstration-cluster-AmazonEKSServicePolicy,
  ]
}

