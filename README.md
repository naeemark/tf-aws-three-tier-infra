# Terraform Three Tier Infrasture on AWS

Demonstration of requirements understanding, proposing a solution and implementation of _Infrastructure as a Code_.

---

### What is this repository for

- A terraform project to provide the infrastructure for a three-tier application
- Demonstrates infrastructure architecture on AWS Cloud
- CI/CD to be implemented using [Github Actions](https://github.com/features/actions).
- The live environment will be established on AWS.

---

#### Directory Structure

```bash
├── .github
│   └── workflows
│       └── terraform.yml
├── .gitignore
├── README.md
├── blueprint
│   ├── backend.tf
│   ├── main.tf
│   ├── modules
│   │   ├── backend
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── bastion
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── database
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── frontend
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   ├── load_balancer
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── network
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── security_groups
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   ├── outputs.tf
│   └── variables.tf
├── envs
│   └── dev
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── scripts
    ├── init_backend_server.sh
    ├── init_bastion_host.sh
    └── init_frontend_server.sh
```

### Developer Setup

To setup the project locally you need to clone this repo, from `main` branch or some latest `TAG`

cd to `envs/dev`

```bash
# cd to `envs/dev` and initialize the project
$ terraform init

#  to Validate
$ terraform validate

# to plan
$ terraform plan

# Apply the changes to aws cloud
$ terraform apply

# Cleanup
$ terraform destroy
```

### Configuration

- Terraform should be installed
- ⚠️ AWS Credentials should be setup as `muaksite` profile of local machine

### Pre-reqs

- terrafom (used `Terraform v0.14.11`)
- aws credentials
- VS Code

## Deployment

- When a `pull request` is merged in `main`, `Github Action` starts and following steps are done by automated CI/CD:
  - Makes a deployment to AWS (Mock)

## Contribution guidelines

- Forks are always appreciated
