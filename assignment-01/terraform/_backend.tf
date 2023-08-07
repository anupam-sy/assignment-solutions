/*
1. Create the GCS Bucket using Cloud SDK / Cloud Shell.
> gcloud auth login
> gcloud config set project PROJECT_ID
> gsutil mb -p PROJECT_ID -l us-central1 -c standard gs://dev-bkt-tfstate

2. Set the Bucket versioning.
> gsutil versioning set on gs://dev-bkt-tfstate
*/

// Configure Google Cloud Storage (GCS) Backend
terraform {
  backend "gcs" {
    bucket = "dev-bkt-tfstate"
    prefix = "terraform/dev/state"
  }
}
