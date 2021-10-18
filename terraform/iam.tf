resource "aws_iam_role" "iam_for_lambda" {
    name               = "iam_for_lambda"
    assume_role_policy = file(join("/policies/", tolist([path.module, "iam_for_lambda.json"])))
}

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"
  policy = file(join("/policies/", tolist([path.module, "iam_for_lambda_logging.json"])))
}

resource "aws_iam_role_policy_attachment" "dynamodb-fullaccess-policy-attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = data.aws_iam_policy.AmazonDynamoDBFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}