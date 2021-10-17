resource "aws_cloudwatch_log_group" "lambda_log_group_insert" {
  name              = "/aws/lambda/${aws_lambda_function.roll_dice_details.function_name}"
  retention_in_days = 14
  depends_on = ["aws_lambda_function.roll_dice_details"]
}

resource "aws_cloudwatch_log_group" "lambda_log_group_details" {
  name              = "/aws/lambda/${aws_lambda_function.roll_dice_insert.function_name}"
  retention_in_days = 14
  depends_on = ["aws_lambda_function.roll_dice_insert"]
}