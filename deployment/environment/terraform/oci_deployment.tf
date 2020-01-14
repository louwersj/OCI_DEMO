variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "region" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "compartment_ocid" {}
variable "source_version" {}




provider "oci" {
  tenancy_ocid = "$var.tenancy_ocid"
  user_ocid = "$var.user_ocid"
  fingerprint = "$var.fingerprint"
  region = "$var.region"
  private_key_path = "$var.private_key_path"
  private_key_password = "$var.private_key_password"
}

resource "oci_identity_compartment" "deployment_root_compartment" {
    compartment_id = "${var.compartment_ocid}"
    description = "Automatic test compartment for commit: ${var.source_version}"
    name = "auto_test_${var.source_version}"
    freeform_tags =  {
           environment = "test"
           build = "${var.source_version}"
           application = "OCI_DEMO"
   }
}
