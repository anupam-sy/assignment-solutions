# Three Tier Environment - Sample Code
This repository contains terraform code for infrastructure deployment of Three Tier Sample Environment on Google Cloud Platform. Below mentioned resources will be deployed post successful execution of Terraform Code available in this repository.

1. VPC, Subnet, Firewall
2. Cloud NAT, Cloud Router
3. Private Service Connection
4. Instance Template and MIG
5. Service Account and Permissions
6. Application Load balancer (https)
7. Cloud SQL with MySQL engine and a Database

## Prerequisites
Below prerequisites must be fulfilled for successful execution of terraform concept code sets.

### Software Requirement
Resources in this repository are meant to use with Terraform 1.4.0 (check the terraform version using: `terraform version`). If you don't have the compatible version, download it from official Terraform repository.

-   [Cloud SDK](https://cloud.google.com/sdk/install) >= 414.0.0
-   [Terraform](https://www.terraform.io/downloads.html) >= 1.4.0

> **Note:** 
> See [Installation-Guide](https://gist.github.com/anupam-sy/7458df6506e8e3cfb28c0ff56fab546a) on how to install Terraform.

### Permissions Requirement (Authentication and Authorization)
#### Authentication
There are multiple authentication options available. But, for this terraform code, we are leveraging the authentication to google cloud platform using User Application Default Credentials ("ADCs"). You can enable ADCs by running the command.

```
    gcloud auth application-default login
```

#### Authorization
Make sure to provide the following roles to selected principle (User/ServiceAccount).
- `roles/resourcemanager.projectOwner` on all the projects where you want to house your resources using service account's email.
- `roles/storage.admin` on the GCS bucket housing terraform state files. This role is required in case of using GCS backend.

**Note:** Access can be more fine-grained to follow the principle of least privilege (PoLP).

### Remote Backend Setup
To use a remote backend, create a google cloud storage bucket in a GCP project and enable the versioning. Use below gcloud commands to created and set up gcs backend bucket.

```
    gcloud config set project PROJECT_ID
    gsutil mb -c standard -l eu gs://bucket-name
    gsutil versioning set on gs://bucket-name
```

## Assumptions
For this terraform code, It is assumed that, basic landing zone is already setup which includes Cloud Identity, Resource hierarchy, IAM etc. In order to use the google cloud services in a GCP Project, respective service API(s) must be enabled before resource deployment.

## TF Code Execution
To execute the Terraform code, follow the below steps:

- **Step-01:** Clone this repository: `git clone https://github.com/anupam-sy/assignment-solutions.git`
- **Step-02:** Navigate to the directory `assignment-01/terraform`
- **Step-03:** Execute the below mentioned terraform CLI commands.

-   [Required] `terraform init` # To initialize the terraform working directory.
-   [Optional] `terraform validate` # To validate the terraform configuration.
-   [Optional] `terraform fmt` # To format the terraform configuration to a canonical format and style.
-   [Optional] `terraform plan` # To create an execution plan for terraform configuration files.
-   [Required] `terraform apply -auto-approve` # To execute the actions proposed in a terraform plan to create, update, or destroy infrastructure.
-   [Optional] `terraform destroy -auto-approve` # To destroy the created infrastructure. Specific resources can be destroyed using resource targetting.
