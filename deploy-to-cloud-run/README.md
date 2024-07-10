# deploy-to-cloud-run

See [Build container image & deploy to Cloud Run in CI](https://www.notion.so/enspyr-resources/Build-container-image-deploy-to-Cloud-Run-in-CI-e99e4144cdf1460aad41a56aa5f45099)

## Deploy a revision to Cloud Run

export ARTIFACT_LOCATION=us-central1
export ARTIFACT_IMAGE=
export ARTIFACT_REPO=
export IMAGE_URL="${ARTIFACT_LOCATION}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACT_REPO}/{ARTIFACT_IMAGE}:latest”
