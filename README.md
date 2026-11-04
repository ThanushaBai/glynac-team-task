# Glynac Team Provisioning (Team-Up / Team-Down)

## Overview
This repository contains the automation to provision and de-provision a complete sandbox environment for a team. 
It uses Terraform to create a Database, Database User, Silo S3 Storage Bucket, Nomad Namespace, and a VM, and Ansible to configure the VM.

## Features
- **Grouped Provisioning:** Create multiple team environments at once using a prefix and a count.
- **Idempotency:** Safe to run multiple times; Terraform tracks the state to ensure resources are not duplicated.
- **Zero Leftovers:** Running `team-down` completely removes all infrastructure, leaving no orphaned databases, buckets, or namespaces.
- **Configuration Management:** Ansible is integrated into the workflow to handle VM software setup.

## Prerequisites
- Terraform installed
- Ansible installed
- Docker running (Silo on port 9000, Nomad on port 4646)
- PostgreSQL running locally

## How to Use

### Create Team Environments
To create a single environment:
    ./scripts/team-up PREFIX=lab-team-03 COUNT=1

To create multiple grouped environments at once (e.g., `lab-group-1`, `lab-group-2`, `lab-group-3`):
    ./scripts/team-up PREFIX=lab-group COUNT=3

### Destroy Team Environments
To destroy a single environment:
    ./scripts/team-down PREFIX=lab-team-03 COUNT=1

To destroy a whole group of environments:
    ./scripts/team-down PREFIX=lab-group COUNT=3

## Architecture
- **Database & User:** Managed via Terraform `postgresql` provider.
- **Storage:** Managed via Terraform `aws` provider (pointed at local S3-compatible storage, e.g., Silo / MinIO).
- **Nomad Namespace:** Managed via Terraform `nomad` provider.
- **VM:** Placeholder resource managed via Terraform `null_resource`, configured by Ansible.
- **Grouping:** Terraform `count` loops allow for dynamic creation of multiple environments based on the provided prefix and count.

## What happens if it breaks?
Because this uses Terraform, the state is tracked in `terraform.tfstate`. If a run fails halfway, simply run `./scripts/team-down PREFIX=<prefix> COUNT=<count>` to roll back whatever was partially created.

<!-- END OF README -->
