resource "oci_core_volume" "devdbu01_volume" {
  #Required
  compartment_id      = var.org_compartment_ocid
  availability_domain = var.oci_availability_domain

  #Optional
  display_name = join("-", [var.organization_name, "Dev", "DB", "U01"])
  size_in_gbs  = 100
}
resource "oci_core_volume_attachment" "devdbu01_volume_attachment" {
  #Required
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.ociVillaMTBDevDBVM.id
  volume_id       = oci_core_volume.devdbu01_volume.id

  #Optional
  device = "/dev/oracleoci/oraclevdb"

}
resource "oci_objectstorage_bucket" "dbbackups_bucket" {
  #Required
  compartment_id = var.org_compartment_ocid
  name           = "db_backups"
  namespace      = var.tenancy_namespace

  #Optional
  auto_tiering = "InfrequentAccess"
}