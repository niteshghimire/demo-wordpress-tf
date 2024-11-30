# RDS MySQL Database
resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  name       = "wordpress-db-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "WordPress DB Subnet Group"
  }
}

resource "aws_db_instance" "wordpress_db" {
  identifier           = "wordpress-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"

  vpc_security_group_ids = [aws_security_group.wordpress_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.wordpress_db_subnet_group.name

  skip_final_snapshot = true

  tags = {
    Name = "WordPress MySQL Database"
  }
}
