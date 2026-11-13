# Terraform Workflow

- Writing configs, initializing workspace, planning changes, applying changes, and removing infra if necessary.
#### 1. Write (create or modify terraform config files)

- Develop config files that define desired state (end result - VMs, networks and properties for each)
- Terraform matches the real world infra with this state you define.
- Iterative, you can refine incrementally.

##### 1a. Initialize (Download plugins)

- Setups working directory
- initialize backend (local machine), provider plugins.
- Prepare env to run other commands, download required providers and modules used in terraform configuration.
- Configures backend for storing terraform state and creates the lock file (which provider versions)
- Run anytime you add, remove or upgrade providers/modules or change the backend settings in your configuraiton.
- We have providers (aws, azure, gcp) and modules (network, eks) stored in github.
- Under providers, terraform registry -> azure/github.
- `terraform init -upgrade` upgrades if new versions come up in github.

Terraform lock file:
When you run init, it creates or updates .terraform.lock.hcl in your working directory
- locks dependency versions for consistency across environments
- commit to version control and managed automatically by terraform

The .terraform directory
- Store project's providers and modules
- .terraform/providers stores cached versions of providers
- .terraform/modules contains downloaded versions of any referenced modules
- add to .gitignore - contains easily recreatable files, can get large in size and contains platform specific files
- you could delete it but run terraform init to create it and useful for troubleshooting or cleaning up old dependencies

#### 1b. Validate (After init)

- `terraform validate` checks your config files for syntax errors and ensures they are structurally valid. Catches errors before plan or apply. (Compiler essentially)
- does not communicate with providers, does not catch every error.

#### 2. Plan (preview your changes before applying them - dry run)

- generates an execution plan showing changes terraform will make to the real world resources in order to match desired state config.
- Provides output of changes that will happen if you apply the changes.
- Resources to be created (+), updated(~) and destroyed (-). (-/+) is replacement if in place is not possible like being limited to external platform API.
- Crucial for reviewing changes in prod envs to prevent downtime or errors.
- NOT required for terraform apply (but recommended)
- Refreshes state

Saving Plan:
- guaranteeing execution for review and approval workflows.
- exact actions in saved plan will be executed, no surprises.
- save plan, have it reviewed, then apply later with confidence.
- `terraform plan -out=myplan.tfplan`
- `terraform apply myplan.tfplan`

Resource graph:
- terraform automatically builds a dependency graph from your configuration to determine the order in which to create, update or destroy resources.
- resource order doesn't matter.
- graph is how terraform achieves parallel execution.
- built from resource references - when one resource refers to another's attributes, terraform creates a dependency.

Dependencies:
- Implicit (automatic) - a reference to another resource that terraform already knows about.
E.g: VMs for subnets for Virtual Network
- Explicit (manual) - when a dependency can't be automatically detected from resource references.
E.g: depends_on for creating a dependency, maybe between 2 VMs
- Mostly, implicit covers dependencies.

Parallel Resource Operations:
- Processes graph with parallel execution.
- Processes nodes as soon as their dependencies are satisfied. Non-dependent resources are created/modified simultaneously.
- By default, manages 10 operations in parallel but can be modified using the -parallelism flag.
Can be used with plan, apply and destroy commands like `terraform apply -parallelism=5`
When you are running into API rate limiting issues or for debugging/troubleshooting purposes, but usually never need to change.

#### 3. Apply (Implement changes)

- Execution - creates the resources, touching the API, makes changes to your infra.
- Runs plan first, then prompt you to proceed with the proposed changes.
- State sits between terraform config and the actual infra.

State locking:
- Locks state file during apply to prevent concurrent modifications. (to avoid conflicts if multiple people apply at same time)
- State file is updated after each resource is successfully created/modified/destroyed.
- If a resource fails during apply, it does not rollback previous successful changes, they remain in place.
- Respects dependencies - commit to version control and managed.

Standard apply:
Confirm (y/n): `terraform apply`
Saved plan: `terraform apply myplan.tfplan`
Apply and auto approve: `terraform apply -auto-approve`
(-input=false is also helpful for automation/CI/CD pipelines)

Best practises:
- review plan
- ensure you are in the right directory
- test in non prod
- read plan
- watch for unexpected changes
- be patient with large applies
- verify changes
- commit config
- document significant changes

#### 4. Destroy (Remove resources)

- terminate resources in current workspace or working directory. (also removes and keeps empty state file)
- explicity destrous all infra. prompts for confirmation like terraform plan.
- if you want to delete individual resources, delete resource blocks from .tf files and run `terraform apply`
OR `terraform destroy -target=<resource_name>`
If you don't remove from config file, it will recreate on next terraform apply.
- once a resource is destroued, terraform removes it from state file since its no longer managed.
- IRREVERSIBLE! REVIEW PLAN CAREFULLY!
- destroys from child to parent in resource dependencies
