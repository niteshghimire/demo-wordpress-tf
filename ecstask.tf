# ECS task definition
resource "aws_ecs_task_definition" "wordpress_task" {
  family                   = "wordpress-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  memory                   = 512
  cpu                      = 256

  container_definitions = jsonencode([
    {
      name  = "wordpress"
      image = "niteshghimire2/demo-wordpress:latest"
      portMappings = [{
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }]
      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = aws_db_instance.wordpress_db.endpoint
        },
        {
          name  = "WORDPRESS_DB_USER"
          value = aws_db_instance.wordpress_db.username
        },
        {
          name  = "WORDPRESS_DB_PASSWORD"
          value = aws_db_instance.wordpress_db.password
        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = aws_db_instance.wordpress_db.db_name
        }
      ]
      #   logConfiguration = {
      #     logDriver = "awslogs"
      #     options = {
      #       awslogs-group         = "/ecs/wordpress"
      #       awslogs-region        = "us-east-1"
      #       awslogs-stream-prefix = "ecs"
      #     }
      #   }
    }
  ])
}

# ECS Service for running tasks
resource "aws_ecs_service" "wordpress_service" {
  name            = "wordpress-service"
  cluster         = aws_ecs_cluster.wordpress_cluster.id
  task_definition = aws_ecs_task_definition.wordpress_task.arn
  desired_count   = 2
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
    container_name   = "wordpress"
    container_port   = 80
  }

  # Ensure load balancer and capacity provider are ready
  depends_on = [
    aws_lb_listener.wordpress_listener,
    aws_ecs_cluster_capacity_providers.wordpress_cluster_providers,
    aws_ecs_task_definition.wordpress_task,
    aws_lb.wordpress_alb
  ]

  # Enable rolling updates
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  tags = {
    Name = "WordPress ECS Service"
  }
}
