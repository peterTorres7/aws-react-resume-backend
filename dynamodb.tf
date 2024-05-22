resource "aws_dynamodb_table" "visits_table" {
  name = "visits_table"
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  lifecycle {
  ignore_changes = [read_capacity, write_capacity]
  }
}

resource "aws_appautoscaling_target" "visits_table_read_target" {
  max_capacity = 10
  min_capacity = 1
  resource_id = "table/visits_table"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace = "dynamodb"
}

resource "aws_appautoscaling_policy" "visits_table_read_policy" {
  name = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.visits_table_read_target.resource_id}"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.visits_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.visits_table_read_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.visits_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
    scale_in_cooldown = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_target" "visits_table_write_target" {
  max_capacity = 10
  min_capacity = 1
  resource_id = "table/visits_table"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace = "dynamodb"
}

resource "aws_appautoscaling_policy" "visits_table_write_policy" {
  name = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.visits_table_write_target.resource_id}"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.visits_table_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.visits_table_write_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.visits_table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
    scale_in_cooldown = 60
    scale_out_cooldown = 60
  } 
}

resource "aws_dynamodb_table_item" "visits_table_visits_count" {
  table_name = aws_dynamodb_table.visits_table.name
  hash_key = aws_dynamodb_table.visits_table.hash_key

  item = <<ITEM
{
  "id": {"S": "1"},
  "visits_count": {"N": "1"}
}
ITEM
}
