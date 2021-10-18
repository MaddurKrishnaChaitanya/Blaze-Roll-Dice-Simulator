resource "aws_lambda_function" "roll_dice_details" {
  #filename      = "roll_dice_details.zip"
  filename = data.archive_file.lambda_rolldice_details_zip.output_path
  function_name = "RollDiceDetails"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "roll_dice_details.lambda_handler"
  runtime       = "python3.9"
  #source_code_hash = filebase64sha256("../target/roll_dice_details.zip")
  source_code_hash = data.archive_file.lambda_rolldice_details_zip.output_base64sha256
  depends_on = ["aws_iam_role.iam_for_lambda"]
}

resource "aws_lambda_function" "roll_dice_insert" {
  #filename      = "roll_dice_insert.zip"
  filename = data.archive_file.lambda_rolldice_insert_zip.output_path
  function_name = "RollDiceSumInsert"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "roll_dice_insert.lambda_handler"
  runtime       = "python3.9"
  #source_code_hash = filebase64sha256("../target/roll_dice_insert.zip")
  source_code_hash = data.archive_file.lambda_rolldice_insert_zip.output_base64sha256
  depends_on = ["aws_iam_role.iam_for_lambda"]
}

resource "aws_lambda_permission" "roll_dice_insert_allow_api" {
  statement_id = "AllowAPIGatewayInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.roll_dice_insert.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.role_dice_api.execution_arn}/*/*"
  depends_on = [aws_api_gateway_rest_api.role_dice_api]
}

resource "aws_lambda_permission" "roll_dice_details_allow_api" {
  statement_id = "AllowAPIGatewayInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.roll_dice_details.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.role_dice_api.execution_arn}/*/*"
  depends_on = [aws_api_gateway_rest_api.role_dice_api]
}







