provider "google" {
  credentials = file("${path.module}/gcpCredentials/student-iim-jules-cc75b76f624e.json")
  project     = var.project
  region      = var.region
}

resource "google_storage_bucket" "function_sources_bucket" {
  name     = "function-sources-jules-iim"
  location = var.region
}

resource "google_storage_bucket_object" "function_sources_zip" {
  name   = "${var.function}.zip"
  bucket = google_storage_bucket.function_sources_bucket.name
  source = "${path.module}/${var.function}.zip"
}

resource "google_cloudfunctions_function" "julesiimFunction" {
  name         = var.function
  runtime      = var.nodejs
  trigger_http = true

  source_archive_bucket = google_storage_bucket.function_sources_bucket.name
  source_archive_object = "${var.function}.zip"

  available_memory_mb = 256
  timeout             = 10
  entry_point         = "helloGCS"
  depends_on = [google_storage_bucket_object.function_sources_zip]
}

resource "google_bigquery_dataset" "my_dataset" {
  dataset_id        = "mydataset"
  friendly_name     = "My Dataset"
  description       = "This is my BigQuery dataset"
  location          = "EU"
  default_table_expiration_ms = "3600000"
}

resource "google_bigquery_table" "test_table" {
  dataset_id = "mydataset"
  table_id   = "my_table"

  schema = jsonencode([
    {
      name = "name"
      type = "STRING"
    },
    {
      name = "amount"
      type = "INTEGER"
    }
  ])
}





