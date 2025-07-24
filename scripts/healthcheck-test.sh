#!/bin/bash
set -e

CLUSTER="ecs-test-deplyment-cluster"
REGION="eu-west-1"

check_service() {
  SERVICE=$1
  echo "🔎 Checking $SERVICE..."

  TASK_ARN=$(aws ecs list-tasks \
    --cluster "$CLUSTER" \
    --service-name "$SERVICE" \
    --region "$REGION" \
    --query 'taskArns[0]' \
    --output text)

  if [[ -z "$TASK_ARN" || "$TASK_ARN" == "None" ]]; then
    echo "❌ No task found for $SERVICE"
    return
  fi

  ENI_ID=$(aws ecs describe-tasks \
    --cluster "$CLUSTER" \
    --tasks "$TASK_ARN" \
    --region "$REGION" \
    --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' \
    --output text)

  PUBLIC_IP=$(aws ec2 describe-network-interfaces \
    --network-interface-ids "$ENI_ID" \
    --region "$REGION" \
    --query 'NetworkInterfaces[0].Association.PublicIp' \
    --output text)

  echo "Public IP: $PUBLIC_IP"
  echo "curl http://$PUBLIC_IP"
  curl -s http://$PUBLIC_IP || echo "❌ Curl failed"
}

check_service quote-frontend-service
check_service quote-backend-service



# check if the front end is working... if you get arn then its all good
aws ecs list-tasks \
  --cluster ecs-test-deplyment-cluster \
  --service-name quote-frontend-service \
  --desired-status RUNNING \
  --region eu-west-1

aws ecs describe-tasks \
  --cluster ecs-test-deplyment-cluster \
  --tasks arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/ff07cd181c914774b8b53152b70d4ee8 \
  --region eu-west-1 \
  --query 'tasks[0].containers[0].lastStatus'
echo ""
aws ecs describe-tasks \
  --cluster ecs-test-deplyment-cluster \
  --tasks arn:aws:ecs:eu-west-1:040929397520:task/ecs-test-deplyment-cluster/ff07cd181c914774b8b53152b70d4ee8 \
  --region eu-west-1 \
  --query 'tasks[0].stoppedReason'
