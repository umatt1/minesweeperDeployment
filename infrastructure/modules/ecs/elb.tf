resource "aws_alb" "guestbook" {
  name               = "guestbook-server-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.guestbook.id]

  tags = {
    Environment = var.environment
  }
}
/*
https://stackoverflow.com/questions/40761309/adding-ssl-to-domain-hosted-on-route-53-aws
resource "aws_alb" "guestbook" {
  // ... existing configuration ...

  // Add SSL/TLS certificate
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  ssl_certificates {
    certificate_arn = "arn:aws:acm:REGION:ACCOUNT_ID:certificate/CERTIFICATE_ID"
  }

  // Configure HTTPS listener
  listener {
    protocol        = "HTTPS"
    port            = 443
    ssl_policy      = "ELBSecurityPolicy-2016-08"
    certificate_arn = "arn:aws:acm:REGION:ACCOUNT_ID:certificate/CERTIFICATE_ID"
    default_action {
      target_group_arn = aws_alb_target_group.guestbook_client.arn
      type             = "forward"
    }
  }
}

resource "aws_alb_target_group" "guestbook_client" {
  // ... existing configuration ...

  protocol = "HTTPS"
  port     = 443
}
*/

resource "aws_alb_listener" "guestbook" {
  load_balancer_arn = aws_alb.guestbook.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.guestbook_client.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "guestbook_https" {
  load_balancer_arn = aws_alb.guestbook.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-2:580548589113:certificate/ff0847de-3b40-4f0d-9d6f-33044bc25fc6"

  default_action {
    target_group_arn = aws_alb_target_group.guestbook_client.id
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "guestbook_server" {
  listener_arn = aws_alb_listener.guestbook.arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.guestbook_server.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/*"]
    }
  }
}

resource "aws_alb_listener_rule" "guestbook_server_https" {
  listener_arn = aws_alb_listener.guestbook_https.arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.guestbook_server.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/*"]
    }
  }
}

resource "aws_alb_target_group" "guestbook_server" {
  name        = "guestbook-server-${var.environment}"
  port        = var.server_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  depends_on  = [aws_alb.guestbook]

  health_check {
    path                = "/api/v1/actuator/health"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "guestbook_client" {
  name        = "guestbook-client-${var.environment}"
  port        = var.client_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  depends_on  = [aws_alb.guestbook]

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "guestbook" {
  name        = "guestbook-${var.environment}"
  description = "controls access to the load balancer"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}
