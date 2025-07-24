#!/bin/bash

set -e

CLUSTER_NAME="ecs-test-deplyment-ecs-cluster"
BACKEND_PORT=8080
FRONTEND_PORT=80

get_public_ip() {
  local SERVICE=$1
  local TASK_ARN=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE --query 'taskArns[0]' --output text)
  local ENI_ID=$(aws ecs describe-tasks --cluster $CLUSTER_NAME --tasks $TASK_ARN \
      --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" --output text)
  local PUBLIC_IP=$(aws ec2 describe-network-interfaces --network-interface-ids $ENI_ID \
      --query "NetworkInterfaces[0].Association.PublicIp" --output text)
  echo "$PUBLIC_IP"
}

echo "🔎 Checking service deployment status..."
aws ecs describe-services --cluster $CLUSTER_NAME --services quote-backend-service \
    --query "services[*].deployments[*].{status:status, running:runningCount, pending:pendingCount}" --output table

aws ecs describe-services --cluster $CLUSTER_NAME --services quote-frontend-service \
    --query "services[*].deployments[*].{status:status, running:runningCount, pending:pendingCount}" --output table

echo "🌐 Resolving backend public IP..."
BACKEND_IP=$(get_public_ip quote-backend-service)
echo "Backend IP: $BACKEND_IP"
sleep 5
curl --fail http://$BACKEND_IP:$BACKEND_PORT && echo "✅ Backend is healthy" || echo "❌ Backend check failed"

echo "🌐 Resolving frontend public IP..."
FRONTEND_IP=$(get_public_ip quote-frontend-service)
echo "Frontend IP: $FRONTEND_IP"
sleep 5
curl --fail http://$FRONTEND_IP:$FRONTEND_PORT && echo "✅ Frontend is healthy" || echo "❌ Frontend check failed"
