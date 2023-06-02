resource "oci_objectstorage_bucket" "dbbackups_bucket" {
  #Required
  compartment_id = var.org_compartment_ocid
  name           = "db_backups"
  namespace      = var.tenancy_namespace

  #Optional
  auto_tiering = "InfrequentAccess"
}
