resource "aws_dynamodb_table" "visits_table" {
  name = "visits_table"
  billing_mode = "PROVISIONED"
  read_capacity = 10
  write_capacity = 10
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled = false
  }
}