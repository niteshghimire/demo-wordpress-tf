# Application Load Balancer
resource "aws_lb" "wordpress_alb" {
  name                       = "wordpress-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.wordpress_alb_sg.id]
  subnets                    = aws_subnet.public_subnets[*].id
  enable_deletion_protection = false

  tags = {
    Name = "WordPress Application Load Balancer"
  }

  depends_on = [aws_internet_gateway.wordpress_igw]
}

resource "aws_lb_target_group" "wordpress_tg" {
  name        = "wordpress-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.wordpress_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "WordPress Target Group"
  }
}

resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }

  tags = {
    Name = "WordPress ALB Listener"
  }
}
