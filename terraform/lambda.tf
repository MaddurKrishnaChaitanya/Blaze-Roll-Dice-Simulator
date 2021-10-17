resource "aws_lambda_function" "roll_dice_details" {
  filename      = "roll_dice_details.zip"
  function_name = "RollDiceDetails"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  #filename is lambda
  #function_name is lambda_handler
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda.zip"))}"
  source_code_hash = "${filebase64sha256("roll_dice_details.zip")}"
  depends_on = ["aws_iam_role.iam_for_lambda"]
}

resource "aws_lambda_function" "roll_dice_insert" {
  filename      = "roll_dice_insert.zip"
  function_name = "RollDiceSumInsert"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  #filename is lambda
  #function_name is lambda_handler
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda.zip"))}"
  source_code_hash = "${filebase64sha256("roll_dice_insert.zip")}"
  depends_on = ["aws_iam_role.iam_for_lambda"]
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

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

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

#print out the lambda function properties
output "lambdafunction-details" {
  value = "${aws_lambda_function.roll_dice_details}"
}

output "lambdafunction-insert" {
  value = "${aws_lambda_function.roll_dice_insert}"
}


#resource "aws_cloudformation_stack" "cfn_iam_stack" {
#  name          = "cfn-iam-stack"
#  template_body = "${file(join("/", list(path.module, "iam-cfn.json")))}"
#  capabilities  = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
#  iam_role_arn  = "${data.aws_iam_role.cfn_role.arn}"
#}







