# Terraform-aws-deploy-xxx

## Manual Deployment

```bash
ENV="sbx"
terraform init -reconfigure -backend-config ./${ENV}.terraform.conf -var-file ./${ENV}.terraform.tfvars
terraform apply -var-file ./${ENV}.terraform.tfvars
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
