# Outputs
output "wordpress_alb_dns" {
  value       = aws_lb.wordpress_alb.dns_name
  description = "The DNS name of the WordPress Application Load Balancer"
}

output "rds_endpoint" {
  value       = aws_db_instance.wordpress_db.endpoint
  description = "The connection endpoint for the RDS MySQL database"
}
