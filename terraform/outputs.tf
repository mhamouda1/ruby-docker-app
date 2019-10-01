# output "instance_ip_addr_1" {
  # value = "${aws_instance.web_public_1.public_ip}:3000"
# }

# output "ssh_web_public_1" {
  # value = "ssh ec2-user@${aws_instance.web_public_1.public_ip}"
# }

#output "instance_ip_addr_2" {
#  value = "${aws_instance.web_public_2.public_ip}:3000"
#}
#
#output "ssh_web_public_2" {
#  value = "ssh ec2-user@${aws_instance.web_public_2.public_ip}"
#}

output "elasticache_address" {
  value = "${module.elasticache.cluster_address}"
}

output "cloudfront_domain_name" {
  value = "${module.cloudfront.domain_name}"
}

output "ecr_repository_url" {
  value = "${module.ecr.repository_url}"
}

output "s3_bucket" {
  value = "${module.s3.bucket_name}"
}

output "rds_address" {
  value = "${aws_db_instance.default.address}"
}
