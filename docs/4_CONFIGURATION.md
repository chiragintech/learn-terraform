# Configuration

### Blocks

- each component has a specific purpose, easy to organize and understand configs.
- flexible, don't need to use all the components to build infra.
- reusable, modular - easy to maintain and scale.

### Block types

- provider: connect to cloud platforms or services
    Core system (resource graph, state management etc) of terraform connect to cloud platforms and other services (API driven platforms)
    - provider can manage multiple resources on that platform.
    - docs in registry.terraform.io
    Configuration infra between code and different platforms.
    Extend base functionality, connect to any API driven platform.
    Define where and what terraform can manage. (Github repos, Kubernetes cluster etc)
    Resources are implemented by a provider.
    Hashicorp or partners/community maintains providers.
    Developed separately from terraform core. (different versioning)
    - region, profile, tenant id, subscription id, client id and client secret are some of the properties within a provider block
    - avoid updating if breaking changes
    - you can have alias for same provider types - multi cloud or multi account deployments.
    
    E.g: provider "aws" { #name of provider
            alias = "prod" # alias for same provider (you can call provider = aws.prod)
            region = "us-east-2"
            profile = "prd-workload" # which credential, role
            # arguments - max retries, authentication args (but better to be env vars) etc
    }

- resource: infra that terraform creates, updates or deletes
    pods, pvcs, secrets, services etc.
    Specific infra pieces you want to create, manage or modify.
    Blueprint with the settings you need to configure each resource
    - What type of resource?
    - How should resource be configured? (settings/args)
    - Resource identifiers (type.name)
    - Resource referencing (repository = type.name of a resource above)
    - Resource names must start with a letter or underscore (contains only letters, digits, underscores and dashes)
    Load Balancer, firewall rule, VM, DB (web_app.tf)

- data: retrieve info about existing resources to use in config
    - retrieve info about cluster dynamically (existing resources)
    colo cluster (rented out servers in a datacenter)
    - dependency resolution (when one resource relies on properties of another existing resource)
    - avoid harcoding values - dynamic pulling
    E.g:
        data "aws_vpc" "prd" {
            filter {
                name   = "tag:Name"
                values = ["prd-vpc"]
            }
        } # resource block can get properties from data blocks
        # output values from both
    - data block attributes - data.type.name.attribute

- variable: make code reusable by defining customizable values for each run
    - dry - don't repeat yourself
    - in arguments, you can put var.xyz and then change those variables according to your workloads
    - prod env variables, qa env variables, dev env variables (different variables, same template)
    - flexibility and ease and dynamic
    - reused and customized input
    - centralized management of values
    E.g: variable "vsphere_datacenter" {
        descrtiption = "Name of datacenter"
        type         = string # does type inference also if not specified
        default      = "prd-workload-dc"
    }
    Types of variables:
    Primitive:
    1. string
    2. number
    3. bool
    Complex
    1. list (ordered)
    2. maps {key=value} - map(string) (identified by key)
    3. Set (collection of guaranteed unique values, cannot use index since they are unordered) - set(string) - convert to list for access

    - reference by var.variable_name / var.variable_name[0]
    - we can have default values (not for sensitive values) - safety net
    - env var: export TF_VAR_variable_name=""
    - .tfvars (key=value) usually excluded from version control when it contains sensitive info
    - through CLI -var="key=value" (takes priority over all other assignments)
    E.g: `terraform plan -var="enable_logging=true"`, also `-var "enable_logging=true"`
    - Order of precedence: CLI > *.auto.tfvars > *.tfvars > env vars > default

- output: display or share essential info about resources after deployment
    - Get info to access resources, display key info about infra after deployment
    - enable data sharing and facilitate workflow automation
    - also, useful for passing data between modules
    E.g: output output_name {
        description = 
        value       = variable
    }
    - Outputs shown in CLI after terraform has finished its run.
    - Stored in state file and can be accessed without rerunning config using `terraform output`.
    - Can mark as sensitive to hide in CLI.

- terraform: define settings or resources in a config like required terraform version
    - maintain same version across teams - terraform version, providers versions, backend settings for state management.
    - where state is stored?
    E.g: terraform {
            required_version = "~> 1.10.0" # 1.10.x

            required_providers {
                aws = {
                    source = "hashicorp/aws"
                    version = "5.87.0" # exact version
                }
            }

            backend "s3" { # place to store state
                bucket = 
                key    =
                region =
            }
    }
    - version constraints - "version" is exact, ">=version" is v or greater, "~> 1.11.0" is v1.11.x, allows patch versions.


- module: reusable configs that group related resources - make it easy to share configs
- import: pulls existing resources into terraform management
and more!