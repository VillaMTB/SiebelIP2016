resource "oci_core_security_list" "devdb_security_list" {
  #Required
  compartment_id = var.org_compartment_ocid
  vcn_id         = data.oci_core_vcns.corp_vcns.virtual_networks[0].id
  #Optional
  display_name = join("-", [var.organization_name, "Dev", "DB", "SL"])

  ingress_security_rules {
    description = "MSSQL DB On Premise"
    protocol    = "6"
    source      = var.onprem_cidr_block

    tcp_options {
      min = 1433
      max = 1434
    }
  }
  ingress_security_rules {
    description = "MSSQL DB Siebel App Subnet"
    protocol    = "6"
    source      = cidrsubnet(var.org_cidr_block,8,0)

    tcp_options {
      min = 1433
      max = 1434
    }
  }
  ingress_security_rules {
    description = "Oracle DB On Premise"
    protocol    = "6"
    source      = var.onprem_cidr_block

    tcp_options {
      min = 1521
      max = 1521
    }
  }
  ingress_security_rules {
    description = "Oracle DB Siebel App Subnet"
    protocol    = "6"
    source      = cidrsubnet(var.org_cidr_block,8,0)

    tcp_options {
      min = 1521
      max = 1521
    }
  }
}
resource "oci_core_security_list" "devsblapp_security_list" {
  #Required
  compartment_id = var.org_compartment_ocid
  vcn_id         = data.oci_core_vcns.corp_vcns.virtual_networks[0].id
  #Optional
  display_name = join("-", [var.organization_name, "Dev", "SiebelApp", "SL"])

  ingress_security_rules {
    description = "Gateway On Premise"
    protocol    = "6"
    source      = var.onprem_cidr_block

    tcp_options {
      min = 2320
      max = 2320
    }
  }
  ingress_security_rules {
    description = "SC Broker On Premise"
    protocol    = "6"
    source      = var.onprem_cidr_block

    tcp_options {
      min = 2321
      max = 2321
    }
  }
}