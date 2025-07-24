# terraform-ecs
deploying a two-tier docker app on ecs cluster using terraform

# 🚀 AWS ECS Quote Application Deployment with Terraform

This project automates the deployment of a containerized **Quote application** using **Amazon ECS (Fargate)**, **ECR**, and **Terraform**. It consists of a backend service and a frontend service built with Docker and managed via ECS.

---

## 📦 Architecture Overview

The architecture consists of:
- A **VPC** with subnets and routing
- **Security Groups** allowing HTTP/HTTPS/SSH
- **ECS Cluster** running on **Fargate**
- Two **ECS Services**:
  - `quote-backend` (port 8080)
  - `quote-frontend` (port 80)
- Images pulled from **Amazon ECR**
- Optional: future support for ALB and Route53 DNS

![Architecture Diagram](./A_flowchart_diagram_in_digital_vector_graphic_form.png)

---

## 🛠️ Deployment Process

### 📁 Project Structure

```
terraform-ecs/
├── docker/
├── scripts/
│   ├── test-ecs-health.sh
├── terraform/
│   ├── 00-providers.tf
│   ├── 01-variables.tf
│   ├── ...
│   ├── 11-ecs-services.tf
│   └── 12-health-check.tf
├── terraform.tfvars
├── terraform.tfstate
└── README.md

```

### ✅ Health Check & Status Validation

To validate that services are healthy and running:
Option 1: Standalone Script
```
./scripts/test-ecs-health.sh
```
It performs:

    ECS Service Status checks. 

    IP resolution from ENIs. 

    curl validation of both backend and frontend apps. 

### 🧠 Notes

    IAM role ecsTaskExecutionRole is created for ECS task permissions

    Security Group allows access to ports 22, 80, 443

    All ECS tasks run in awsvpc mode with public IP enabled

    Next improvements:  

        Add ALB + Target Groups. 

        Use Route53 + ACM for HTTPS. 

        Auto scaling configuration. 


👨‍💻 Author

Timur Samanchi
GitHub: [[your-profile-link](https://github.com/timursamanchi)]