# CLI

- primary way to interact with terraform and execute workflow steps.
- consistency and repeatability across workflow, regardless of platform.
- `terraform <subcommand> [options or flags]`
- terraform invokes the CLI.

### Other commands

- console, force-unlock, get, graph, login, logout, modules, output, providers, test, version, workspace and more.
- state - manage items in state file.
- show - display info about your managed infra.
- import - bring existing infra under terraform management.

### Env variables with CLI

- pass config settings and credentials to terraform without hardcoding them into your files.
- increase security by keeping sensitive data out of .tf files.
- export TF_LOG=DEBUG
- export TF_VAR_svr_name="prod-db-01" (if starts with TVF_VAR)
- export AWS_ACCESS_KEY_ID=xxx

`terraform state list` -> resources it managers
random_pet.my_pet
random_pet.name

`terraform -install-autocomplete`

`terraform --help`
`terraform plan --help`

`terraform fmt -recursive` for sub directories too