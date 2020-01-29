# Define the generic variables used in the .tf file. 
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "region" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "compartment_ocid" {}
variable "source_version" {}
variable "dns_label" {}


# Define the OCI provider.
provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  region = "${var.region}"
  private_key_path = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
}


# Create the OCI compartment for the deployment. This compartment will be 
# placed under a root compartment (not per definition the tenancy root.
resource "oci_identity_compartment" "deployment_compartment" {
    compartment_id = "${var.compartment_ocid}"
    description = "Automatic test compartment for build: ${var.source_version}"
    name = "build_${var.source_version}"
    freeform_tags =  {
           application_environment = "test"
           application_name = "OCI_DEMO"
           git_build = "${var.source_version}"
           git_branch = "master"
           deploy_region = "${var.region}"
   }
}


# Create the virtual cloud network for the deployment. This compartment will 
# be associated with the newly created "deployment_compartment"
#
# TODO : we have to find a way to find a free CIDR block as multiple build
#        could be active (deployed) at the same time. We need a dynamic way
# .      of deciding which CIDR block could be used.
resource "oci_core_vcn" "deployment_vcn" {
  cidr_block     = "10.1.1.0/24"
  #dns_label      = "${var.source_version}"
  dns_label      = "${var.dns_label}"
  compartment_id = "${oci_identity_compartment.deployment_compartment.id}"
  display_name   = "build_${var.source_version}"
  freeform_tags =  {
         application_environment = "test"
         application_name = "OCI_DEMO"
         git_build = "${var.source_version}"
         git_branch = "master"
   }
}


# Create an internet gateway for the deployment. This internet gateway will 
# be associated with the newly created "deployment_compartment" and the newly
# created VCN "deployment_vcn"
resource "oci_core_internet_gateway" "deployment_internet_gateway" {
  compartment_id = "${oci_identity_compartment.deployment_compartment.id}"
  display_name   = "build_${var.source_version}"
  vcn_id         = "${oci_core_vcn.deployment_vcn.id}"
  freeform_tags =  {
         application_environment = "test"
         application_name = "OCI_DEMO"
         git_build = "${var.source_version}"
         git_branch = "master"
   }
}


# Create a core route table. Do note that you can have multiple route tables.
# this defaultroute table will route to the deployment_internet_gateway.
#
# TODO : check on manage_default_resource_id = "${oci_core_vcn.vcn1.default_route_table_id}"
resource "oci_core_route_table" "core_route_table" {
  compartment_id = "${oci_identity_compartment.deployment_compartment.id}"
  vcn_id         = "${oci_core_vcn.deployment_vcn.id}"  
  display_name   = "defaultRT_${var.source_version}"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.deployment_internet_gateway.id}"
  }
  freeform_tags =  {
         application_environment = "test"
         application_name = "OCI_DEMO"
         git_build = "${var.source_version}"
         git_branch = "master"
   }
}


resource "oci_core_subnet" "core_subnet" {
    cidr_block = "10.1.20.0/24"
    compartment_id = "${oci_identity_compartment.deployment_compartment.id}"
    vcn_id = "${oci_core_vcn.deployment_vcn.id}"
    display_name   = "defaultSubNet_${var.source_version}"
    route_table_id = "${oci_core_route_table.core_route_table.id}"
  }


