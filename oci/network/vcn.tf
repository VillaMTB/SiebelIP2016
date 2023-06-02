
# Main VCN
resource "oci_core_vcn" "ociVillaMTBDevVCN" {
  compartment_id = var.org_compartment_ocid
  cidr_blocks    = [cidrsubnet(var.org_cidr_block, 8, 6)]
  display_name   = join("-", [var.organization_name, "Dev", "VCN"])
  dns_label      = "villamtb"
  # defined_tags = {"Operations.CostCentre"= "1","Oracle-Tags.CreatedBy"="david","Oracle-Tags.CreatedOn"=timestamp()}
}

#	Subnets
resource "oci_core_subnet" "ociVillaMTBDevDBSubnet" {
  compartment_id             = var.org_compartment_ocid
  vcn_id                     = oci_core_vcn.ociVillaMTBDevVCN.id
  cidr_block                 = cidrsubnet(cidrsubnet(var.org_cidr_block, 8, 6), 8, 0)
  display_name               = join("-", [var.organization_name, "Dev", "DB", "Subnet"])
  dns_label                  = lower("DevDB")
  route_table_id             = oci_core_vcn.ociVillaMTBDevVCN.default_route_table_id
  security_list_ids          = [oci_core_vcn.ociVillaMTBDevVCN.default_security_list_id]
  prohibit_public_ip_on_vnic = true
  # defined_tags = {"Operations.CostCentre"= "1","Oracle-Tags.CreatedBy"="david","Oracle-Tags.CreatedOn"=timestamp()}
}
resource "oci_core_subnet" "ociVillaMTBDevAppSubnet" {
  compartment_id             = var.org_compartment_ocid
  vcn_id                     = oci_core_vcn.ociVillaMTBDevVCN.id
  cidr_block                 = cidrsubnet(cidrsubnet(var.org_cidr_block, 8, 6), 8, 1)
  display_name               = join("-", [var.organization_name, "Dev", "App", "Subnet"])
  dns_label                  = lower("DevApp")
  route_table_id             = oci_core_vcn.ociVillaMTBDevVCN.default_route_table_id
  security_list_ids          = [oci_core_vcn.ociVillaMTBDevVCN.default_security_list_id]
  prohibit_public_ip_on_vnic = true
  # defined_tags = {"Operations.CostCentre"= "1","Oracle-Tags.CreatedBy"="david","Oracle-Tags.CreatedOn"=timestamp()}
}

#	Services
data "oci_core_services" "ociVillaMTBDevServices" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

#	NAT gateway
resource "oci_core_nat_gateway" "ociVillaMTBDevNAT" {
  #Required
  compartment_id = var.org_compartment_ocid
  display_name   = join("-", [var.organization_name, "Dev", "NAT"])
  vcn_id         = oci_core_vcn.ociVillaMTBDevVCN.id
  # defined_tags = {"Operations.CostCentre"= "1","Oracle-Tags.CreatedBy"="david","Oracle-Tags.CreatedOn"=timestamp()}
}

# Default Route Table
resource "oci_core_default_route_table" "ociVillaMTBDevDefaultRT" {
  manage_default_resource_id = oci_core_vcn.ociVillaMTBDevVCN.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.ociVillaMTBDevNAT.id
  }
  route_rules {
    destination       = data.oci_core_services.ociVillaMTBDevServices.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.ociVillaMTBDevSVC.id
  }
  route_rules {
    destination       = var.onprem_cidr_block
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.ociVillaMTBDevDRG.id
  }
  /*  route_rules {
    destination       = var.az_cidr_block
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.ociVillaMTBDevDRG.id
  }*/
}

#	Service gateway
resource "oci_core_service_gateway" "ociVillaMTBDevSVC" {
  #Required
  compartment_id = var.org_compartment_ocid
  display_name   = join("-", [var.organization_name, "Dev", "SVCGwy"])
  vcn_id         = oci_core_vcn.ociVillaMTBDevVCN.id

  services {
    service_id = data.oci_core_services.ociVillaMTBDevServices.services[0]["id"]
  }
}

# DRG
resource "oci_core_drg" "ociVillaMTBDevDRG" {
  #Required
  compartment_id = var.org_compartment_ocid

  #Optional
  display_name = join("-", [var.organization_name, "Dev", "DRG"])
}

# DRG attachment
resource "oci_core_drg_attachment" "ociVillaMTBDevDRGAttach" {
  #Required
  drg_id       = oci_core_drg.ociVillaMTBDevDRG.id
  display_name = join("-", [var.organization_name, "Dev", "DRGAttach"])
  # Optional
  network_details {
    id   = oci_core_vcn.ociVillaMTBDevVCN.id
    type = "VCN"
  }
}
