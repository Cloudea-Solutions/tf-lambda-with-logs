variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = ""
}

variable "inline_policies" {
  type = list(object({
    name   = string
    policy = string
  }))
  default = []
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "s3_bucket" {
  description = "S3 bucket to store artifacts"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 bucket to store artifacts"
  type        = string
  default     = null
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
  default     = null
}

variable "subnet_ids" {
  description = " List of subnet IDs associated with the Lambda function"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs associated with the Lambda function"
  type        = list(string)
  default     = []
}