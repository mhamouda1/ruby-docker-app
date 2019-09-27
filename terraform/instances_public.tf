#/etc/profile.d/export_instance_tags.sh
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

  #disable_api_termination = true
  #user_data = file("bootstrap.sh")

  provisioner "file" {
    source      = "/root/.ssh/id_rsa"
    destination = "~/default_my_key_pair.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 default_my_key_pair.pem",
      "sudo yum install docker -y",
      "sudo yum install git -y",
      "sudo curl -L 'https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "sudo service docker start",
      "sudo systemctl enable docker",
      "sudo git clone https://github.com/mhamouda1/ruby-docker-app",
      "cd ~/ruby-docker-app",

      "echo MEMCACHED_SERVER VARIABLE IS: ${var.MEMCACHED_SERVER}",

      "sudo bash -c 'echo \"#!/bin/bash\" >> /etc/profile.d/export_env_variables.sh'",
      "sudo bash -c 'echo export RAILS_ENV=production >> /etc/profile.d/export_env_variables.sh'",
      "sudo bash -c 'echo export MEMCACHED_SERVER=${var.MEMCACHED_SERVER} >> /etc/profile.d/export_env_variables.sh'",

      "sudo bash -c 'echo export RAILS_ENV=production >> /root/.bash_profile'",
      "sudo bash -c 'echo export MEMCACHED_SERVER=${var.MEMCACHED_SERVER} >> /root/.bash_profile'",

      "sudo bash -c 'source /root/.bash_profile'",
      "sudo cat /root/.bash_profile'",
      "cat /root/.bash_profile'",

      "sudo $(aws ecr get-login --no-include-email --region us-east-1)",
      "sudo docker-compose pull",
      "sudo docker-compose up -d",
      "sleep 7", #wait until database is ready, must be a better solution
      "sudo docker-compose run web bundle update",
      "sudo docker-compose run web rake db:create",
      "sudo docker-compose run web rake db:migrate",
      "sudo docker-compose down",
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
