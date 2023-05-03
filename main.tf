provider "google" {
  credentials = file("${path.module}/gcpCredentials/student-iim-jules-cc75b76f624e.json")
  project     = "student-iim-jules"
  region      = "europe-west1"
}

resource "google_storage_bucket" "function_sources_bucket" {
  name     = "function-sources-jules-iim"
  location = "europe-west1"
}

resource "google_cloudfunctions_function" "julesiimFunction" {
  name         = "julesiim-function"
  runtime      = "nodejs14"
  trigger_http = true

  source_archive_bucket = google_storage_bucket.function_sources_bucket.name
  source_archive_object = "julesiimFunction-v2.zip"

  available_memory_mb = 256
  timeout             = 10
  entry_point         = "helloGCS"
}

resource "google_storage_bucket_object" "function_sources_zip" {
  name   = "julesiimFunction-v2.zip"
  bucket = google_storage_bucket.function_sources_bucket.name
  source = "${path.module}/julesiimFunction-v2.zip"
}

