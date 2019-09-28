resource "aws_instance" "web_public_1" {
  ami           = "${data.aws_ami.amazon.id}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public_1[0].id}"
  key_name      = "${aws_key_pair.my_key_pair.id}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_ssh_and_web.id}",
    "${aws_vpc.main.default_security_group_id}",
    "${aws_security_group.development_testing.id}"
  ]
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

  provisioner "file" {
    source      = "/root/.ssh/id_rsa"
    destination = "~/default_my_key_pair.pem"
  }

  provisioner "file" {
    source      = "golden_image.sh"
    destination = "/tmp/golden_image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/golden_image.sh",
      "sudo bash /tmp/golden_image.sh MEMCACHED_SERVER=${module.elasticache.cluster_address} RAILS_ENV=production RUBY_DOCKER_APP_DATABASE_HOST=${aws_db_instance.default.address} RUBY_DOCKER_APP_DATABASE_PASSWORD=${var.RUBY_DOCKER_APP_DATABASE_PASSWORD} RUBY_DOCKER_APP_DATABASE_USERNAME=${var.RUBY_DOCKER_APP_DATABASE_USERNAME}",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = "${self.public_ip}"
    private_key = file("/root/.ssh/id_rsa")
  }

  tags = {
    Name = "Golden Image Instance"
  }
}

#resource "aws_instance" "web_public_2" {
#  ami           = "${data.aws_ami.my_custom_image.id}"
#  instance_type = "t2.micro"
#  subnet_id     = "${aws_subnet.public_1[0].id}"
#  key_name      = "${aws_key_pair.my_key_pair.id}"
#  vpc_security_group_ids = [
#    "${aws_security_group.allow_ssh_and_web.id}",
#    "${aws_vpc.main.default_security_group_id}",
#    "${aws_security_group.development_testing.id}"
#  ]
#  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
#
#  provisioner "remote-exec" {
#    inline = [
#      "echo 'export HOSTNAME=$(hostname)' >> ~/.bash_profile && source ~/.bash_profile",
#      "cd ~/ruby-docker-app",
#      "sudo docker-compose down",
#      "sudo git pull",
#      "sudo docker-compose up -d",
#    ]
#  }
#
#  connection {
#    type        = "ssh"
#    user        = "ec2-user"
#    host        = "${self.public_ip}"
#    private_key = file("/root/.ssh/id_rsa")
#  }
#
#  tags = {
#    Name = "${terraform.workspace} -  My Public EC2 Instance"
#  }
#}
