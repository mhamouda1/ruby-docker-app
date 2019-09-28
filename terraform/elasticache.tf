module "elasticache" {
  source = "./elasticache"
  subnet_ids = ["${aws_subnet.public_1[0].id}", "${aws_subnet.public_1[1].id}"]
}
