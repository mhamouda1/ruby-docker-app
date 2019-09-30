resource "aws_instance" "master" {
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
    source      = "/root/.ssh/id_rsa.pub"
    destination = "/home/ec2-user/.ssh/id_rsa.pub"
  }

  provisioner "file" {
    source      = "/root/.ssh/id_rsa"
    destination = "/home/ec2-user/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "scripts/master.sh"
    destination = "/tmp/master.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/master.sh",
      "sudo bash /tmp/master.sh S3_BUCKET=${module.s3.bucket_name}",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = "${self.public_ip}"
    private_key = file("/root/.ssh/id_rsa")
  }

  tags = {
    Name = "Master"
  }
}

resource "aws_instance" "worker" {
  count         = 1
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

  # user_data = <<-EOT
    # #!/bin/bash
    # sudo aws s3 cp s3://${aws_s3_bucket.main.bucket}/kubernetes_join.txt kubernetes_join.txt
    # sudo $(cat kubernetes_join.txt)
    # sudo rm /var/lib/cloud/instances/*/sem/config_scripts_user #want to run on every reboot
  # EOT

  provisioner "file" {
    source      = "/root/.ssh/id_rsa.pub"
    destination = "/home/ec2-user/.ssh/id_rsa.pub"
  }

  provisioner "file" {
    source      = "/root/.ssh/id_rsa"
    destination = "/home/ec2-user/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "scripts/worker_node.sh"
    destination = "/tmp/worker_node.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/worker_node.sh",
      "sudo bash /tmp/worker_node.sh S3_BUCKET=${module.s3.bucket_name} NODE=node${count.index}",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = "${self.public_ip}"
    private_key = file("/root/.ssh/id_rsa")
  }

  tags = {
    Name = "Worker node ${count.index}"
  }

  depends_on = [aws_instance.master]
}







# resource "aws_instance" "web_public_1" {
  # ami           = "${data.aws_ami.amazon.id}"
  # instance_type = "t2.micro"
  # subnet_id     = "${aws_subnet.public_1[0].id}"
  # key_name      = "${aws_key_pair.my_key_pair.id}"
  # vpc_security_group_ids = [
    # "${aws_security_group.allow_ssh_and_web.id}",
    # "${aws_vpc.main.default_security_group_id}",
    # "${aws_security_group.development_testing.id}"
  # ]
  # iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

  # provisioner "file" {
    # source      = "/root/.ssh/id_rsa"
    # destination = "~/default_my_key_pair.pem"
  # }

  # provisioner "file" {
    # source      = "golden_image.sh"
    # destination = "/tmp/golden_image.sh"
  # }

  # provisioner "remote-exec" {
    # inline = [
      # "sudo chmod +x /tmp/golden_image.sh",
      # "sudo bash /tmp/golden_image.sh MEMCACHED_SERVER=${module.elasticache.cluster_address} RAILS_ENV=production RUBY_DOCKER_APP_DATABASE_HOST=${aws_db_instance.default.address} RUBY_DOCKER_APP_DATABASE_PASSWORD=${var.RUBY_DOCKER_APP_DATABASE_PASSWORD} RUBY_DOCKER_APP_DATABASE_USERNAME=${var.RUBY_DOCKER_APP_DATABASE_USERNAME} CLOUDFRONT_DOMAIN_NAME=${module.cloudfront.domain_name} S3_BUCKET=${module.s3.bucket_name}",
    # ]
  # }

  # connection {
    # type        = "ssh"
    # user        = "ec2-user"
    # host        = "${self.public_ip}"
    # private_key = file("/root/.ssh/id_rsa")
  # }

  # tags = {
    # Name = "Golden Image Instance"
  # }
# }

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

