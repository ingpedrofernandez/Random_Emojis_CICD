#!/bin/bash

# Script to fix aborted Elastic Beanstalk deployment
# This script redeploys the latest application version to ensure all instances are synchronized

echo "Checking Elastic Beanstalk environment status..."
ENV_STATUS=$(aws elasticbeanstalk describe-environments \
  --environment-names Emoji-tester-env \
  --region us-east-1 \
  --query 'Environments[0].Status' \
  --output text)

echo "Current environment status: $ENV_STATUS"

# Get the latest application version
LATEST_VERSION=$(aws elasticbeanstalk describe-application-versions \
  --application-name emoji-tester \
  --region us-east-1 \
  --max-records 1 \
  --query 'ApplicationVersions[0].VersionLabel' \
  --output text)

echo "Latest application version: $LATEST_VERSION"

# Redeploy the latest version
echo "Redeploying version $LATEST_VERSION to fix inconsistent state..."
aws elasticbeanstalk update-environment \
  --environment-name Emoji-tester-env \
  --version-label "$LATEST_VERSION" \
  --region us-east-1

echo "Deployment initiated. Check AWS Console for progress."
echo "You can monitor with: aws elasticbeanstalk describe-events --environment-name Emoji-tester-env --region us-east-1 --max-items 10"

