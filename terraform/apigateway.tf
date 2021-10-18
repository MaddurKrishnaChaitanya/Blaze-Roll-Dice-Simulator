# API Gateway
resource "aws_api_gateway_rest_api" "role_dice_api" {
  name = "RollDiceAPI"
  description = "This is Roll Dice Simulation API to trigger lambda function"
}

resource "aws_api_gateway_resource" "rolldice_resource" {
  rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
  parent_id   = aws_api_gateway_rest_api.role_dice_api.root_resource_id
  path_part   = "/rolldice"
}

resource "aws_api_gateway_resource" "rolldice_details_resource" {
  rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
  parent_id   = aws_api_gateway_rest_api.role_dice_api.root_resource_id
  path_part   = "/rolldice/details"
}

resource "aws_api_gateway_method" "rolldice_method" {
  rest_api_id   = aws_api_gateway_rest_api.role_dice_api.id
  resource_id   = aws_api_gateway_resource.rolldice_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.querystring.noofdice" = true
    "method.request.querystring.sidesofdice" = true
    "method.request.querystring.totalrolls" = true
  }
}

resource "aws_api_gateway_method" "rolldice_details_method" {
  rest_api_id   = aws_api_gateway_rest_api.role_dice_api.id
  resource_id   = aws_api_gateway_resource.rolldice_details_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.querystring.noofdice" = false
    "method.request.querystring.sidesofdice" = false
  }
}

resource "aws_api_gateway_integration" "roll_dice_lambda" {
   rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
   resource_id = aws_api_gateway_method.rolldice_method.resource_id
   http_method = aws_api_gateway_method.rolldice_method.http_method
   integration_http_method = "GET"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.roll_dice_insert.invoke_arn
}

resource "aws_api_gateway_integration" "roll_dice_details_lambda" {
   rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
   resource_id = aws_api_gateway_method.rolldice_details_method.resource_id
   http_method = aws_api_gateway_method.rolldice_details_method.http_method
   integration_http_method = "GET"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.roll_dice_details.invoke_arn
}