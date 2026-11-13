# Basics of Terraform

### Need

- Increasing cloud spend vs less skilled workers.
- Increasing multi-cloud deployments - requiring cloud agnostic solutions.
- IaC (Infrastructure as Code) - process of managing and provisioning computer data center resources through machine-readable definition files, rather than via physical hardware configuration or interactive configuration tools.

### Installation

- brew install for Mac
- For linux envs, we have brew install or downloading the binary.
- After downloading the binary, add to path.
- `echo $PATH` - `mv [terraform exe path] /opt/homebrew/bin/terraform`
- `terraform version`

### AWS Credentials

- go to IAM
- Create User - "terraform" - attach policies - VPC policies (Virtual Private Cloud - virtual servers and databases.) - free - VPCFullAccess
- User - security - access keys - create access key
- export AWS_ACCESS_KEY_ID=xxxx and export AWS_SECRET_ACCESS_KEY=xxx and export AWS_DEFAULT_REGION=us-east-1

### Azure Credentials

- `terraform init`
- `az login`
- export ARM_SUBSCRIPTION_ID=xxx
- `terraform apply` (creates a state file)


