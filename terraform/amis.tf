data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-gp2"]
  }

  owners = ["amazon"]
}


resource "random_id" "web_app_ami" {
  byte_length = 6
}

#this takes the snapshot
# resource "aws_ami_from_instance" "ruby_docker_app" {
  # name                    = "ruby_docker_app_${random_id.web_app_ami.b64}"
  # source_instance_id      = "${aws_instance.web_public_1.id}"
  # snapshot_without_reboot = "true"
  # depends_on              = [aws_instance.web_public_1]
# }

#this references the snapshot
# data "aws_ami" "my_custom_image" {
  # most_recent = true

  # filter {
    # name   = "name"
    # values = ["${aws_ami_from_instance.ruby_docker_app.name}"]
  # }

  # owners = ["self"]
  # depends_on = [aws_instance.web_public_1]
# }
