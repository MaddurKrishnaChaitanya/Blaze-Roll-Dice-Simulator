# API Gateway
resource "aws_api_gateway_rest_api" "role_dice_api" {
  name = var.api_name
  description = "This is Roll Dice Simulation API to trigger lambda function"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "rolldice_insert_resource" {
  rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
  parent_id   = aws_api_gateway_rest_api.role_dice_api.root_resource_id
  path_part   = "rolldice"
}

resource "aws_api_gateway_resource" "rolldice_details_resource" {
  rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
  parent_id   = aws_api_gateway_resource.rolldice_insert_resource.id
  path_part   = "details"
}

resource "aws_api_gateway_method" "rolldice_insert_method" {
  rest_api_id   = aws_api_gateway_rest_api.role_dice_api.id
  resource_id   = aws_api_gateway_resource.rolldice_insert_resource.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = false
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
  api_key_required = false
  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.querystring.noofdice" = false
    "method.request.querystring.sidesofdice" = false
  }
}

resource "aws_api_gateway_integration" "roll_dice_insert_lambda" {
   rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
   resource_id = aws_api_gateway_method.rolldice_insert_method.resource_id
   http_method = aws_api_gateway_method.rolldice_insert_method.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.roll_dice_insert.invoke_arn
}

resource "aws_api_gateway_integration" "roll_dice_details_lambda" {
   rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
   resource_id = aws_api_gateway_method.rolldice_details_method.resource_id
   http_method = aws_api_gateway_method.rolldice_details_method.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.roll_dice_details.invoke_arn
}

resource "aws_api_gateway_deployment" "rolldicesimulation_deploy" {
   rest_api_id = aws_api_gateway_rest_api.role_dice_api.id
   #stage_name  = var.apigtw_deploy_stage
  #  triggers = {
  #    redeployment = sha1(jsondecode(aws_api_gateway_rest_api.role_dice_api.body))
  #  }
   depends_on = [
     aws_api_gateway_integration.roll_dice_insert_lambda,
     aws_api_gateway_integration.roll_dice_details_lambda,
   ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "develop" {
  deployment_id = aws_api_gateway_deployment.rolldicesimulation_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.role_dice_api.id
  stage_name    = var.apigtw_deploy_stage
}

