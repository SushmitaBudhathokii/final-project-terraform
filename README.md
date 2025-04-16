# Two-Tier Web Application Automation with Terraform, Ansible and GitHub Actions
# Terraform Component

This repository contains Terraform configurations to deploy AWS infrastructure, modularized into network and webserver, along with handling multiple environments (staging and prod). This solution includes:

*   **Modular Structure:**
    *   `modules/network`: Core networking components.
    *   `modules/webserver`: Core webserver components.
    *   `network`: Network infrastructure configuration
    *   `webserver`: Web server components, including a Bastion Host and a database server.

## Prerequisites

Before deploying this Terraform solution, ensure you have the following prerequisites in place:

1.  **AWS Account:** You need an active AWS account with permissions to create and manage the resources defined in this Terraform configuration.
2.  **Terraform Installed:** Terraform must be installed on your local machine.
3.  **AWS CLI Configured:** The AWS Command Line Interface (CLI) should be configured with your AWS credentials.
4.  **S3 Bucket for Terraform State:** You need to create an S3 bucket in the `us-east-1` region to store the Terraform state files.
    *   Create an S3 bucket and reflect its name to the following configuration files:
    *   `network/config.tf`
    *   `webserver/config.tf`
    *   Ensure this bucket is created in the `us-east-1` region.
5.  **SSH Key Pairs:** You will need to create an SSH key pair in the `us-east-1` region:
    *   **This key pair will be used for SSH access to the Bastion Host. You can also use this key for EC2 instances, if desired. You can create one in the AWS Management Console under EC2 -> Key Pairs.
    *   *Important*: Securely store the private key files. These files *must* be placed in the *same* directory as your Terraform configuration files (e.g., the webserver directory of the repository).
    *   *Key Name Configuration:*  You must update the `key_name` variable in the following Terraform configuration files:
        *   `webserver/config.tf`
        *   *Make sure the `key_name` in these files matches the name of the corresponding key pair in the AWS console.*
6.  **Cloud9 Environment (Recommended):**
    *   Using an AWS Cloud9 environment simplifies the deployment process (AWS CLI pre-installed).
    *   Make sure the Cloud9 environment is created in the same region (`us-east-1`).

## Deployment Instructions

Follow these steps to deploy the infrastructure. Deploy the modules and components in the specified order.

### 1. Configure the Network Environment Variables

#### a. Configure Network Environment Variables

1.  Open the `network/variables.tf` file:
    ```bash
    vi network/variables.tf
    ```
2.  Update the env and default_tags variables to desired environment (staging or prod), and save (:x)

#### b. Configure Webserver Environment Variables

1.  Open the `webserver/variables.tf` file:
    ```bash
    vi network/variables.tf
    ```
2.  Update the env and default_tags variables to desired environment (staging or prod), and save (:x)

### 2. Initialize Modules

#### a. Initialize Network Module

1.  Navigate to the `modules/network` directory:
    ```bash
    cd modules/network
    ```
2.  Initialize Terraform:
    ```bash
    terraform init
    ```

#### b. Initialize Webserver Module

1.  Navigate to the `modules/webserver` directory:
    ```bash
    cd ../webserver
    ```
2.  Initialize Terraform:
    ```bash
    terraform init
    ```

### 3. Deploy Network Solution

1.  Navigate to the `network` directory:
    ```bash
    cd ../../network
    ```
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Plan the deployment:
    ```bash
    terraform plan
    ```
4.  Apply the configuration:
    ```bash
    terraform apply
    ```
    Type `yes` when prompted to confirm.

#### b. Deploy Webserver Solution

1.  Navigate to the `webserver` directory:
    ```bash
    cd ../webserver
    ```
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Plan the deployment:
    ```bash
    terraform plan
    ```
4.  Apply the configuration:
    ```bash
    terraform apply
    ```
    Type `yes` when prompted to confirm.


## Cleanup Instructions

To destroy the deployed infrastructure, you need to destroy in reverse order of deployment within each environment and across environments.

1.  **Destroy Webserver Components**
    *   `webserver`: `terraform destroy`
2.  **Destroy Network Components:**
    *   `network`: `terraform destroy`

Navigate to each directory and run `terraform destroy`. Type `yes` when prompted to confirm. Verify in the AWS Management Console that all resources have been deleted after each `terraform destroy` command.