# Terraform Lambda With Logs Module

Terraform module for creating an AWS Lambda function and relevant log group. 

This module makes use of [Cloud Posse Null Label](https://github.com/cloudposse/terraform-null-label).

## Usage

main.tf
```hcl
module "my_lambda_function" {
  source = "github.com/Rail-Cloud-Formation/tf-lambda-with-logs"

  function_name = "function-name"
  runtime       = "dotnetcore3.1"
  memory_size   = 256
  handler       = "MyAssembly::RCF.MyNamespace::FunctionHandler"
  timeout       = 10

  inline_policies = [
    {
      name   = "vpc-access"
      policy = data.aws_iam_policy_document.vpc_access.json
    }
  ]

  environment_variables = {
    "REGION"        = var.region,
    "SOME_VARIABLE" = "some variable"
  }

  cloudwatch_logs_retention_in_days = 5

  # optional VPC configuration
  # subnet_ids         = module.core.private_subnet_ids
  # security_group_ids = [module.core.security_group_id]

  context = module.this.context
}
```

Define some variables for your own use case. The following specifies the Sydney AWS region and a credentials profile called `developer`. With the below parameters the resulting bucket name will be `rcf-dev-state` and DynamoDB table will be `rcf-dev-state-lock`.

dev.ap-southeast-2.tfvars
```hcl
region = "ap-southeast-2"
profile = "developer"

namespace = "rcf"
name = "my-app"
environment = "apse2"
stage = "dev"
```

Initialise and apply the backend.

```
terraform init
terraform apply -var-file dev.ap-southeast-2.tfvars
```