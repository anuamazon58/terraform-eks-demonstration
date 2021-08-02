data "aws_ami" "eks-demonstration-worker" {  
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks-demonstration-cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

locals {
eks-demonstration-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-demonstration-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-demonstration-cluster.certificate_authority[0].data}' '${var.eks-demo-cluster-name}'
USERDATA

}

resource "aws_launch_configuration" "launch-config-demonstration" {  
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.eks-demonstration-node.name
  image_id = data.aws_ami.eks-demonstration-worker.id
  instance_type = "t2.medium"
  name_prefix = "terraform-eks-demonstration"
  security_groups = [aws_security_group.eks-demonstration-node-wrkgrp.id]
  user_data_base64 = base64encode(local.eks-demonstration-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "as-grp-demonstration" {  
  desired_capacity = 2
  launch_configuration = aws_launch_configuration.launch-config-demonstration.id
  max_size = 5
  min_size = 2
  name = "terraform-eks-demonstration"

  vpc_zone_identifier = module.vpc.public_subnets

  tag {
    key = "Name"
    value = "terraform-eks-demonstration"
    propagate_at_launch = true
  }

  tag {

    key = "kubernetes.io/cluster/${var.eks-demo-cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }
}
