data "oci_core_images" "oel8latest" {
  # Required
  compartment_id = var.org_compartment_ocid
  #Optional
  display_name = "Oracle-Linux-8.7-2023.04.25-0"
}

resource "oci_core_instance" "ociVillaMTBDevDBVM" {
  availability_domain = var.oci_availability_domain
  compartment_id      = var.org_compartment_ocid
  display_name        = "devoradb.${lower(var.organization_name)}.com"
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
    hostname_label            = "devoradb"
  }
  source_details {
    source_id   = data.oci_core_images.oel8latest.images[0].id
    source_type = "image"
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}
