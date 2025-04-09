variable "lambda_name" {
    default = "process-image"
}

variable "lambda_app_version" {
    default = "0.0.1-SNAPSHOT"
}

variable "lambda_description" {
    default = "Process Image Lambda Function"
}

variable "lambda_runtime" {
    default = "java21"
}

variable "lambda_function_path" {
    default = "src/main/java/com/example/processimage/Handler.java"
}

variable "lambda_handler" {
    default = "com.example.processimage.Handler::handleRequest"
}

variable "lambda_timeout" {
    default = 30
}

variable "bucket_name" {
    default = "process-image-bucket-upload"
}
