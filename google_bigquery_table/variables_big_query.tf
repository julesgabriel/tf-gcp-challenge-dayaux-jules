variable "dataset_id" {
  type = string
}

variable "table_id" {
  type = string
}

variable "schema" {
  type = list(object({
    name = string
    type = string
  }))
}
