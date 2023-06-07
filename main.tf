data "oci_identity_compartments" "org_compartments" {
  #Required
  compartment_id = var.tenancy_ocid
  #Optional
  name = var.organization_name
}

data "oci_identity_availability_domains" "org_availability_domains" {
  #Required
  compartment_id = var.tenancy_ocid
}

module "oci-dev-network" {
  source               = "./oci/network"
  az_cidr_block        = cidrsubnet(cidrsubnet(var.org_cidr_block, 8, 1), 8, 0)
  environment_code     = "Dev"
  onprem_cidr_block    = cidrsubnet(var.org_cidr_block, 8, 5)
  org_cidr_block       = cidrsubnet(var.org_cidr_block, 8, 0)
  org_compartment_ocid = local.org_compartment_ocid
  organization_name    = var.organization_name
}

module "oci-dev-compute-vms" {
  source                  = "./oci/compute"
  oci_availability_domain = data.oci_identity_availability_domains.org_availability_domains.availability_domains[0].name
  oci_app_subnet_id       = module.oci-dev-network.dev_siebel_app_subnet_id
  oci_db_subnet_id        = module.oci-dev-network.dev_db_subnet_id
  org_compartment_ocid    = local.org_compartment_ocid
  organization_name       = var.organization_name
  ssh_public_key          = var.ssh_public_key
  tenancy_namespace       = var.tenancy_namespace
}

module "oci-dev-storage" {
  source                  = "./oci/storage"
  oci_availability_domain = data.oci_identity_availability_domains.org_availability_domains.availability_domains[0].name
  org_compartment_ocid    = local.org_compartment_ocid
}