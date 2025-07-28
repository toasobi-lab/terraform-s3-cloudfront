# AWS Static Website with Auto-Deployment

Deploy a static website on AWS with automated deployment and cache invalidation using Terraform.

## What This Creates

- **S3 Buckets**: Website hosting, source uploads, pipeline artifacts
- **CloudFront**: Global CDN with secure access control
- **CodePipeline**: Automated deployment with manual approval
- **CodeBuild**: File processing and cache invalidation
- **IAM Roles**: Secure permissions

## Quick Start

### 1. Setup
```bash
git clone https://github.com/toasobi-lab/terraform-s3-cloudfront.git
cd terraform-s3-cloudfront

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your unique bucket name
```

### 2. Deploy Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### 3. Deploy Your Website
```bash
# Create and upload website
zip website.zip index.html styles.css script.js
aws s3 cp website.zip s3://your-bucket-name-source/

# Approve in AWS Console → Pipeline completes automatically
```

## How It Works

1. Upload `website.zip` to source bucket
2. Pipeline triggers and waits for your approval
3. After approval, files are deployed and cache invalidated
4. Website is live in 1-3 minutes

## Configuration

**terraform.tfvars**
```hcl
aws_region  = "ap-northeast-1"              # Your AWS region
bucket_name = "your-unique-name-website"    # Must be globally unique
```

This creates three buckets:
- `your-unique-name-website` (hosting)
- `your-unique-name-website-source` (uploads)
- `your-unique-name-website-artifacts` (pipeline)

## Project Structure

```
terraform-s3-cloudfront/
├── main.tf                     # AWS resources
├── variables.tf                # Input variables  
├── outputs.tf                  # URLs and bucket names
├── terraform.tfvars.example    # Configuration template
├── terraform.tfvars            # Your configuration
└── README.md                   # This file
```

## Useful Commands

```bash
# Check outputs
terraform output

# Manual deployment (bypass pipeline)
aws s3 sync ./website/ s3://your-bucket/
aws cloudfront create-invalidation --distribution-id DIST_ID --paths "/*"

# Check pipeline status
aws codepipeline get-pipeline-state --name your-pipeline-name

# View bucket contents  
aws s3 ls s3://your-bucket/
```

## Security Features

- Private S3 buckets (no public access)
- HTTPS-only via CloudFront
- Origin Access Control for secure S3 access
- Least privilege IAM roles
- Manual approval prevents accidental deployments

## Troubleshooting

**Pipeline fails**: Check CodeBuild logs in CloudWatch  
**Website not loading**: Verify CloudFront distribution status  
**Cache not updating**: Pipeline auto-invalidates, or run manual invalidation

## Cleanup

```bash
terraform destroy
rm -rf .terraform/ terraform.tfstate*
```

---

**Production-ready static website deployment with Infrastructure as Code** 