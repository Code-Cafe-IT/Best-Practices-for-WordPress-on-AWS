resource "aws_alb" "tf_alb" {
  name = "${var.project_name}-tf-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ var.sg_alb ]
  subnets = [ var.public_subnet_1a, var.public_subnet_1b]
  tags = {
    Name = "${var.project_name}-tf-alb"
  } 
}

resource "aws_lb_listener" "tf_linsner" {
  load_balancer_arn = aws_alb.tf_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = var.target_group_arn
  }
}