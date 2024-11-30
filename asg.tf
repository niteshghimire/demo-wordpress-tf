# Launch Template
resource "aws_launch_template" "wordpress_launch_template" {
  name_prefix   = "wordpress-launch-template"
  image_id      = "ami-04a95f47496c803a3"
  instance_type = "t2.micro"


  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_role_profile.name
  }

  # vpc_security_group_ids = [aws_security_group.wordpress_ec2_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${aws_ecs_cluster.wordpress_cluster.name} >> /etc/ecs/ecs.config

    mkdir -p /home/ec2-user/.ssh
    chmod 700 /home/ec2-user/.ssh
    echo ${var.my_public_key} > /home/ec2-user/.ssh/authorized_keys
    chmod 600 /home/ec2-user/.ssh/authorized_keys
    chown -R ec2-user:ec2-user /home/ec2-user/.ssh
    EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.wordpress_ec2_sg.id]
  }

  tags = {
    Name = "WordPress Launch Template"
  }

}

# Auto Scaling Group
resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = aws_subnet.public_subnets[*].id

  launch_template {
    id      = aws_launch_template.wordpress_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "WordPress ECS Instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  depends_on = [aws_internet_gateway.wordpress_igw]
}

# Attach asg with target group for load balancer
resource "aws_autoscaling_attachment" "asg_alb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  lb_target_group_arn    = aws_lb_target_group.wordpress_tg.arn
}

# Instance refresh after changing the launch templates

# resource "aws_autoscaling_instance_refresh" "wordpress_instance_refresh" {
#   auto_scaling_group_name = aws_autoscaling_group.wordpress_asg.name

#   preferences {
#     min_healthy_percentage = 50
#     instance_warmup_time   = 300
#   }
# }
