variable "prefix" { type = string }
variable "environment" { type = string }
variable "seleccionadora_name" { type = string }
output "lambda" { value = module.lambda }

module "lambda" {
  source      = "../../modules/lambda"
  prefix      = var.prefix
  environment = var.environment
  name        = "api"
  description = "API"
  handler     = "main.handler"
  permissions = ["lambda"]
  variables = {
    "SELECCIONADORA_NAME" = var.seleccionadora_name
  }
  url = true
}
