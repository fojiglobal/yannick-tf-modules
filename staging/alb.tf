resource "aws_lb_target_group" "tgw" {
  name     = "${var.env}-tg-80"
  port     = var.http_port
  protocol = var.http_proto
  vpc_id   = aws_vpc.this.id
  health_check {
    healthy_threshold = 2
    interval = 10
  }
}

resource "aws_lb" "alb" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  tags = {
    Name = "${var.env}-alb"
    Environment = var.env
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.https_port
  protocol          = var.https_proto
  ssl_policy        = var.alb_ssl_profile
  certificate_arn   = var.alb_ssl_cert_arn #data.aws_acm_certificate.alb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgw.arn
  }
}

resource "aws_lb_listener" "http_to_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_port
  protocol          = var.http_proto

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = var.https_proto
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "https" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgw.arn
  }

  condition {
    host_header {
      values = var.alb_rule_condition #["stage.yannick.com", "www.stage.yannick.com"]
    }
  }
}