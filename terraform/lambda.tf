resource "aws_lambda_function" "roll_dice_details" {
  filename      = "roll_dice_details.zip"
  function_name = "RollDiceDetails"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("roll_dice_details.zip")
  depends_on = ["aws_iam_role.iam_for_lambda"]
}

resource "aws_lambda_function" "roll_dice_insert" {
  filename      = "roll_dice_insert.zip"
  function_name = "RollDiceSumInsert"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("roll_dice_insert.zip")
  depends_on = ["aws_iam_role.iam_for_lambda"]
}







