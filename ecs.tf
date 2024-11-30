# ECS Cluster with Cluster Settings
resource "aws_ecs_cluster" "wordpress_cluster" {
  name = "wordpress-cluster"


  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "WordPress ECS Cluster"
  }

  depends_on = [aws_internet_gateway.wordpress_igw]
}

# ECS Capacity Provider
resource "aws_ecs_capacity_provider" "wordpress_capacity_provider" {
  name = "wordpress-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.wordpress_asg.arn
    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
    managed_termination_protection = "DISABLED"
  }
}

# Cluster Capacity Provider Strategy
resource "aws_ecs_cluster_capacity_providers" "wordpress_cluster_providers" {
  cluster_name = aws_ecs_cluster.wordpress_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.wordpress_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.wordpress_capacity_provider.name
  }
}
