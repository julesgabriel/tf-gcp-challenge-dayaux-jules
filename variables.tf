variable "region" {
  type    = string
  default = "europe-west1"
}

variable "project" {
  type    = string
  default = "student-iim-jules"
}

variable "nodejs" {
  type    = string
  default = "nodejs14"
}

variable "function" {
  type    = string
  default = "julesIIMFunction"
}

variable "bucket_name" {
  type = string
  default = "function-sources-jules-iim"
}

variable "credentials_json_name" {
  type= string
  default = "student-iim-jules-cc75b76f624e"
}