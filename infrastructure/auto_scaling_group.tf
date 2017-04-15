resource "aws_launch_configuration" "example" {
  image_id                = "ami-40d28157"
  instance_type           = "t2.micro"
  security_groups  = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World...Is it mean you are looking for" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]
  
  load_balancers       = ["${aws_elb.example.name}"]

  min_size = 2
  max_size = 10

  tag {
    key                 = "name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}
