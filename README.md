# 🚀 AWS Static Website with Auto-Deployment

Deploy a static website on AWS with **automated deployment and cache invalidation** using Terraform.

## 🏗️ **What This Creates**

```
📁 ZIP Upload → S3 Source → CodePipeline → 🚦 Approval → CodeBuild → S3 Website → CloudFront → 🌐 Website
                                            ↓               ↓
                                      👤 Manual Review   🔄 Auto-Invalidation
```

### **AWS Resources**
- **S3 Buckets**: Website hosting + Source (ZIP uploads) + Pipeline artifacts
- **CloudFront**: Global CDN with Origin Access Control (OAC)
- **CodePipeline**: Automated deployment workflow
- **CodeBuild**: Unzips files, syncs to S3, invalidates CloudFront cache
- **IAM Roles**: Secure permissions for all services

## ⚡ **Quick Start**

### **1. Setup**
```bash
# Clone and configure
git clone <your-repo>
cd s3-cloudfront-pipeline

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit with your unique bucket name
nano terraform.tfvars
```

### **2. Deploy Infrastructure**
```bash
terraform init
terraform plan
terraform apply
```

### **3. Deploy Your Website** ✨
```bash
# Zip your website files
zip website.zip index.html styles.css script.js

# Upload to trigger bucket (from terraform output)
aws s3 cp website.zip s3://your-bucket-name-source/

# Pipeline runs automatically!
# ✅ Files deployed in 2-3 minutes
# ✅ CloudFront cache invalidated automatically
```

## 🔄 **Simple Controlled Workflow**

When you upload `website.zip`:

1. **🚀 Pipeline Triggers**: CodePipeline detects new ZIP file
2. **🚦 Approval Gate**: Pipeline pauses and waits for your approval
3. **👤 Manual Review**: You review changes and click "Approve" in AWS Console
4. **📦 Build Stage**: CodeBuild extracts and syncs files to hosting bucket
5. **🔄 Cache Invalidation**: Creates CloudFront invalidation automatically
6. **✅ Live Website**: Changes visible in 1-3 minutes

**Simple and safe!** No accidental deployments without your approval.

## 📁 **Project Structure**

```
s3-cloudfront-pipeline/
├── main.tf                     # AWS resources (S3, CloudFront, CodePipeline)
├── variables.tf                # Input variables
├── outputs.tf                  # URLs and bucket names
├── terraform.tfvars.example    # Configuration template
├── terraform.tfvars            # Your configuration (create from example)
└── README.md                   # This file
```

**Note**: The CodeBuild buildspec is embedded directly in `main.tf` for simplicity - no separate buildspec file needed!

## ⚙️ **Configuration**

### **terraform.tfvars**
```hcl
aws_region  = "ap-northeast-1"              # Tokyo region
bucket_name = "your-unique-name-website"    # Must be globally unique!
```

The system creates:
- `your-unique-name-website` (hosting bucket)
- `your-unique-name-website-source` (upload trigger bucket)
- `your-unique-name-website-artifacts` (pipeline storage)

## 🛠️ **Development Workflow**

### **Option A: Simple Controlled Deployment (Recommended)**
```bash
# Make changes to your website
vim index.html

# Upload to trigger pipeline
zip website.zip index.html styles.css script.js
aws s3 cp website.zip s3://your-bucket-source/

# Pipeline pauses at approval stage 🚦
# 1. Go to: https://console.aws.amazon.com/codesuite/codepipeline/
# 2. Click your pipeline name
# 3. Click "Review" on the Approval stage
# 4. Click "Approve"
# 5. Pipeline completes deployment automatically
```

### **Option B: Manual (Testing)**
```bash
# Direct upload (manual invalidation needed)
aws s3 sync ./website/ s3://your-bucket/
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
```

## 🎓 **Learning Features**

- **Infrastructure as Code**: Everything defined in Terraform
- **Secure by Default**: Private S3 with CloudFront OAC
- **Real DevOps Workflow**: ZIP → Pipeline → Auto-deployment
- **Cache Management**: Automatic CloudFront invalidation
- **IAM Best Practices**: Minimal permissions for each service
- **Embedded Build Logic**: Buildspec defined in Terraform for maintainability

## 🔐 **Security**

- ✅ **Private S3 buckets** (no public access)
- ✅ **Origin Access Control** (OAC) for CloudFront → S3
- ✅ **HTTPS only** via CloudFront
- ✅ **Least privilege IAM** roles
- ✅ **No hardcoded credentials** in code

## 📊 **Useful Commands**

```bash
# Check outputs
terraform output

# Watch pipeline
aws codepipeline get-pipeline-state --name your-pipeline-name

# Manual invalidation (if needed)
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"

# Check bucket contents
aws s3 ls s3://your-bucket/

# Pipeline logs
aws logs describe-log-groups --log-group-name-prefix /aws/codebuild/
```

## 🌟 **Real-World Applications**

- **Corporate Websites**: Marketing sites with frequent updates
- **Documentation Sites**: Technical docs with automated publishing
- **Landing Pages**: Campaign sites with fast deployment
- **Portfolio Sites**: Personal/professional portfolios
- **SPA Deployment**: React, Vue, Angular apps

## 🚨 **Troubleshooting**

### **Pipeline Fails**
```bash
# Check CodeBuild logs
aws logs describe-log-streams --log-group-name /aws/codebuild/your-project
```

### **Website Not Loading**
- Verify CloudFront distribution status
- Check S3 bucket policy allows CloudFront
- Ensure OAC is properly configured

### **Cache Not Updating**
- Pipeline automatically invalidates cache
- Manual: `aws cloudfront create-invalidation --distribution-id ID --paths "/*"`

## 🧹 **Cleanup**

```bash
# Remove all AWS resources
terraform destroy

# Clean local files
rm -rf .terraform/
rm terraform.tfstate*
```

## 🎯 **Next Steps**

- **Custom Domain**: Add Route 53 + SSL certificate
- **Multiple Environments**: staging/production
- **Advanced Caching**: Custom TTL rules
- **Monitoring**: CloudWatch dashboards
- **Security**: WAF integration

---

**🎉 You now have a simple, production-safe deployment pipeline with manual approval!** 