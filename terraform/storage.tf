resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds_subnet_group"
  description = "Subnet Group for RDS"
  subnet_ids  = ["${aws_subnet.public_1[0].id}", "${aws_subnet.public_2[0].id}"]
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "mydb"
  name                 = "rubydockerappproduction"
  username             = "${var.RUBY_DOCKER_APP_DATABASE_USERNAME}"
  password             = "${var.RUBY_DOCKER_APP_DATABASE_PASSWORD}"
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_group.id}"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = "true"
}


#resource "aws_db_parameter_group" "main" {
#  name = "main"
#  family = "mysql5.7"
#  description = "RDS default parameter group"
#  parameter {
#    name = "lower_case_table_names"
#    value = "1"
#  }
#}
