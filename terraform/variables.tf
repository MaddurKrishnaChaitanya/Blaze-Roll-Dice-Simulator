variable "dynamodb_table_name" {
  type = string
  description = "DynamoDb Table Name which needs to be created inside AWS"
}

variable "aws_region"{
  type=string
  description = "AWS Region Name where resources are provisioned"
}

variable "api_name"{
  type=string
  description = "API Name for Gateway"
}

variable "apigtw_deploy_stage"{
  type=string
  description = "environment api gateway deployed"
}