output "dev_app_subnet_id" {
	value = oci_core_subnet.ociVillaMTBDevAppSubnet.id
}
output "dev_db_subnet_id" {
	value = oci_core_subnet.ociVillaMTBDevDBSubnet.id
}
