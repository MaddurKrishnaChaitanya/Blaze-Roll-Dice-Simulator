terraform{
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

//zip the code
data "archive_file" "lambda_rolldice_insert_zip"{
   type = "zip"
   source_file = "../aws/lambda/roll_dice_insert.py"
   output_path = "../target/roll_dice_insert.zip"
}

data "archive_file" "lambda_rolldice_details_zip"{
   type = "zip"
   source_file = "../aws/lambda/roll_dice_details.py"
   output_path = "../target/roll_dice_details.zip"
}

// DynamoDbFUllAccess Managed Policy
data "aws_iam_policy" "AmazonDynamoDBFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}