data "template_file" "template" {
  template = file("${path.module}/templates/${var.environment}.userdata.tpl")
}