module "naming" {
  source = "../../terraform-module/terraform-aws-module-naming"

  corporation = "corp"
  owner       = "devops"
  environment = var.environment
  project     = "proj"
  application = "app"
}

module "bundle_name" {
  source = "../../terraform-bundle/terraform-aws-bundle-bundle_name"

  naming = module.naming

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
}
