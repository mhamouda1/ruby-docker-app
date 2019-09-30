resource "aws_lb_target_group" "target_group_1" {
  name     = "my-target-group-1"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
  deregistration_delay = 0

  health_check {
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 6
  }
}

#resource "aws_lb_target_group" "target_group_2" {
#  name     = "my-target-group-2"
#  port     = 3001
#  protocol = "HTTP"
#  vpc_id   = "${aws_vpc.main.id}"
#}

#resource "aws_lb_target_group_attachment" "instance_1" {
#  target_group_arn = "${aws_lb_target_group.target_group_1.arn}"
#  target_id        = "${aws_instance.web_public_1.id}"
#  port             = 3000
#}
#
#resource "aws_lb_target_group_attachment" "instance_2" {
#  target_group_arn = "${aws_lb_target_group.target_group_1.arn}"
#  target_id        = "${aws_instance.web_public_2.id}"
#  port             = 3000
#}
