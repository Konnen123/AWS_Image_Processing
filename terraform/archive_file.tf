data "archive_file" "python_lambda_package"{
    type        = "zip"
    source_dir  = "${path.module}/../lambdas/${var.lambda_name}/"
    output_path = "${path.module}/../lambdas/${var.lambda_name}.zip"
}
