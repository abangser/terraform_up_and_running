provider "aws" {
  region        = "us-east-1"
}

resource "aws_elb" "example" {
  name                = "terraform-asg-example"
  security_groups     = ["${aws_security_group.instance.id}"]
  availability_zones  = ["${data.aws_availability_zones.all.names}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }
}

