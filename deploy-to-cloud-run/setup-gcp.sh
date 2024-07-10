#!/bin/bash

# Assumes PROJECT_NAME & REPO env vars are set
if [[ -z "$PROJECT_NAME"]]; then
echo "The environment variable 'PROJECT_NAME' must be set." && exit
fi

PROJECT_ID=`gcloud config get-value core/project`
SERVICE_ACCOUNT_NAME=${PROJECT_NAME}-sa

# Add artifact registry role to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.admin"
# Add serviceAccountUser role to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"
