#!/bin/bash

set -e

REGION="eu-west-1"
CLUSTER_NAME="ecs-test-deplyment-cluster"
SERVICE_NAME="quote-backend-service"
PORT=8080

echo "🔍 Fetching backend task..."
TASK_ARN=$(aws ecs list-tasks \
  --cluster "$CLUSTER_NAME" \
  --service-name "$SERVICE_NAME" \
  --desired-status RUNNING \
  --region "$REGION" \
  --query "taskArns[0]" \
  --output text)

if [[ "$TASK_ARN" == "None" ]]; then
  echo "❌ No running backend tasks found."
  exit 1
fi

echo "✅ Task: $TASK_ARN"

echo "🔍 Getting ENI for backend task..."
ENI_ID=$(aws ecs describe-tasks \
  --cluster "$CLUSTER_NAME" \
  --tasks "$TASK_ARN" \
  --region "$REGION" \
  --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" \
  --output text)

echo "✅ ENI: $ENI_ID"

echo "🌐 Getting public IP..."
BACKEND_IP=$(aws ec2 describe-network-interfaces \
  --network-interface-ids "$ENI_ID" \
  --query "NetworkInterfaces[0].Association.PublicIp" \
  --output text \
  --region "$REGION")

echo "🔗 Backend IP: $BACKEND_IP"

echo "🚀 Testing backend quote API..."
RESPONSE=$(curl -s --max-time 5 "http://$BACKEND_IP:$PORT/")
echo @@

if echo "$RESPONSE" | jq -e '.quote' > /dev/null 2>&1; then
  echo "✅ Backend is healthy!"
  echo "📜 Quote: $(echo "$RESPONSE" | jq -r .quote)"
else
  echo "❌ Backend response invalid:"
  echo "$RESPONSE"
  exit 1
fi


echo ""
echo ""

#!/bin/bash

set -e

REGION="eu-west-1"
CLUSTER_NAME="ecs-test-deplyment-cluster"
SERVICE_NAME="quote-frontend-service"
PORT=80

echo "🔍 Fetching frontend task..."
TASK_ARN=$(aws ecs list-tasks \
  --cluster "$CLUSTER_NAME" \
  --service-name "$SERVICE_NAME" \
  --desired-status RUNNING \
  --region "$REGION" \
  --query "taskArns[0]" \
  --output text)

if [[ "$TASK_ARN" == "None" ]]; then
  echo "❌ No running frontend tasks found."
  exit 1
fi

echo "✅ Task: $TASK_ARN"

echo "🔍 Getting ENI for frontend task..."
ENI_ID=$(aws ecs describe-tasks \
  --cluster "$CLUSTER_NAME" \
  --tasks "$TASK_ARN" \
  --region "$REGION" \
  --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" \
  --output text)

echo "✅ ENI: $ENI_ID"

echo "🌐 Getting public IP..."
FRONTEND_IP=$(aws ec2 describe-network-interfaces \
  --network-interface-ids "$ENI_ID" \
  --query "NetworkInterfaces[0].Association.PublicIp" \
  --output text \
  --region "$REGION")

echo "🔗 Frontend IP: $FRONTEND_IP"

echo "🚀 Testing frontend HTML homepage..."
HTML_CHECK=$(curl -s --max-time 5 "http://$FRONTEND_IP/")
if [[ -n "$HTML_CHECK" && "$HTML_CHECK" == *"<html"* ]]; then
  echo "✅ Frontend is serving the homepage!"
else
  echo "❌ Frontend homepage did not return expected HTML content."
  echo "$HTML_CHECK"
  exit 1
fi

echo "🚀 Testing frontend /quote endpoint..."
RESPONSE=$(curl -s --max-time 5 "http://$FRONTEND_IP/quote")
if echo "$RESPONSE" | jq -e '.quote' > /dev/null 2>&1; then
  echo "✅ Frontend is proxying to backend!"
  echo "📜 Quote: $(echo "$RESPONSE" | jq -r .quote)"
else
  echo "❌ Frontend /quote failed or invalid response:"
  echo "$RESPONSE"
  exit 1
fi


CLUSTER_NAME="ecs-test-deplyment-cluster"

# Get Task ARNs
TASK_ARNS=$(aws ecs list-tasks --cluster $CLUSTER_NAME --query "taskArns[]" --output text)

echo "🔍 Finding public IPs for tasks in ECS cluster: $CLUSTER_NAME"
echo

for TASK_ARN in $TASK_ARNS; do
  # Get the ENI ID from the task description
  ENI_ID=$(aws ecs describe-tasks \
    --cluster $CLUSTER_NAME \
    --tasks "$TASK_ARN" \
    --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" \
    --output text)

  # Get the public IP from the ENI
  PUBLIC_IP=$(aws ec2 describe-network-interfaces \
    --network-interface-ids "$ENI_ID" \
    --query "NetworkInterfaces[0].Association.PublicIp" \
    --output text)

  # Get task name (e.g., quote-backend or quote-frontend)
  TASK_NAME=$(echo "$TASK_ARN" | cut -d'/' -f3)

  echo "🎯 Task: $TASK_NAME"
  echo "🔌 ENI : $ENI_ID"
  echo "🌐 Public IP: $PUBLIC_IP"
  echo "-----------------------------"
done

