resource "aws_elasticache_subnet_group" "main" {
  name       = "tf-cache-subnet"
  subnet_ids = ["${aws_subnet.public_1[0].id}", "${aws_subnet.public_1[1].id}"]
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = "my-cluster"
  engine               = "memcached"
  engine_version       = "1.5.16"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.5"
  port                 = 11211

  subnet_group_name  = "${aws_elasticache_subnet_group.main.name}"
}
