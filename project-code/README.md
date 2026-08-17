# Terraform AWS Infrastructure

This project demonstrates the provisioning of AWS infrastructure using
Terraform as Infrastructure as Code (IaC).

The **v1.0.0-base** version provides a working AWS infrastructure baseline
including networking, security, remote Terraform state management, and this contains **v2.0.0-var** which added variables and locals for all hardcoded value.
EC2 compute instance.

---

## Architecture

The infrastructure consists of:

- AWS VPC
- Public subnet
- Private subnet
- Internet Gateway
- Public route table
- Private route table
- NAT Gateway
- Elastic IP
- Security Group
- EC2 instance
- AWS Key Pair
- Amazon S3 remote Terraform backend

### Architecture Flow

```text
                         Internet
                            |
                            |
                    Internet Gateway
                            |
                     Public Subnet
                      /          \
                     /            \
              EC2 Instance      NAT Gateway
                                   |
                                   |
                            Private Subnet
```

The EC2 instance is deployed in the public subnet for the initial
infrastructure demonstration.

The private subnet uses the NAT Gateway for outbound Internet connectivity.

---

## Terraform Components

| Component | Description |
|---|---|
| VPC | Creates the main VPC with CIDR `10.0.0.0/16` |
| Public Subnet | Provides Internet-facing connectivity |
| Private Subnet | Provides private network connectivity |
| Internet Gateway | Provides Internet access for the public subnet |
| NAT Gateway | Provides outbound Internet access for private resources |
| Elastic IP | Provides a static public IP for the NAT Gateway |
| Route Tables | Controls public and private network routing |
| Security Group | Controls inbound and outbound traffic |
| EC2 | Deploys an Ubuntu-based EC2 instance |
| Key Pair | Provides SSH authentication for the EC2 instance |
| S3 Backend | Stores Terraform state remotely |
| State Locking | Uses S3 lockfile-based state locking |

---

## Network Design

The VPC uses the following CIDR ranges:

```text
VPC
10.0.0.0/16
│
├── Public Subnet
│   └── 10.0.1.0/24
│
└── Private Subnet
    └── 10.0.2.0/24
```

### Public Subnet

The public subnet is associated with a route table containing a default
route through the Internet Gateway.

```text
Public Subnet
      |
Route Table
      |
Internet Gateway
      |
  Internet
```

### Private Subnet

The private subnet is associated with a route table containing a default
route through the NAT Gateway.

```text
Private Subnet
      |
Private Route Table
      |
NAT Gateway
      |
Internet Gateway
      |
  Internet
```

---

## Security

The base version allows:

### Inbound

- HTTP - TCP/80 from `0.0.0.0/0`
- SSH - TCP/22 from `0.0.0.0/0`

### Outbound

- All traffic to `0.0.0.0/0`

> **Security Note:** SSH access from `0.0.0.0/0` is intentionally used in
> this base version for demonstration and testing purposes. In a later
> version, this will be improved using configurable CIDR restrictions.

---

## Terraform Version

- Terraform: `~> 1.13`
- AWS Provider: `~> 6.0`

## AWS Region

The infrastructure is configured for:

```text
us-east-1
```

---

## Repository Structure

```text
terraform-aws-infra/project-code

│
├── versions.tf
├── provider.tf
├── backend.tf
├── network.tf
├── security.tf
├── keypair.tf
├── compute.tf
├── output.tf
├── .gitignore
├── .terraform.lock.hcl
└── README.md
-

```

---

## Prerequisites

Before deploying the infrastructure, make sure you have:

- An AWS account
- Terraform installed
- AWS CLI installed and configured
- An existing S3 bucket for Terraform remote state
- An SSH public/private key pair
- Appropriate AWS IAM permissions

---

## Terraform Backend

Terraform state is stored remotely in Amazon S3.

The backend provides:

- Remote Terraform state storage
- Centralized state management
- State locking using the S3 lockfile mechanism

The Terraform state file is intentionally excluded from the Git repository.

> The S3 backend bucket must exist before running `terraform init`.

---

## Deployment

### 1. Clone the repository

```bash
git clone <repository-url>
cd terraform-aws-infra
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Format the Terraform configuration

```bash
terraform fmt -recursive
```

### 4. Validate the configuration

```bash
terraform validate
```

### 5. Review the execution plan

```bash
terraform plan
```

### 6. Deploy the infrastructure

```bash
terraform apply
```

Review the plan and confirm the deployment when prompted.

---

## Terraform Outputs

After deployment, Terraform provides information about the created
infrastructure, including:

- VPC ID
- Public subnet ID
- Private subnet ID
- EC2 instance ID
- EC2 public IP
- Elastic IP
- Internet Gateway ID
- NAT Gateway ID

To display the outputs:

```bash
terraform output
```

---

## Destroy Infrastructure

To remove the infrastructure created by Terraform:

```bash
terraform destroy
```

> Make sure you understand the resources that will be removed before
> confirming the destroy operation.

---

## Project Evolution

This repository is intentionally developed in multiple stages to demonstrate
progressive improvement of Terraform infrastructure.

### v1.0.0-base

Initial working AWS infrastructure containing:

- VPC
- Public and private subnets
- Internet Gateway
- NAT Gateway
- Route tables
- Security Group
- EC2 instance
- Key Pair
- S3 remote backend
- Terraform outputs

### Planned Improvements

The next versions will progressively introduce:

- Variables
- Locals
- Configurable security rules
- Resource `count`
- Resource `for_each`
- Reusable Terraform modules
- Improved infrastructure reusability
- CI/CD automation
- Tag-based deployment workflow

---

## Git Versioning

The project uses Git tags to identify major infrastructure milestones.

The initial baseline is:

```text
v1.0.0-base
```

Each subsequent version will represent a specific improvement to the
infrastructure implementation.

Example:

```text
v1.0.0-base
      ↓
v1.1.0-variables
      ↓
v1.2.0-count
      ↓
v1.3.0-for-each
      ↓
v2.0.0-modules
```

This allows each stage of the Terraform implementation to be reviewed
independently.

---

## Security Considerations

This project is intended as a demonstration and portfolio project.

For production environments, additional security and reliability
considerations should be implemented, including:

- Restricting SSH access to trusted CIDR ranges
- Using least-privilege IAM policies
- Encrypting Terraform state
- Enabling appropriate S3 bucket security controls
- Implementing multi-AZ architecture
- Using multiple NAT Gateways where required for high availability
- Implementing monitoring and alerting
- Managing secrets through appropriate secret-management solutions

---

## Author

**Ashutosh Kumar**

AWS | DevOps | Terraform | Kubernetes | CI/CD