# workload-identity-federation-for-github-actions

See [Setup Workload Identity Federation for GitHub Actions](https://www.notion.so/enspyr-resources/Setup-Workload-Identity-Federation-for-GitHub-Actions-dea8dc31ff704efda562376047e7a965)

## Make sure the relevant project is set

Check the current project

```sh
gcloud config get-value project
```

If neccessary, check the list of projects and set the project using the project id

```sh
gcloud projects list
gcloud config set project <PROJECT_ID>
```

## Set Environment Variables

```sh
export PROJECT_NAME=<your-project-name>
export REPO=<your-github-org-or-username>/<your-github-repo-name>
```

## Run Script

```sh
./setup-gcp.sh
```

## Create Secrets

WORKLOAD_IDENTITY_PROVIDER:

```sh
echo projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${WORKLOAD_IDENTITY_POOL}/providers/${WORKLOAD_PROVIDER}
```

SERVICE_ACCOUNT_EMAIL:

```sh
echo ${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```

## Deploy a revision to Cloud Run

export ARTIFACT_LOCATION=us-central1
export ARTIFACT_IMAGE=
export ARTIFACT_REPO=
export IMAGE_URL="${ARTIFACT_LOCATION}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACT_REPO}/{ARTIFACT_IMAGE}:latest”

## Create a new release to initiate GitHub Actions workflow

- From the GitHub repository page, click on "Releases"
- Click on "Draft a new release"
- Under "Choose a tag", create a new tag
- Click "Publish release"

## Troubleshooting - analyzing the Cloud Audit Logs

In the cloud console go to IAM and Admin > Audit Logs and enable IAM and STS Data Access Logs to detect any IAM violations and observe how token exchange works between GitHub and STS API.

The `auth` action uses the STS API to retrieve a short lived
federated access token. This token exchange may fail due to
attribute condition mismatch or configuration error.

The `auth` action uses the IAM Credentials API to obtain a short-lived credential for a service account. Failure may occur due to either the absence of the workloadIdentityUser IAM role or the incorrect principal attempting to create the token.

Further details can be found at [Secure your use of third party tools with identity federation > 6. Analyzing the Cloud Audit Logs | Google Cloud Blog](https://cloud.google.com/blog/products/identity-security/secure-your-use-of-third-party-tools-with-identity-federation)
