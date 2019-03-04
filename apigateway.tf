resource "aws_api_gateway_rest_api" "exampleLambdaGateway" {
  name        = "${var.function_name}-gateway"
  description = "Terraform Serverless Example Gateway"
}

resource "aws_api_gateway_resource" "exampleLambdaGatewayProxy" {
  rest_api_id = "${aws_api_gateway_rest_api.exampleLambdaGateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.exampleLambdaGateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "exampleLambdaGatewayMethod" {
  rest_api_id   = "${aws_api_gateway_rest_api.exampleLambdaGateway.id}"
  resource_id   = "${aws_api_gateway_resource.exampleLambdaGatewayProxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "exampleLambdaGatewayIntegration" {
  rest_api_id = "${aws_api_gateway_rest_api.exampleLambdaGateway.id}"
  resource_id = "${aws_api_gateway_method.exampleLambdaGatewayMethod.resource_id}"
  http_method = "${aws_api_gateway_method.exampleLambdaGatewayMethod.http_method}"

  integration_http_method = "POST"

  type = "AWS_PROXY"
  uri  = "${aws_lambda_function.exampleLambdaFunction.invoke_arn}"
}

resource "aws_api_gateway_method" "exampleLambdaGatewayMethodRoot" {
  rest_api_id   = "${aws_api_gateway_rest_api.exampleLambdaGateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.exampleLambdaGateway.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "exampleLambdaGatewayIntegrationRoot" {
  rest_api_id = "${aws_api_gateway_rest_api.exampleLambdaGateway.id}"
  resource_id = "${aws_api_gateway_method.exampleLambdaGatewayMethodRoot.resource_id}"
  http_method = "${aws_api_gateway_method.exampleLambdaGatewayMethodRoot.http_method}"

  integration_http_method = "POST"

  type = "AWS_PROXY"
  uri  = "${aws_lambda_function.exampleLambdaFunction.invoke_arn}"
}

resource "aws_api_gateway_deployment" "exampleLambdaGatewayDeployment" {
  depends_on = [
    "aws_api_gateway_integration.exampleLambdaGatewayIntegration",
    "aws_api_gateway_integration.exampleLambdaGatewayIntegrationRoot",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.exampleLambdaGateway.id}"
  stage_name  = "${var.api_stage_name}"
}

resource "aws_lambda_permission" "exampleLambdaGatewayPermission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.exampleLambdaFunction.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.exampleLambdaGatewayDeployment.execution_arn}/*/*"
}

resource "aws_api_gateway_domain_name" "exampleGatewayDN" {
  domain_name     = "${var.example_host}.${var.base_zone}"
  certificate_arn = "${aws_acm_certificate_validation.exampleSubdomainCert.certificate_arn}"
}

resource "aws_api_gateway_base_path_mapping" "exampleGatewayMapping" {
  api_id      = "${aws_api_gateway_rest_api.exampleLambdaGateway.id}"
  stage_name  = "${aws_api_gateway_deployment.exampleLambdaGatewayDeployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.exampleGatewayDN.domain_name}"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.exampleLambdaGatewayDeployment.invoke_url}"
}
