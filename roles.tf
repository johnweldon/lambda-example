resource "aws_iam_role" "exampleLambdaRole" {
  name               = "${var.lambda_role_name}"
  assume_role_policy = "${var.lambda_role_policy}"
  description        = "Role for Example Lambda"

  tags = {
    "Environment" = "${var.environment_tag}"
  }
}

resource "aws_iam_role_policy" "exampleS3LambdaPolicy" {
  name   = "${var.lambda_s3_policy_name}"
  role   = "${aws_iam_role.exampleLambdaRole.id}"
  policy = "${var.lambda_role_s3_policy}"
}
