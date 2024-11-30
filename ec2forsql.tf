resource "aws_key_pair" "bastion_key" {
  key_name   = var.ssh_key_name
  public_key = var.my_public_key
}


resource "aws_instance" "bastion" {
  ami                         = "ami-0453ec754f44f9a4a"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnets[0].id
  key_name                    = aws_key_pair.bastion_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.wordpress_ec2_sg.id]

  tags = {
    Name = "Bastion-Instance"
  }

  depends_on = [aws_internet_gateway.wordpress_igw]
}

resource "null_resource" "upload_and_run_sql" {
  provisioner "file" {
    source      = "./config/wp_ecom.sql"
    destination = "/tmp/wp_ecom.sql"

    connection {
      type        = "ssh"
      host        = aws_instance.bastion.public_ip
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = aws_instance.bastion.public_ip
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
    }

    inline = [
      "sudo dnf install mariadb105 -y",
      "mysql -h ${replace(aws_db_instance.wordpress_db.endpoint, ":3306", "")} -u ${aws_db_instance.wordpress_db.username} -p${aws_db_instance.wordpress_db.password} ${aws_db_instance.wordpress_db.db_name} < /tmp/wp_ecom.sql ",
      "mysql -h ${replace(aws_db_instance.wordpress_db.endpoint, ":3306", "")} -u ${aws_db_instance.wordpress_db.username} -p${aws_db_instance.wordpress_db.password} ${aws_db_instance.wordpress_db.db_name} -e \"UPDATE wp_options SET option_value='http://${aws_lb.wordpress_alb.dns_name}' WHERE option_name IN ('siteurl', 'home');\" "
    ]
  }

  depends_on = [
    aws_instance.bastion,
    aws_lb.wordpress_alb
  ]
}
