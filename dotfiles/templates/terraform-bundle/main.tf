module "module_name" {
  source = "../../terraform-module/terraform-aws-module-module_name"

  naming = var.naming

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
}
