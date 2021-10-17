variable "dynamodb_table_name" {
  type = string
  description = "DynamoDb Table Name which needs to be created inside AWS"
}

variable "aws_region"{
  type=string
  description = "AWS Region Name where resources are provisioned"
}