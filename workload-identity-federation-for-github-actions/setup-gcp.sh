#!/bin/bash

# Assumes PROJECT_NAME & REPO env vars are set
if [[ -z "$PROJECT_NAME" || -z "$REPO" ]]; then
echo "The environment variables 'PROJECT_NAME' and 'REPO' must be set." && exit
fi

PROJECT_ID=`gcloud config get-value core/project`
WORKLOAD_IDENTITY_POOL=${PROJECT_NAME}-ip
SERVICE_ACCOUNT_NAME=${PROJECT_NAME}-sa
WORKLOAD_PROVIDER=${PROJECT_NAME}-oidc

# Enable the IAM Service Account Credentials API
gcloud services enable iamcredentials.googleapis.com  \
    --project "${PROJECT_ID}"
# Create a service account for the GitHub Actions identity to impersonate
gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}" \
    --project "${PROJECT_ID}"
# Add artifact registry role to service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.admin"
# Create a Workload Identity Pool
gcloud iam workload-identity-pools create "${WORKLOAD_IDENTITY_POOL}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --display-name="Workload Identity Pool"
# Print the full ID of the Workload Identity Pool
WORKLOAD_IDENTITY_POOL_ID=`gcloud iam workload-identity-pools describe "${WORKLOAD_IDENTITY_POOL}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --format="value(name)"` && export WORKLOAD_IDENTITY_POOL_ID
# Create a Workload Identity Provider in the pool
gcloud iam workload-identity-pools providers create-oidc "${WORKLOAD_PROVIDER}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${WORKLOAD_IDENTITY_POOL}" \
  --display-name="Workload Identity Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"
# Allow authentications from the Workload Identity Provider (GitHub Actions) to impersonate the service account
gcloud iam service-accounts add-iam-policy-binding "${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"
# Show the value of WORKLOAD_IDENTITY_PROVIDER for adding as an Actions secret
gcloud iam workload-identity-pools providers describe "${WORKLOAD_PROVIDER}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${WORKLOAD_IDENTITY_POOL}" \
  --format="value(name)"
# Show the value of SERVICE_ACCOUNT_EMAIL for adding as an Actions secret
echo ${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com