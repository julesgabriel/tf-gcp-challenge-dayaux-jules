provider "google" {
  credentials = file("${path.module}/gcpCredentials/student-iim-jules-cc75b76f624e.json")
  project     = "student-iim-jules"
  region      = "europe-west1"
}


resource "google_storage_bucket_object" "function_zip" {
  name   = "function-bucket.zip"
  bucket = "function-bucket-jules-iim"
  source = "${path.module}/julesiimFunction-v2.zip"
}


resource "google_cloudfunctions_function" "julesiimFunction" {
  name         = "julesiim-function"
  runtime      = "nodejs14"
  trigger_http = true

  source_archive_bucket = "${google_storage_bucket_object.function_zip.bucket}"
  source_archive_object = "${google_storage_bucket_object.function_zip.name}"

  available_memory_mb = 256
  timeout             = 10
  entry_point         = "helloGCS"
}

resource "google_sql_database_instance" "julesiim-db" {
  name             = "julesiim-db"
  database_version = "MYSQL_5_7"
  region           = "europe-west1"
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "julesiim-db-user" {
  name     = "julesiim-db-user"
  password = "password"
  instance = google_sql_database_instance.julesiim-db.name
}

resource "google_sql_database" "julesiim-db-name" {
  name     = "julesiim-db-name"
  instance = google_sql_database_instance.julesiim-db.name
}