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

