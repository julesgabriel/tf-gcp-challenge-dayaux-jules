resource "google_bigquery_table" "test_table" {
  dataset_id = var.dataset_id
  table_id   = var.table_id
  schema = jsonencode(var.schema)
}
