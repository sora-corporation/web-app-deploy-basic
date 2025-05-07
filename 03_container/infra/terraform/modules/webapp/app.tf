resource "aws_apprunner_vpc_connector" "main" {
  vpc_connector_name = "${var.project}-${var.environment}"
  subnets            = module.vpc.private_subnets
  security_groups = [
    aws_security_group.outbound_anywhere.id,
    aws_security_group.inbound_anywhere.id,
  ]
}

resource "aws_apprunner_service" "main" {
  service_name = "${var.project}-${var.environment}"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_builder.arn
    }

    image_repository {
      image_configuration {
        port = 3000
        runtime_environment_variables = {
          PORT     = "3000"
          NODE_ENV = "production"
        }
      }
      image_identifier      = "${aws_ecr_repository.main.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.main.arn
    }
  }

  instance_configuration {
    cpu               = "512"
    memory            = "1024"
    instance_role_arn = aws_iam_role.apprunner.arn
  }
}

resource "aws_apprunner_custom_domain_association" "main" {
  domain_name          = var.domain_name
  service_arn          = aws_apprunner_service.main.arn
  enable_www_subdomain = false
}

resource "aws_route53_record" "certificate_validation_main" {
  zone_id = aws_route53_zone.root.zone_id

  count   = 2
  name    = tolist(aws_apprunner_custom_domain_association.main.certificate_validation_records)[count.index].name
  type    = tolist(aws_apprunner_custom_domain_association.main.certificate_validation_records)[count.index].type
  records = [tolist(aws_apprunner_custom_domain_association.main.certificate_validation_records)[count.index].value]
  ttl     = 300
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.root.zone_id

  name    = aws_apprunner_custom_domain_association.main.domain_name
  type    = "CNAME"
  records = [aws_apprunner_service.main.service_url]
  ttl     = 300
}