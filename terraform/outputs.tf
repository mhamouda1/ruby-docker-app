output "instance_ip_addr_1" {
  value = "${aws_instance.web_public_1.public_ip}:3000"
}

output "ssh_web_public_1" {
  value = "ssh ec2-user@${aws_instance.web_public_1.public_ip}"
}

#output "instance_ip_addr_2" {
#  value = "${aws_instance.web_public_2.public_ip}:3000"
#}
#
#output "ssh_web_public_2" {
#  value = "ssh ec2-user@${aws_instance.web_public_2.public_ip}"
#}
