# API Gateway
resource "aws_api_gateway_rest_api" "role_dice_api" {
  name = "RollDiceAPI"
  description = "This is Roll Dice Simulation API to trigger lambda function"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
  parent_id   = aws_api_gateway_rest_api.role_dice_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.role_dice_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.querystring.noofdice" = true
    "method.request.querystring.sidesofdice" = true
    "method.request.querystring.totalrolls" = true
  }
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
   resource_id = aws_api_gateway_method.method.resource_id
   http_method = aws_api_gateway_method.method.http_method
   integration_http_method = "GET"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.roll_dice_details.invoke_arn
}