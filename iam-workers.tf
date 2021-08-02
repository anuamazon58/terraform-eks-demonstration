resource "aws_iam_role" "eks-demonstration-node" {
  name = "terraform-eks-demonstration-node"  

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "eks-demonstration-node-AmazonEKSWorkerNodePolicy" {  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-demonstration-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks-demonstration-node.name
}

resource "aws_iam_role_policy_attachment" "eks-demonstration-node-AmazonEC2ContainerRegistryReadOnly" {  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks-demonstration-node.name
}

resource "aws_iam_instance_profile" "eks-demonstration-node" {  
  name = "terraform-eks-demonstration"
  role = aws_iam_role.eks-demonstration-node.name
}

