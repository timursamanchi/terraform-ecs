
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

![Architecture Diagram](../A_flowchart_diagram_in_digital_vector_graphic_form.png)

---

## 🛠️ Deployment Process

### 📁 Project Structure

```
terraform-ecs/
├── ECS cluster architecture diagram Jul 24, 2025, 08_13_00 PM.png
├── LICENSE
├── README.md
├── docker
│   ├── quote-backend
│   │   └── Dockerfile
│   └── quote-frontend
│       ├── Dockerfile
│       ├── default.conf
│       └── index.html
├── scripts
│   ├── 13-healthcheck.tf
│   ├── get-public-ip.sh
│   ├── healthcheck-test.sh
│   ├── quote-backend-task.json
│   ├── quote-frontend-task.json
│   └── terraform.tfstate
├── terraform
│   ├── 00-providers.tf
│   ├── 01-variables.tf
│   ├── 02-locals.tf
│   ├── 03-vpc.tf
│   ├── 04-security.tf
│   ├── 05-igw.tf
│   ├── 06-subnets.tf
│   ├── 07-routes.tf
│   ├── 08-iam.tf
│   ├── 09-ecs-cluster.tf
│   ├── 10-task-definitions.tf
│   ├── 11-ecs-services.tf
│   ├── 12-cloudwatch-logs.tf
│   ├── 14-outputs.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── terraform.tfvars
└── terraform.tfstate

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

Build and Push Docker Images
```
docker build -t aws-quote-backend ./backend
docker build -t aws-quote-frontend ./frontend

aws ecr create-repository --repository-name aws-quote-backend
aws ecr create-repository --repository-name aws-quote-frontend

docker tag aws-quote-backend:latest <account>.dkr.ecr.<region>.amazonaws.com/aws-quote-backend:latest
docker tag aws-quote-frontend:latest <account>.dkr.ecr.<region>.amazonaws.com/aws-quote-frontend:latest

docker push <ecr-backend-url>
docker push <ecr-frontend-url>
```

healthcheck commands
```
# get vpc ID
aws ec2 describe-vpcs --region eu-west-1 --query "Vpcs[*].VpcId" --output text

aws ec2 describe-internet-gateways \
  --query "InternetGateways[?Attachments[?VpcId=='vpc-0ec0b4e455023b995']]" \
  --region eu-west-1


# Example: Get backend public IP
aws ecs list-tasks \
  --cluster ecs-test-deplyment-cluster \
  --service-name quote-backend-service \
  --desired-status RUNNING \
  --region eu-west-1

# Then plug task ARN into:
aws ecs describe-tasks \
  --cluster ecs-test-deplyment-cluster \
  --tasks arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/a1acb84803df481e95e00ef94730b55e \
  --region eu-west-1 \
  --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" \
  --output text

# Then use networkInterfaceId to get IP:
aws ec2 describe-network-interfaces \
  --network-interface-ids eni-08cae240819469f94 \
  --region eu-west-1 \
  --query "NetworkInterfaces[0].Association.PublicIp" \
  --output text


# Example: Get backend public IP
aws ecs list-tasks \
  --cluster ecs-test-deplyment-cluster \
  --service-name quote-backend-service \
  --desired-status RUNNING \
  --region eu-west-1

# Then plug task ARN into:
aws ecs describe-tasks \
  --cluster ecs-test-deplyment-cluster \
  --tasks <task-arn> \
  --region eu-west-1 \
  --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" \
  --output text

# Then use networkInterfaceId to get IP:
aws ec2 describe-network-interfaces \
  --network-interface-ids <eni-id> \
  --region eu-west-1 \
  --query "NetworkInterfaces[0].Association.PublicIp" \
  --output text

aws logs get-log-events \
  --log-group-name /ecs/quote-backend \
  --log-stream-name <stream-name> \
  --region eu-west-1

aws ecs describe-services \
  --cluster ecs-test-deplyment-cluster \
  --services quote-backend-service \
  --region eu-west-1 \
  --query "services[0].deployments[0].rolloutState"

```

ignor all this