
resource "aws_dynamodb_table" "dice_roll_simulation" {
  name = var.dynamodb_table_name
  billing_mode     = "PAY_PER_REQUEST" #Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED
  hash_key         = "id" #The attribute to use as the hash (partition) key. Must also be defined as an attribute
  attribute {
    name = "id"
    type = "S"
  }
  tags = {
    environment = "dev-db"
  }
}