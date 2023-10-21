data "oci_core_vcns" "corp_vcns" {
  compartment_id = var.org_compartment_ocid
  display_name   = join("-", [var.organization_name, "Corp", "VCN"])
}
data "oci_core_dhcp_options" "dhcp_options" {
  compartment_id = var.org_compartment_ocid
  display_name   = join("-", [var.organization_name, "Corp", "DHCP"])
}

# Subnets
resource "oci_core_subnet" "ociVillaMTBDevSiebelAppSubnet" {
  compartment_id  = var.org_compartment_ocid
  vcn_id          = data.oci_core_vcns.corp_vcns.virtual_networks[0].id
  cidr_block      = cidrsubnet(var.org_cidr_block, 8, 2)
  dhcp_options_id = data.oci_core_dhcp_options.dhcp_options.id
  display_name    = join("-", [var.organization_name, "Dev", "SiebelApp", "Subnet"])
  dns_label       = "devsiebelapp"
  route_table_id  = data.oci_core_vcns.corp_vcns.virtual_networks[0].default_route_table_id
  security_list_ids = [data.oci_core_vcns.corp_vcns.virtual_networks[0].default_security_list_id
    , oci_core_security_list.devsblapp_security_list.id
  ]
  prohibit_public_ip_on_vnic = true
  # defined_tags = {"Operations.CostCentre"= "1","Oracle-Tags.CreatedBy"="david","Oracle-Tags.CreatedOn"=timestamp()}
}
resource "oci_core_subnet" "ociVillaMTBDevDBSubnet" {
  compartment_id  = var.org_compartment_ocid
  vcn_id          = data.oci_core_vcns.corp_vcns.virtual_networks[0].id
  cidr_block      = cidrsubnet(var.org_cidr_block, 8, 1)
  dhcp_options_id = data.oci_core_dhcp_options.dhcp_options.id
  display_name    = join("-", [var.organization_name, "Dev", "DB", "Subnet"])
  dns_label       = "devdb"
  route_table_id  = data.oci_core_vcns.corp_vcns.virtual_networks[0].default_route_table_id
  security_list_ids = [
    data.oci_core_vcns.corp_vcns.virtual_networks[0].default_security_list_id
    , oci_core_security_list.devdb_security_list.id
  ]
  prohibit_public_ip_on_vnic = true
  # defined_tags = {"Operations.CostCentre"= "1","Oracle-Tags.CreatedBy"="david","Oracle-Tags.CreatedOn"=timestamp()}
}
