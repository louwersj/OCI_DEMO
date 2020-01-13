variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "region" {}
variable "private_key_path" {}
variable "private_key_password" {}



provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  region = "${var.region}"
  private_key_path = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
}
