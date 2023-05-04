resource "google_storage_bucket_object" "function_sources_zip" {
  name   = var.object_name
  bucket = var.bucket_name
  source = var.object_source
}