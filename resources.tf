resource "aws_lb_target_group" "blue" {
  name     = var.blue_target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200"
  }

  tags = merge(local.common_tags, {
    Name        = var.blue_target_group_name
    Environment = "blue"
  })
}

resource "aws_lb_target_group" "green" {
  name     = var.green_target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200"
  }

  tags = merge(local.common_tags, {
    Name        = var.green_target_group_name
    Environment = "green"
  })
}

resource "aws_lb" "main" {
  name               = var.load_balancer
  internal           = false
  load_balancer_type = "application"

  security_groups = [data.aws_security_group.lb_http_inbound.id]
  subnets = [
    data.aws_subnet.public1.id,
    data.aws_subnet.public2.id
  ]

  tags = merge(local.common_tags, {
    Name = var.load_balancer
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = var.blue_weight
      }
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = var.green_weight
      }
    }
  }
}

resource "aws_launch_template" "blue" {
  name          = var.blue_launch_template_name
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    data.aws_security_group.ssh_inbound.id,
    data.aws_security_group.http_inbound.id
  ]

  user_data = base64encode(templatefile("user_data.sh.tpl", {
    color = "Blue"
    })
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name        = "blue-instance"
      Environment = "blue"
    })
  }

  tags = merge(local.common_tags, {
    Name        = var.blue_launch_template_name
    Environment = "blue"
  })
}

resource "aws_launch_template" "green" {
  name          = var.green_launch_template_name
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    data.aws_security_group.ssh_inbound.id,
    data.aws_security_group.http_inbound.id
  ]

  user_data = base64encode(templatefile("user_data.sh.tpl", {
    color = "Green"
  }))

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name        = "green-instance"
      Environment = "green"
    })
  }

  tags = merge(local.common_tags, {
    Name        = var.green_launch_template_name
    Environment = "green"
  })
}

resource "aws_autoscaling_group" "blue" {
  name = var.blue_asg_name

  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  vpc_zone_identifier = [
    data.aws_subnet.public1.id,
    data.aws_subnet.public2.id
  ]

  target_group_arns = [aws_lb_target_group.blue.arn]

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_id
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = var.blue_asg_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "blue"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green" {
  name = var.green_asg_name

  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  vpc_zone_identifier = [
    data.aws_subnet.public1.id,
    data.aws_subnet.public2.id
  ]

  target_group_arns = [aws_lb_target_group.green.arn]

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_id
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = var.green_asg_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "green"
    propagate_at_launch = true
  }
}