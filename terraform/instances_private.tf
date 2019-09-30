#resource "aws_instance" "web_private" {
#  ami           = "${data.aws_ami.amazon.id}"
#  instance_type = "t2.micro"
#  subnet_id   = "${aws_subnet.private_1[0].id}"
#  key_name    = "${aws_key_pair.my_key_pair.id}"
#  vpc_security_group_ids = ["${aws_vpc.main.default_security_group_id}"]
#
#  provisioner "file" {
#    source = "./main.tf"
#    destination = "~/test.txt"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sudo yum update -y",
#      "sudo amazon-linux-extras install ansible2 -y",
#      "sudo yum install docker -y",
#      "sudo yum install git -y",
#      "sudo curl -L 'https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose",
#      "sudo chmod +x /usr/local/bin/docker-compose",
#      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
#      "sudo service docker start"
#    ]
#  }
#
#  connection {
#    bastion_host = "${aws_instance.web_public_1.public_ip}"
#    bastion_user = "ec2-user"
#    bastion_private_key = file("/root/.ssh/id_rsa")
#
#    type     = "ssh"
#    user     = "ec2-user"
#    host     = "${self.private_ip}"
#    private_key = file("/root/.ssh/id_rsa")
#  }
#
#  tags = {
#    Name = "${terraform.workspace} -  My Private EC2 Instance"
#  }
#}
