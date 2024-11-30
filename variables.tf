variable "db_name" {
  default     = "wp_ecom"
  description = "for db name of wp"

}

variable "db_user" {
  default     = "wordpressadmin"
  description = "for wp admin user"
}

variable "db_password" {
  description = "for db pass"

}

variable "ssh_key_name" {
  default = "my_asus"
}

variable "my_public_key" {
  default = <<EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPrSG59q1wjpPC6iMZCIqejEtTxDoRzTc/Gfoacr2BVqhKot0+WoowYHQ79nIUJOsmBR3FwxT0wszuT+b388o2brQvpyhec8GxtXZkw8Y7d0qgIt8Zd0rkjhStU43Qbac82yjr39R8CxZX+Y9NXxRStOHW9KQnlQw/63lDzFU/A1eShLYlvlnkqhR+jEE44fL3bhSF5a6JR38WKbeiydkOcAdd8zVnW7RyeKirg3bHqve2kxE8mAWWn3KTTRLyksdwFZ3caHaGSGvldgkaZpP0IBF3M6O2MDdJYmgBulocdWLMPD1jWSwZCBUYCaVSt1HVzMvrBdj5Jni1tVtNJHQs+28lTkqlAfQsVY7kcy3v+a5sq11hM08GAZDsVSggBOjCe8voKLGoQJJOmHxAFTX1qn+bi9qDEt4kXwDujZVnP4OqtpUxWqS8j2m1Neka4fz6ugKmI36XiIV7r7XZjCp9A+zY/Z6AxnRtbjj28eZb/0Yae/wXO9Jy5jG9VrWlFyEqXkAHZ5WeUjJdwDLOqDiqFFPArTwsDQrWMb4OMkLqMBOK68R8uF93c7LDjXkSWsh1MtvREus8lZBzOKWrN9mN+FWKJ2J7DofGGJFEk8rTQ605IXUwRwPKdZj+56at75MP/dRsTWZK+8wmvf4okjmyMgPYD1b2fGVreOCZ/5eB+w== nitesh@asteriskt.com
EOT
}
