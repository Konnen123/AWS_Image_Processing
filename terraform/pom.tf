locals {
  lambda_root_path = "../lambdas/${var.lambda_name}"
  handler_file     = "${local.lambda_root_path}/${var.lambda_function_path}"
}

data "template_file" "pom_template" {
  template = file("${local.lambda_root_path}/pom.tpl")

  vars = {
    artifact    = var.lambda_name
    version     = var.lambda_app_version
    description = var.lambda_description
  }
}

resource "local_file" "pom_xml"{
  content  = data.template_file.pom_template.rendered
  filename = "${local.lambda_root_path}/pom.xml"
}

resource "null_resource" "build_jar" {
  triggers = {
    java_input_hash = sha256(filebase64(local.handler_file))
  }

  provisioner "local-exec" {
    command = "mvn package -f ${local.lambda_root_path}/pom.xml clean package"
  }

  depends_on = [
    local_file.pom_xml
  ]
}