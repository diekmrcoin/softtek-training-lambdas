variable "name" { type = string }
variable "hash_key" { type = string }
variable "global_secondary_indexes" {
  type = list(object({
    name     = string
    hash_key = string
    type     = string
    include  = list(string)
  }))
  default = []
}

output "arn" { value = aws_dynamodb_table.dynamodb_table.arn }
output "stream_arn" { value = aws_dynamodb_table.dynamodb_table.stream_arn }

locals {
  attributes = concat([{ hash_key = var.hash_key, type = "S" }], var.global_secondary_indexes)
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name             = var.name
  billing_mode     = "PROVISIONED"
  hash_key         = var.hash_key
  range_key        = ""
  read_capacity    = 3
  write_capacity   = 3
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  dynamic "attribute" {
    for_each = local.attributes

    content {
      name = attribute.value.hash_key
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = length(global_secondary_index.value.include) > 0 ? "INCLUDE" : "KEYS_ONLY"
      range_key          = ""
      read_capacity      = 3
      write_capacity     = 3
      non_key_attributes = global_secondary_index.value.include
    }
  }

  point_in_time_recovery {
    enabled = true
  }

  ttl {
    enabled        = false
    attribute_name = ""
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }
}

resource "aws_appautoscaling_target" "appautoscaling_target_read" {
  max_capacity       = 150
  min_capacity       = 3
  resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "appautoscaling_policy_read" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.appautoscaling_target_read.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.appautoscaling_target_read.resource_id
  scalable_dimension = aws_appautoscaling_target.appautoscaling_target_read.scalable_dimension
  service_namespace  = aws_appautoscaling_target.appautoscaling_target_read.service_namespace

  target_tracking_scaling_policy_configuration {
    scale_in_cooldown  = 0
    scale_out_cooldown = 0
    target_value       = 80

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
}

resource "aws_appautoscaling_target" "appautoscaling_target_write" {
  max_capacity       = 150
  min_capacity       = 3
  resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "appautoscaling_policy_write" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.appautoscaling_target_write.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.appautoscaling_target_write.resource_id
  scalable_dimension = aws_appautoscaling_target.appautoscaling_target_write.scalable_dimension
  service_namespace  = aws_appautoscaling_target.appautoscaling_target_write.service_namespace

  target_tracking_scaling_policy_configuration {
    scale_in_cooldown  = 0
    scale_out_cooldown = 0
    target_value       = 80

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
  }
}
