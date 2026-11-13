# Terraform Foundations

### What is Terraform?

- Describes "what" needs to be done than "how", allowing the system to determine the best execution steps.
- Based on HCL (Hashicorp Configuration Language) - A human readable language used in Terraform to define infra resources in a clear, structured and reusable way.
- IaC - Automates the provisioning, management, and versioning of infrastructure.

### Benefits

- Codify infra - creating a repeatable versioned workflow to provision and manage resources.
- Standardize workflow - deploy and manage resources required for application workloads. Scale up using modules and other features.
- Platform Agnostic - any cloud or datacenter. (Universal translator for infra)
- Version Control and Auditibility - Version control systems like Github - provides a clear history and ability to revert. Compliance.
- Automation and Efficiency - Provisioning and management of infra, reduce manual tasks and accelerates deployment times.
- Scalability and Flexibility - Managing code instead of manually changing resources.
- Collaboration - On infra changes just like application code, improving transparency and reducing silos in operations.
- Consistency and Repeatability - Consistent across environments, reducing configuration drift and human errors. (dev, test, qa, prod)

### Traditional vs Terraform

- Manually clicking to get a VM, Container, Network vs Code
- Reusability - Template is same, differs in input variables

### Github

- Cloud ops team maintains main branch
- Network team - add subnets branch - pull request - merged
- Kubernetes team will do somehting similar to network team
- Uses parallelism to deploy.
- Reduce risk of mistakes by making it standardized. 
- Save infra resources and their dependencies as code in a specified environment.

### HCL

- Terraform configuration lang to describe infra that terraform manages.
- Declarative Lang 
- Easy to read and write for expression resources and dependencies
- Primary interface for terraform - what to create and what data to receive

### Resource referencing

Allows you to connect resources within your configuration, making it easy to share data between resources and build dependencies.
- Create more Dynamic configurations - terraform can use properties from one resource in another and avoid hardcoding values.
- Automatic dependency mapping - automatically determine the order of resource creation based on references.
- Resource identifiers - type and a name.
- Terraform understands all of these relationships.

E.g:
Network Configuration (Networks, Subnets)
    |   Resource reference
Firewall and VM

Kubernetes Cluster and DNS Record
    |   Resource reference
Data lookup (regions, account number - I need to know DNS and cluster I am working with)

### File names

- .tf
- .tfvars for variables
- Follow formatting, organization, commenting and documentation
- Avoid harcoding values
- Use Linters, Extensions, Built-in Tools for Code (`terraform fmt`)

### Core components

- Terraform Core - CLI tool
- Providers - extends functionality for public cloud providers, saas offerings etc (communicate with external APIs)
- Resources - Infra components or services that are managed by terraform. (VMs, networks, DNS records, cluster etc)
- State - How terraform maps desired config with real world resources on the target platform
- Modules - Reusable and sharable blocks of code that can be called over and over again (like functions and libraries)

### Terraform version

- Community (CLI)
- HCP (SaaS - Cloud) - remote state management, private reigstry for sharing modules, policy as code capabilities.
- Enterprise (Self Hosted and Managed) - complete control, RBAC, audit logging and private networking. (HCP terraform in our own environments)

### Other Tools

- IaC tools - AWS CloudFormation, Azure Bicep, Pulumi - infra provisioning and management, declarative lang, immutable infra, not platform agnostic except Pulumi but not popular
- Ansible, Chef, Puppet - Configuration management tools - installing packages, managing files, configuration systems and automate routine tasks. (Used in conjuction with terraform)

### Declarative

- What you want, not how to get it. (Not step by step approach)

### Organization

- variables.tf
- network.tf
- kubernetes.tf
- dns.tf
- firewall.tf
- outputs.tf

- Processes all files together for a resource graph.

Pattern:
- main.tf (primary infra componenents)
- variables.tf 
- outputs.tf
- providers.tf
- terraform.tfvars (define values for your varaibles - usually ignored by .gitignore)
- prod/test/dev/project subdirectories each having main.tf, variables.tf and outputs.tf each with separate state
