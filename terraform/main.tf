variable "prefix" { type = string }
variable "environment" { type = string }

module "seleccionadora" {
  source      = "./components/lambda-seleccionadora"
  prefix      = var.prefix
  environment = var.environment
}
output "seleccionadora" { value = module.seleccionadora }

module "api" {
  source              = "./components/lambda-api"
  prefix              = var.prefix
  environment         = var.environment
  seleccionadora_name = module.seleccionadora.lambda.name
}
output "api" { value = module.api }
