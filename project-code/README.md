# Terraform AWS Infrastructure

This project demonstrates the provisioning of AWS infrastructure using
Terraform as Infrastructure as Code (IaC).

The project is developed incrementally to demonstrate how a Terraform
infrastructure can evolve from a basic working configuration into a more
dynamic, reusable, and automated infrastructure implementation by using count Meta-argument

## Current Version

The current implementation includes:

- AWS VPC
- Public and private subnets
- Internet Gateway
- Public and private route tables
- NAT Gateway
- Elastic IP
- Security Group
- EC2 instances
- AWS Key Pair
- Amazon S3 remote Terraform backend
- S3 lockfile-based state locking
- Terraform variables
- Terraform locals
- Dynamic subnet classification
- Dynamic EC2 instance deployment using `count`
- GitHub Actions CI/CD automation
- Terraform deployment workflow
- Terraform destroy workflow
- Terraform drift detection workflow

---

## Architecture

The infrastructure consists of:

- AWS VPC
- Multiple public subnets
- Multiple private subnets
- Internet Gateway
- Public route table
- Private route tables
- NAT Gateway per Availability Zone
- Elastic IP per NAT Gateway
- Security Group
- EC2 instances
- AWS Key Pair
- Amazon S3 remote Terraform backend
- S3 lockfile-based state locking
- GitHub Actions CI/CD

### Architecture Flow

```text
                              Internet
                                  |
                                  |
                         Internet Gateway
                                  |
                 +----------------+----------------+
                 |                                 |
           Public Subnet                     Public Subnet
                 |                                 |
              EC2(s)                         NAT Gateway
                                                   |
                                                   |
                                            Private Subnet
                                                   |
                                            Private Route Table
                                                   |
                                               Internet

The infrastructure supports both public and private EC2 instances.

The number of public and private EC2 instances is controlled through
Terraform variables.

For example:

public_instance_count  = 2
private_instance_count = 2    

Public instances receive a public IP address, while private instances
are deployed without a public IP address.

The private subnets use NAT Gateways for outbound Internet connectivity.

Terraform Components
Component	Description
VPC	Creates the main VPC using a configurable CIDR block
Public Subnet	Provides Internet-facing network connectivity
Private Subnet	Provides private network connectivity
Internet Gateway	Provides Internet connectivity for public resources
NAT Gateway	Provides outbound Internet connectivity for private resources
Elastic IP	Provides a static public IP for each NAT Gateway
Route Tables	Controls public and private network routing
Security Group	Controls inbound and outbound traffic
EC2	Deploys configurable public and private EC2 instances
Key Pair	Provides SSH authentication for EC2 instances
S3 Backend	Stores Terraform state remotely
State Locking	Uses the S3 lockfile mechanism for state locking
GitHub Actions	Automates Terraform plan, apply, destroy, and drift detection
Network Design

The VPC is configured using variables.

Example:

VPC
10.0.0.0/16
│
├── Public Subnet 1
│   └── 10.0.1.0/24
│
├── Public Subnet 2
│   └── 10.0.2.0/24
│
├── Private Subnet 1
│   └── 10.0.3.0/24
│
└── Private Subnet 2
    └── 10.0.4.0/24

Subnet configuration is defined through the subnet_config variable.

Example:

subnet_config = [
  {
    cidr_block = "10.0.1.0/24"
    name       = "public-subnet-1"
    type       = "public"
  },
  {
    cidr_block = "10.0.2.0/24"
    name       = "public-subnet-2"
    type       = "public"
  },
  {
    cidr_block = "10.0.3.0/24"
    name       = "private-subnet-1"
    type       = "private"
  },
  {
    cidr_block = "10.0.4.0/24"
    name       = "private-subnet-2"
    type       = "private"
  }
]

Terraform dynamically identifies public and private subnet indexes using
locals instead of hardcoding subnet indexes.

Public Subnet

Public subnets are associated with a route table containing a default
route through the Internet Gateway.

Public Subnet
      |
Public Route Table
      |
Internet Gateway
      |
   Internet
Private Subnet

Private subnets are associated with private route tables containing a
default route through the NAT Gateway.

Private Subnet
      |
Private Route Table
      |
NAT Gateway
      |
Internet Gateway
      |
   Internet
Multi-AZ Network Design

The infrastructure uses multiple Availability Zones.

Public subnets are distributed across the configured Availability Zones.

NAT Gateways are created per Availability Zone to provide outbound
connectivity for private resources.

Dynamic EC2 Deployment

EC2 instances are dynamically configured using Terraform count.

The number of public and private instances can be controlled independently.

Example:

public_instance_count  = 2
private_instance_count = 2

The configuration also supports deploying no public EC2 instances.

Example:

public_instance_count  = 0
private_instance_count = 2

In this configuration, Terraform creates only the private EC2 instances.

The instance configuration is generated dynamically using Terraform locals.

Public and private instances are assigned different properties:

Public Instance
    |
    ├── Public Subnet
    ├── Public IP
    └── Public instance configuration

Private Instance
    |
    ├── Private Subnet
    ├── No Public IP
    └── Private instance configuration

This design allows the infrastructure to be reused for different
deployment requirements without modifying the Terraform resource
definitions.

Terraform Variables and Locals

The project uses Terraform variables to remove hardcoded configuration
values.

Examples include:

AWS region
VPC CIDR
Subnet configuration
Route CIDR
Security group rules
EC2 instance counts
EC2 instance type
Root block device configuration
Key pair configuration

Terraform locals are used for derived configuration and reusable values.

Examples include:

Common tags
AMI IDs
Availability Zones
Public subnet indexes
Private subnet indexes
Dynamic EC2 instance configuration

This separates user-provided configuration from Terraform-derived values.

Security

The current demonstration configuration allows:

Inbound
HTTP - TCP/80 from 0.0.0.0/0
SSH - TCP/22 from 0.0.0.0/0
Outbound
All traffic to 0.0.0.0/0

Security Note: SSH access from 0.0.0.0/0 is intentionally used
for demonstration and testing. In production environments, SSH access
should be restricted to trusted CIDR ranges or replaced with a more
secure access mechanism.

Terraform Version
Terraform:    ~> 1.13
AWS Provider: ~> 6.0
AWS Region

The current infrastructure is configured for:

us-east-1

The region is configurable through the Terraform region variable.

Repository Structure
terraform-aws-infra/
│
├── project-code/
│   ├── versions.tf
│   ├── provider.tf
│   ├── backend.tf
│   ├── variable.tf
│   ├── terraform.tfvars
│   ├── locals.tf
│   ├── network.tf
│   ├── security.tf
│   ├── keypair.tf
│   ├── compute.tf
│   ├── output.tf
│   ├── .gitignore
│   └── .terraform.lock.hcl
│
├── .github/
│   └── workflows/
│       ├── deployment.yml
│       ├── destroy.yml
│       └── drift.yml
│
└── README.md
Prerequisites

Before deploying the infrastructure, make sure you have:

An AWS account
Terraform installed
AWS CLI installed and configured
An existing S3 bucket for Terraform remote state
An SSH public/private key pair
Appropriate AWS IAM permissions
GitHub repository configured for GitHub Actions if CI/CD is required
Terraform Backend

Terraform state is stored remotely in Amazon S3.

The backend provides:

Remote Terraform state storage
Centralized state management
State locking using the S3 lockfile mechanism
Separation of Terraform state from the Git repository

The Terraform state file is intentionally excluded from the Git repository.

The S3 backend bucket must exist before running terraform init.

Deployment
1. Clone the repository
git clone <repository-url>
cd terraform-aws-infra/project-code
2. Initialize Terraform
terraform init
3. Format the Terraform configuration
terraform fmt -recursive
4. Validate the configuration
terraform validate
5. Review the execution plan
terraform plan
6. Deploy the infrastructure
terraform apply

Review the plan and confirm the deployment when prompted.

CI/CD Automation

The project includes GitHub Actions workflows for Terraform automation.

Deployment Workflow

The deployment workflow supports:

Terraform formatting check
Terraform initialization
Terraform validation
Terraform plan for pull requests
Terraform apply after changes are merged to the main branch
AWS authentication using GitHub OIDC
Separate AWS roles for plan and apply operations
Destroy Workflow

The destroy workflow is manually triggered and is used to destroy the
Terraform-managed infrastructure.

The workflow includes a confirmation input to reduce the possibility of
accidental destruction.

Drift Detection Workflow

The drift detection workflow runs Terraform plan using
-detailed-exitcode.

Terraform exit codes are interpreted as:

0 → No changes detected
2 → Drift detected
1 → Terraform error

The workflow fails when infrastructure drift is detected.

Terraform Outputs

After deployment, Terraform provides information about the created
infrastructure, including:

VPC ID
Public subnet IDs
Private subnet IDs
EC2 instance IDs
EC2 public IP addresses
Elastic IPs
Internet Gateway ID
NAT Gateway IDs
CI/CD-related outputs

To display the outputs:

terraform output
Destroy Infrastructure

To remove the infrastructure created by Terraform:

terraform destroy

Make sure you understand the resources that will be removed before
confirming the destroy operation.

The project also provides a GitHub Actions destroy workflow for controlled
remote execution.

Project Evolution

This repository is intentionally developed in multiple stages to
demonstrate progressive improvement of Terraform infrastructure.

v1.0.0-base

Initial working AWS infrastructure containing:

VPC
Public and private subnets
Internet Gateway
NAT Gateway
Route tables
Security Group
EC2 instance
Key Pair
S3 remote backend
Terraform outputs
v1.1.0-variables

Introduced Terraform variables and locals.

Improvements included:

Removal of hardcoded configuration values
Configurable VPC CIDR
Configurable subnet configuration
Configurable security rules
Configurable EC2 instance type
Configurable root block device
Configurable key pair
Common tags using locals
AMI lookup through locals
Dynamic Availability Zone handling
Dynamic public/private subnet identification
v1.2.0-count

Introduces dynamic EC2 deployment using Terraform count.

Improvements include:

Configurable public EC2 instance count
Configurable private EC2 instance count
Dynamic public/private subnet selection
Support for public_instance_count = 0
Dynamic EC2 instance configuration using locals
Reduced dependency on hardcoded resource indexes
Planned Improvements

Future versions may introduce:

for_each
Reusable Terraform modules
Improved infrastructure reusability
More advanced security controls
Improved multi-environment support
Enhanced CI/CD automation
Tag-based deployment workflows
Additional monitoring and alerting
High-availability improvements
Git Versioning

The project uses Git tags to identify major infrastructure milestones.

Current milestones:

v1.0.0-base
      ↓
v1.1.0-variables
      ↓
v1.2.0-count
      ↓
v1.3.0-for-each
      ↓
v2.0.0-modules

Each version represents a specific improvement to the Terraform
implementation.

This allows each stage of the Terraform infrastructure to be reviewed
independently.

Security Considerations

This project is intended as a demonstration and portfolio project.

For production environments, additional security and reliability
considerations should be implemented, including:

Restricting SSH access to trusted CIDR ranges
Using least-privilege IAM policies
Using GitHub OIDC instead of long-lived AWS credentials
Encrypting Terraform state
Enabling appropriate S3 bucket security controls
Implementing multi-AZ architecture
Using multiple NAT Gateways where required for high availability
Implementing monitoring and alerting
Managing secrets through appropriate secret-management solutions
Using separate environments for development, staging, and production
Author

Ashutosh Kumar

AWS | DevOps | Terraform | Kubernetes | CI/CD



