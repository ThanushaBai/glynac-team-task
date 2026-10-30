# Team Provisioning Runbook

## Prerequisites
1. Ensure Terraform is installed (`terraform -v`).
2. Ensure Docker is running:
   - MinIO (S3): `sudo docker ps | grep minio`
   - Nomad: `sudo docker ps | grep nomad`
3. Ensure PostgreSQL is running.

## How to create a new team
Run the `team-up` script with the required `TEAM` variable:
```bash
./scripts/team-up TEAM=lab-team-04
