variable "prefix" { type = string }
variable "environment" { type = string }
variable "seleccionadora_name" { type = string }
# output "lambda" { value = module.lambda }

# module "lambda" {
#   source      = "../../modules/lambda"
#   prefix      = var.prefix
#   environment = var.environment
#   name        = "api"
#   description = "API"
#   handler     = "main.handler"
#   permissions = ["lambda"]
#   variables = {
#     "SELECCIONADORA_NAME" = var.seleccionadora_name
#   }
#   url = true
# }

data "archive_file" "dummy_lambda_archive" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"

  source {
    content  = "dummy"
    filename = "dummy.txt"
  }
}

resource "aws_iam_role" "iam_role" {
  name = "${var.prefix}-${var.environment}-iam-lmb-api"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["lambda.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_lambda_function" "lambda_function" {
  architectures = ["arm64"]
  description   = "API"
  filename      = data.archive_file.dummy_lambda_archive.output_path
  function_name = "${var.prefix}-${var.environment}-lmb-api"
  handler       = "main.handler"
  memory_size   = 128
  package_type  = "Zip"
  role          = aws_iam_role.iam_role.arn
  runtime       = "nodejs16.x"
  timeout       = 1

  environment {
    variables = {
      "SELECCIONADORA_NAME" = var.seleccionadora_name
    }
  }
}

resource "aws_lambda_function_url" "url" {
  function_name      = aws_lambda_function.lambda_function.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
