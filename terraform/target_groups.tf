resource "random_integer" "web_target_group_id" {
  min = 1
  max = 999
}

resource "aws_lb_target_group" "target_group_1" {
  # name                 = "my-tg-group-${random_integer.web_target_group_id.result}"
  name                 = "my-tg-group-39"
  port     = 31111
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
  deregistration_delay = 0

  health_check {
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 6
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "master" {
  target_group_arn = "${aws_lb_target_group.target_group_1.arn}"
  target_id        = "${aws_instance.master.id}"
  port             = 31111
}

resource "aws_lb_target_group_attachment" "workers" {
  count            = "${var.num_workers}"
  target_group_arn = "${aws_lb_target_group.target_group_1.arn}"
  target_id        = "${aws_instance.worker[count.index].id}"
  port             = 31111
}



























#resource "aws_lb_target_group" "target_group_2" {
#  name     = "my-target-group-2"
#  port     = 3001
#  protocol = "HTTP"
#  vpc_id   = "${aws_vpc.main.id}"
#}

#resource "aws_lb_target_group_attachment" "instance_2" {
#  target_group_arn = "${aws_lb_target_group.target_group_1.arn}"
#  target_id        = "${aws_instance.web_public_2.id}"
#  port             = 3000
#}
