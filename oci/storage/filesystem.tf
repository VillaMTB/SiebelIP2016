
data "oci_file_storage_export_sets" "ociVillaMTBCorpExportSet" {
  #Required
  availability_domain = var.oci_availability_domain
  compartment_id      = var.org_compartment_ocid

  #Optional
  display_name = "Corpdata Export Set"
}
data "oci_file_storage_mount_targets" "ociVillaMTBCorpMT" {
  #Required
  availability_domain = var.oci_availability_domain
  compartment_id      = var.org_compartment_ocid

  #Optional
  display_name  = "corpdata"
  export_set_id = data.oci_file_storage_export_sets.ociVillaMTBCorpExportSet.export_sets[0].id
}
resource "oci_file_storage_file_system" "ociVillaMTBSiebelDevFS" {
  #Required
  availability_domain = var.oci_availability_domain
  compartment_id      = var.org_compartment_ocid

  #Optional
  display_name = "siebfiledev"
}
resource "oci_file_storage_export" "siebfiledev_export" {
  #Required
  export_set_id  = data.oci_file_storage_export_sets.ociVillaMTBCorpExportSet.export_sets[0].id
  file_system_id = oci_file_storage_file_system.ociVillaMTBSiebelDevFS.id
  path           = "/siebfiledev"
}