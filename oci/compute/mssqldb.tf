data "oci_core_images" "win2016latest" {
  # Required
  compartment_id = var.org_compartment_ocid
  #Optional
  display_name = "Windows-Server-2016-Standard-Edition-VM-2023.05.24-0"
}
resource "oci_core_instance" "ociVillaMTBDevMSSQLDBVM" {
  availability_domain = var.oci_availability_domain
  compartment_id      = var.org_compartment_ocid
  display_name        = "devmssqldb.${lower(var.organization_name)}.com"
  // is_pv_encryption_in_transit_enabled = true
  shape = "VM.Standard.E4.Flex"
  shape_config {
    memory_in_gbs = 8
    ocpus         = 1
  }
  create_vnic_details {
    subnet_id                 = var.oci_db_subnet_id
    assign_private_dns_record = true
    assign_public_ip          = false
    hostname_label            = "devmssqldb"
  }
  source_details {
    source_id   = data.oci_core_images.win2016latest.images[0].id
    source_type = "image"
  }
}
resource "oci_core_volume" "devmssqldbu01_volume" {
  #Required
  compartment_id      = var.org_compartment_ocid
  availability_domain = var.oci_availability_domain

  #Optional
  display_name = join("-", [var.organization_name, "Dev", "MSSQLDB", "Apps"])
  size_in_gbs  = 50
}
resource "oci_core_volume_attachment" "devmssqldbu01_volume_attachment" {
  #Required
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.ociVillaMTBDevMSSQLDBVM.id
  volume_id       = oci_core_volume.devmssqldbu01_volume.id
}