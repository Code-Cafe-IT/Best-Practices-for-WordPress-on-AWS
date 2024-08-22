data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}


resource "aws_instance" "basionhost" {
  ami                           = data.aws_ami.amazon_linux_2.id
  instance_type                 = "t2.micro"
  associate_public_ip_address   = true
  subnet_id                     = var.public_subnet_1a
  key_name                      = "Nat"
  security_groups               = [ var.tf_sg_basionhost ]

  tags = {
    Name = "${var.project_name}-basion-host"
  }
}



resource "aws_autoscaling_group" "tf_asg" {
  name = "tf-asg"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  depends_on = [ var.load_balancers, aws_lb_target_group.tf-tgroups  ]
  target_group_arns = [ "${aws_lb_target_group.tf-tgroups.arn}" ]
  health_check_type = "EC2"
  launch_template {
    id = aws_launch_template.tf_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = ["${var.private_subnet_1a_app}", "${var.private_subnet_1b_app}" ]

  tag {
    key = "Name"
    value = "${var.project_name}-tf-autoscaling-groups"
    propagate_at_launch = true
  }
}


resource "aws_launch_template" "tf_template" {
  name_prefix = "${var.project_name}-tf-template"
  image_id = var.ami_wordpress
  key_name = "Nat"
  instance_type = "t2.small"
}

resource "aws_lb_target_group" "tf-tgroups" {
  name = "${var.project_name}tf-tgroups"
  depends_on = [ var.vpc_cidr ]
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_cidr
  health_check {
    path = "/"
    matcher = "200"
    interval = 15
    timeout = 2
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
