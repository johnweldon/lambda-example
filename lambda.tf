resource "aws_lambda_function" "exampleLambdaFunction" {
  role             = "${aws_iam_role.exampleLambdaRole.arn}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  filename         = "lib.zip"
  function_name    = "${var.function_name}"
  source_code_hash = "${base64sha256(file("lib.zip"))}"
}
