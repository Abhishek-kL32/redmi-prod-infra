############################################
# KeyPair Creation                         #
############################################


resource "aws_key_pair" "redmi_auth" {

  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("redmi_key.pub")
  tags = {
    "Name" = "${var.project_name}-${var.project_env}"
  }
}

############################################
# zomato Security group                    #
############################################


resource "aws_security_group" "redmi_security_group" {
  name        = "${var.project_name}-${var.project_env}-frontend"
  description = "${var.project_name}-${var.project_env}-frontend"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.project_env}-frontend"
  }
}

############################################
# zomato Security group                    #
############################################


resource "aws_security_group" "redmi_remote_access" {
  name        = "${var.project_name}-${var.project_env}-remote"
  description = "${var.project_name}-${var.project_env}-remote"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.project_env}-remote"
  }
}

############################################
# creating Ec2 Instance                    #
############################################

resource "aws_instance" "frontend" {

  ami                    = var.ami-id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.redmi_auth.key_name
  user_data              = file("setup.sh")
  vpc_security_group_ids = [aws_security_group.redmi_remote_access.id, aws_security_group.redmi_security_group.id]
  tags = {
    "Name" = "${var.project_name}-${var.project_env}-frontend"
  }

  lifecycle {
    create_before_destroy = true
  }
}

############################################
# create and attach elastic-ip             #
############################################

resource "aws_eip" "frontend" {
  instance = aws_instance.frontend.id
  domain   = "vpc"
  tags = {
    "Name" = "${var.project_name}-${var.project_env}-frontend"
  }
}

############################################
# create record for webserver              #
############################################

resource "aws_route53_record" "webserver" {

  zone_id = data.aws_route53_zone.zone-details.id
  name    = "${var.hostname}.${var.hosted_zone_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.frontend.public_ip]
}

