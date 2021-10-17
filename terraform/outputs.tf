output "dynamodb_arn" {
  value = aws_dynamodb_table.dice_roll_simulation.arn
}

output "lambdafunction-details" {
  value = aws_lambda_function.roll_dice_details
}

output "lambdafunction-insert" {
  value = aws_lambda_function.roll_dice_insert
}