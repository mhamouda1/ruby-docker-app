resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.allow_ssh_and_web.id}",
    "${aws_vpc.main.default_security_group_id}",
    "${aws_security_group.development_testing.id}"
  ]
  subnets = ["${aws_subnet.public_1[0].id}", "${aws_subnet.public_2[0].id}"]
}

resource "aws_lb_listener" "my_alb_80" {
  load_balancer_arn = "${aws_lb.my_alb.arn}"
  port              = 3000
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group_1.arn}"
  }
}
