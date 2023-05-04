#Exemple Readme:

# terraform-init-gcp

## Description

To create the terraform backend in GCP

- `terraform init`
- `terraform plan` (optional)
- `terraform apply`

## Requirements

- You need to create a CGP account
- You need to create a service account and generate a key file from the service account like so in IAM > service account > keys > create key > json
- Drag and drop the key in a folder called `gcpCredentials` in the root of the project
- Remember to change the value of the `credentials_json_name` variable in the `variables.tf` file in the root of the project