# Terraform-aws-deploy-xxx

## Deployment

```bash
ENV="sbx"
terraform init -reconfigure -backend-config ./${ENV}.terraform.conf -var-file ./${ENV}.terraform.tfvars
terraform apply -var-file ./${ENV}.terraform.tfvars
```