
#######################################################################################################
#	SiebAppSQL
#######################################################################################################
resource "oci_core_instance" "ociVillaMTBSiebAppSQL" {
  availability_domain = var.oci_availability_domain
  compartment_id      = var.org_compartment_ocid
  display_name        = "siebappsql.${lower(var.organization_name)}.com"
  // is_pv_encryption_in_transit_enabled = true
  shape = "VM.Standard.E4.Flex"
  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = false
    plugins_config {
      desired_state = "DISABLED"
      name          = "Custom Logs Monitoring"
    }
  }
  shape_config {
    memory_in_gbs = 8
    ocpus         = 1
  }
  create_vnic_details {
    hostname_label            = "siebappsql"
    subnet_id                 = var.oci_app_subnet_id
    assign_private_dns_record = true
    assign_public_ip          = false
  }
  source_details {
    source_id   = data.oci_core_images.win2016latest.images[0].id
    source_type = "image"
  }

}
resource "oci_core_volume" "siebappsqlapps_volume" {
  #Required
  compartment_id      = var.org_compartment_ocid
  availability_domain = var.oci_availability_domain

  #Optional
  display_name = join("-", [var.organization_name, "Dev", "SiebAppSQL", "Apps"])
  size_in_gbs  = 100
}
resource "oci_core_volume_attachment" "siebappsqlapps_volume_attachment" {
  #Required
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.ociVillaMTBSiebAppSQL.id
  volume_id       = oci_core_volume.siebappsqlapps_volume.id
}

#######################################################################################################
#	SiebAppORA
#######################################################################################################
resource "oci_core_instance" "ociVillaMTBSiebAppORA" {
  availability_domain = var.oci_availability_domain
  compartment_id      = var.org_compartment_ocid
  display_name        = "siebappora.${lower(var.organization_name)}.com"
  // is_pv_encryption_in_transit_enabled = true
  shape = "VM.Standard.E4.Flex"
  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = false
    plugins_config {
      desired_state = "DISABLED"
      name          = "Custom Logs Monitoring"
    }
  }
  shape_config {
    memory_in_gbs = 8
    ocpus         = 1
  }
  create_vnic_details {
    subnet_id                 = var.oci_app_subnet_id
    assign_private_dns_record = true
    assign_public_ip          = false
    hostname_label            = "siebappora"
  }
  source_details {
    source_id   = data.oci_core_images.win2016latest.images[0].id
    source_type = "image"
  }
}
resource "oci_core_volume" "siebapporaapps_volume" {
  #Required
  compartment_id      = var.org_compartment_ocid
  availability_domain = var.oci_availability_domain

  #Optional
  display_name = join("-", [var.organization_name, "Dev", "SiebAppORA", "Apps"])
  size_in_gbs  = 50
}
resource "oci_core_volume_attachment" "siebapporaapps_volume_attachment" {
  #Required
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.ociVillaMTBSiebAppORA.id
  volume_id       = oci_core_volume.siebapporaapps_volume.id
}
