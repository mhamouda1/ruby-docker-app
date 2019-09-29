resource "aws_launch_configuration" "main" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "${data.aws_ami.my_custom_image.id}"
  instance_type = "t2.micro"
  security_groups = [
    "${aws_security_group.allow_ssh_and_web.id}",
    "${aws_vpc.main.default_security_group_id}",
    "${aws_security_group.development_testing.id}"
  ]
  user_data = "${file("userdata.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "my auto scaling group"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  default_cooldown          = 5 #for dev testing
  health_check_grace_period = 60 #time it takes until begin doing health checks
  health_check_type         = "ELB"
  target_group_arns         = ["${aws_lb_target_group.target_group_1.arn}", "${aws_lb_target_group.target_group_2.arn}"]
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.main.name}"
  vpc_zone_identifier       = ["${aws_subnet.public_1[0].id}", "${aws_subnet.public_2[0].id}"]

  tag {
    key                 = "Name"
    value               = "ASG launched"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_autoscaling_policy" "main" {
  name                   = "my auto scaling policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = "${aws_autoscaling_group.main.name}"


  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}
