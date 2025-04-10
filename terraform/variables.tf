variable "lambda_name" {
    default = "face-recognition"
}

variable "lambda_description" {
    default = "Process Image Lambda Function"
}

variable "lambda_runtime" {
    default = "python3.13"
}

variable "lambda_handler" {
    default = "handler.lambda_handler"
}

variable "lambda_timeout" {
    default = 15
}

variable "bucket_name" {
    default = "process-image-bucket-upload"
}
