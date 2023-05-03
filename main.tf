provider "google" {
  credentials = file("${path.module}/student-iim-jules-beac65455c26.json")
  project     = "student-iim-jules"
  region      = "europe-west1"
}


resource "google_storage_bucket_object" "function_zip" {
  name   = "function-bucket.zip"
  bucket = "function-bucket-jules-iim"
  source = "${path.module}/julesiimFunction-v2.zip"
}


resource "google_cloudfunctions_function" "julesiimFunction" {
  name    = "julesiim-function"
  runtime = "nodejs14"
  trigger_http = true

  source_archive_bucket = "${google_storage_bucket_object.function_zip.bucket}"
  source_archive_object = "${google_storage_bucket_object.function_zip.name}"

  available_memory_mb = 256
  timeout             = 10
  entry_point = "helloGCS"
}


