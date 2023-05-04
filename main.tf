provider "google" {
  # The path to your credentials from the service account
  credentials = file("${path.module}/gcpCredentials/student-iim-jules-cc75b76f624e.json")
  # the project name you gave
  project     = var.project
  # currently europe-west1
  region      = var.region
}

resource "google_storage_bucket" "function_sources_bucket" {
  # The name of the bucket
  name     = var.bucket_name
  # currently europe-west1
  location = var.region
}

module "function_sources_zip" {
  # the path to the resource to base on
  source = "./google_storage_bucket_object"
  # the name of the zip interpolated from the variable and concatenated with .zip
  object_name   = "${var.function}.zip"
    # the name of the bucket to point on
  bucket_name = google_storage_bucket.function_sources_bucket.name
    # the path to the zip file
  object_source = "${path.module}/${var.function}.zip"
}

resource "google_cloudfunctions_function" "julesiimFunction" {
  # the name of the function
  name         = var.function
  # the nodejs runtime version
  runtime      = var.nodejs
  trigger_http = true
    # the name of the bucket
  source_archive_bucket = google_storage_bucket.function_sources_bucket.name
    # the name of the zip file
  source_archive_object = "${var.function}.zip"

  available_memory_mb = 256
  timeout             = 10
  # the name of the function to call
  entry_point         = "helloGCS"
    # the name of the bucket to depends on
  depends_on = [module.function_sources_zip]
}

resource "google_bigquery_dataset" "my_dataset" {
  # the name of the dataset
  dataset_id        = "mydataset"
  friendly_name     = "My Dataset"
  description       = "This is my BigQuery dataset"
  location          = "EU"
  default_table_expiration_ms = "3600000"
}

module "bigquery_table" {
  # the path to the resource to base on
  source    = "./google_bigquery_table"
  dataset_id = "mydataset"
  table_id   = "my_table"
  depends_on = [google_bigquery_dataset.my_dataset]

  schema = [
    {
      name = "name"
      type = "STRING"
    },
    {
      name = "amount"
      type = "INTEGER"
    }
  ]
}






