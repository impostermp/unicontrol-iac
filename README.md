# Terraform Infrastructure Deployment

This repository contains Terraform code for provisioning and managing cloud infrastructure. Currently aiming to support alpha, beta & prod environments.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Setup and Configuration](#setup-and-configuration)
- [Usage](#usage)
- [Best Practices](#best-practices)

## Project Overview

This project uses Terraform to define infrastructure as code, making it easy to version control and manage infrastructure changes. By using a declarative approach, we ensure the desired state of the infrastructure is consistently achieved.

The project includes configurations for:
- Networking (VPC, subnets, security groups)
- Compute resources (EC2)
- Storage (S3 buckets, cloud DB)
- Load balancers and autoscaling
- and more.

## Architecture

This setup includes:
- **VPC**: A virtual private cloud with public and private subnets, enabling secure and isolated networking.
- **Compute Resources**: EC2 instances in private subnets, with only load balancers exposed to the internet.
- **Storage and Databases**: Managed database services and storage buckets.
- **Load Balancer**: Distributes traffic to instances.
- **Security Groups**: 

## Prerequisites

- **Terraform**: [Install Terraform](https://www.terraform.io/downloads.html) (v1.0 or later recommended).
- **Cloud Provider CLI**: Install and configure the CLI for your cloud provider: https://aws.amazon.com/cli/
- **Access Credentials**: Ensure your cloud provider credentials are configured in your CLI and have the required permissions to provision resources.
- **SSH access**: SSH access to the github repo.
## Setup and Configuration

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/your-username/terraform-infrastructure.git
    cd terraform-infrastructure
    ```

2. **Configure Backend**:
    Update the `backend` configuration in `main.tf` to specify the remote backend for storing Terraform state, such as an S3 bucket, Azure storage account, or Google Cloud storage.

3. **Environment Variables**:
    Secrets used for very vulnerable data such as passwords, .tfvars environment variables used for everything else.

4. **Initialize the Project**:
    Initialize the Terraform project to download required providers and modules.
    ```bash
    terraform init
    ```
5. **Deploy changes**:
    Committing changes will trigger the pipeline which tests and applies changes.


## Usage

1. **Format and Validate**:
    - Format the code for readability:
      ```bash
      terraform fmt
      ```
    - Validate the configuration:
      ```bash
      terraform validate
      ```

2. **Plan**:
    Generate an execution plan to preview the resources Terraform will create or modify.
    ```bash
    terraform plan -var-file="environment.tfvars"
    ```

3. **Apply**:
    Apply the configuration to create or update the resources.
    ```bash
    terraform apply -var-file="environment.tfvars"
    ```

4. **Destroy**:
    When needed, destroy the infrastructure to clean up resources.
    ```bash
    terraform destroy -var-file="environment.tfvars"
    ```

## Best Practices

- **Modularize**: Use modules for reusable components (e.g., networking, compute, security).
- **Remote State Management**: Use a remote backend (like S3 or GCS) to store the Terraform state file securely.
- **State Locking**: Enable state locking to prevent multiple users from making concurrent modifications.
- **Version Control**: Pin provider versions to avoid unexpected changes in behavior when providers are updated.
- **Environment Isolation**: Use separate state files and configurations for each environment (e.g., dev, staging, prod) to prevent cross-environment interference.
- **Avoid configuration drift**: Only modify resources from within this template to ensure that no config drift can occur.

