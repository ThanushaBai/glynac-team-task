# Glynac Team Provisioning (Team-Up / Team-Down)

## Overview
This repository contains the automation to provision and de-provision a complete sandbox environment for a team. 
Running `team-up` provisions the infrastructure using Terraform and configures the software using Ansible. 
Running `team-down` removes the Ansible configuration and destroys the Terraform infrastructure with zero leftovers.

## Prerequisites
- Terraform installed
- Ansible installed
- Docker running (MinIO on port 9000, Nomad on port 4646)
- PostgreSQL running locally

## How to Use

### Create a Team Environment
Run the wrapper script with the TEAM variable:
    ./scripts/team-up TEAM=lab-team-03

### Destroy a Team Environment
Run the wrapper script with the TEAM variable:
    ./scripts/team-down TEAM=lab-team-03

## Architecture
- Database & User: Managed via Terraform postgresql provider.
- Storage: Managed via Terraform aws provider (pointed at local S3-compatible storage, e.g., Silo / MinIO).
- Nomad Namespace: Managed via Terraform nomad provider.
- VM: Placeholder resource managed via Terraform null_resource.
- VM Software Configuration: Managed via Ansible playbook.

## What happens if it breaks?
Because this uses Terraform, the state is tracked in terraform.tfstate. If a run fails halfway, simply run the team-down command to roll back whatever was partially created.

<!-- END OF README -->
