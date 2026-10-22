resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }


  tags = var.tags
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = [var.instance_type]
  disk_size      = var.disk_size

  tags = var.tags
}

# Cluster admin access for IAM users/roles (EKS console + kubectl)
resource "aws_eks_access_entry" "admin" {
  for_each      = toset(var.cluster_admin_arns)
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value

  tags = var.tags
}

resource "aws_eks_access_policy_association" "admin" {
  for_each      = toset(var.cluster_admin_arns)
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin]
}
