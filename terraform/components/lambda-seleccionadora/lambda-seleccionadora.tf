variable "prefix" { type = string }
variable "environment" { type = string }
output "lambda" { value = module.lambda }

module "lambda" {
  source      = "../../modules/lambda"
  prefix      = var.prefix
  environment = var.environment
  name        = "seleccionadora"
  description = "Selecciona una de las casas de magos de hogwarts"
  handler     = "main.handler"
}
