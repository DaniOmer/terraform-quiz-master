# Quiz Master IaC

![Terragrunt Version]()
![Terraform Version](https://img.shields.io/static/v1?label=Terraform&message=1.7.5&color=blue)
![Digital Ocean Cli](https://img.shields.io/badge/DigitalOcean-0080FF?&style=plastic&logo=DigitalOcean&logoColor=white)

Hub for creating and managing high-performance infrastructure for Quiz Master. Here, you'll find the terrafrom configuration
powering our cloud infrastructure, ensuring a robust and scalable implementation of our cloud infrastructure.

## Requirements

| Tool                                                               | Version | Mandatory | Usage                                                             |
| ------------------------------------------------------------------ | ------- | --------- | ----------------------------------------------------------------- |
| [Terraform](https://terraform.io)                                  | 1.7.5   | Yes       | Used to manage the various projects.                              |
| [terraform-docs](https://github.com/terraform-docs/terraform-docs) | 0.12.1  | No        | Used to generate Terraform documentation.                         |
| [tflint](https://github.com/wata727/tflint)                        | 0.33.0  | No        | Terraform linter focused on possible errors, best practices, etc. |

### Terraform

Terraform is an infrastructure as code tool that lets you build, change, and version infrastructure safely and efficiently. This includes low-level components like compute instances, storage, and networking; and high-level components like DNS entries and SaaS features.

- [Getting started with Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)
- [Setup Terraform cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Project folder structure

## How to use this project

### How to login on digital ocean to apply terraform

You must have your digital ocean profile setup by creating Digital Ocean [Personal Access Token](https://docs.digitalocean.com/reference/api/create-personal-access-token/).

Read this documentation about using DigitalOcean spaces as [Terraform Remote State backend](https://docs.digitalocean.com/products/spaces/reference/terraform-backend/)

#### 1. Export the Personal Access Token

```bash
export DO_PAT=dop_v1_feqfsildndvfiulhusdfbfuinkjcqsleisdvfgbtvr
```

#### 2. Export AWS Access and Secret Key for

```bash
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXX
```

#### 3. Provide DO_PAT as variable for terraform commands

```bash
terragrunt run-all plan -var "do_token=${DO_PAT}"
```

### How to plan or apply a specific environment (Dev for example)

Here is an example for the development environment:

```
cd envs/dev
terragrunt run-all plan -var "do_token=${DO_PAT}"
terragrunt run-all apply -var "do_token=${DO_PAT}"
```

## Documentations

#### 1. [Upload an SSH Public Key to DO droplet](./docs/ssh_setup.md)
