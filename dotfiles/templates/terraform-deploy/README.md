# Terraform-aws-deploy-xxx

Deployment repository for xxx containing needed resources like:
- IAM Roles & policies
- ....

## Manual Deployment

- Ensure you have the same structure of the git server

```bash
.
├── terraform-bundle
│   └── terraform-aws-bundle-xxx
├── terraform-deploy
│   └── terraform-aws-deploy-xxx
└── terraform-module
    └── terraform-aws-module-naming
```

- Once you have the deploy, bundle and module repositories cloned on your machine, go to the deploy directory and set your credentials in your environment

```bash
vim ~/.aws/config
vim ~/.aws/credentials
export AWS_PROFILE="profile_name"
```

- Then apply the terraform code with the following commands

```bash
ENV="sbx"
terraform init -reconfigure -backend-config ./${ENV}.terraform.conf -var-file ./${ENV}.terraform.tfvars
terraform apply -var-file ./${ENV}.terraform.tfvars
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
