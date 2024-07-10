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

### If using Secrets

The values of WORKLOAD_IDENTITY_PROVIDER and SERVICE_ACCOUNT_EMAIL will be the last two lines after running the script.
