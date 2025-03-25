resource "aws_lb" "webapp" {
  name               = "lb-${var.project}"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 300
  subnets            = module.vpc.public_subnets
  security_groups = [
    aws_security_group.lb.id,
    aws_security_group.outbound_anywhere.id,
  ]

  access_logs {
    bucket  = aws_s3_bucket.log.bucket
    prefix  = "lb"
    enabled = true
  }
}

resource "aws_lb_target_group" "webapp" {
  name     = "webapp"
  vpc_id   = module.vpc.vpc_id
  port     = 80
  protocol = "HTTP"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    interval            = 60
  }
}

resource "aws_lb_target_group_attachment" "webapp" {
  target_group_arn = aws_lb_target_group.webapp.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb_listener" "alb_80" {
  load_balancer_arn = aws_lb.webapp.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_443" {
  load_balancer_arn = aws_lb.webapp.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp.arn
  }
}
