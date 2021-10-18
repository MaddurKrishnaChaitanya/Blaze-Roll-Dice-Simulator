output "dynamodb_arn" {
  value = aws_dynamodb_table.dice_roll_simulation.arn
}

output "apigwt_base_url" {
  value = aws_api_gateway_deployment.rolldicesimulation_deploy.invoke_url
}

output "apigwt_rolldice_insert_url" {
  value = "${aws_api_gateway_deployment.rolldicesimulation_deploy.invoke_url}${aws_api_gateway_stage.develop.stage_name}/${aws_api_gateway_resource.rolldice_insert_resource.path_part}"
}

output "apigwt_rolldice_details_url" {
  value = "${aws_api_gateway_deployment.rolldicesimulation_deploy.invoke_url}${aws_api_gateway_stage.develop.stage_name}/${aws_api_gateway_resource.rolldice_insert_resource.path_part}/${aws_api_gateway_resource.rolldice_details_resource.path_part}"
}

#output "lambdafunction-details" {
#  value = aws_lambda_function.roll_dice_details
#}

#output "lambdafunction-insert" {
#  value = aws_lambda_function.roll_dice_insert
#}