# Glasnost Terraform Infrastructure

โครงสร้างนี้ใช้ Terragrunt เพื่อจัดการ Terraform modules และ environments

## โครงสร้างโฟลเดอร์

```
terraform/
├── terragrunt.hcl           # Root configuration
├── modules/                 # Terraform modules
│   └── aws/
│       └── vpc/            # VPC module
└── environments/            # Environment-specific configurations
    ├── dev/
    │   └── vpc/
    │       └── terragrunt.hcl
    └── prod/
        └── vpc/
            └── terragrunt.hcl
```

## การใช้งาน

### Prerequisites

ติดตั้ง Terragrunt และ Terraform:
```bash
# Install Terraform
brew install terraform  # macOS
choco install terraform # Windows

# Install Terragrunt
brew install terragrunt  # macOS
choco install terragrunt # Windows
```

### ตั้งค่า Environment Variables

```bash
export AWS_REGION=us-east-1
export ENV=dev
```

### คำสั่งพื้นฐาน

**เข้าไปใน environment directory:**
```bash
cd environments/dev/vpc
```

**Initialize:**
```bash
terragrunt init
```

**Plan:**
```bash
terragrunt plan
```

**Apply:**
```bash
terragrunt apply
```

**Destroy:**
```bash
terragrunt destroy
```

### Run-all Commands

รัน command สำหรับทุก module ใน environment:

```bash
cd environments/dev
terragrunt run-all plan
terragrunt run-all apply
```

## VPC Module

Module นี้สร้าง VPC และ subnets ตาม configuration

### Inputs

- `vpc_name`: ชื่อ VPC
- `vpc_cidr`: CIDR block สำหรับ VPC
- `subnets`: List ของ CIDR blocks สำหรับ subnets
- `availability_zones`: List ของ availability zones
- `enable_dns_hostnames`: เปิด DNS hostnames (default: true)
- `enable_dns_support`: เปิด DNS support (default: true)
- `tags`: Tags เพิ่มเติม

### Outputs

- `vpc_id`: ID ของ VPC
- `vpc_arn`: ARN ของ VPC
- `subnet_ids`: List ของ subnet IDs
- `subnet_arns`: List ของ subnet ARNs

## Remote State

State files จะถูกเก็บใน S3 bucket:
- Dev: `glasnost-terraform-state-dev`
- Prod: `glasnost-terraform-state-prod`

State locking ใช้ DynamoDB table:
- Dev: `glasnost-terraform-locks-dev`
- Prod: `glasnost-terraform-locks-prod`

**หมายเหตุ:** ต้องสร้าง S3 bucket และ DynamoDB table ก่อนใช้งาน
