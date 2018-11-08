module "spn" {
  source                    =   "git::ssh://git@github.com/andresguisado/tf-modules.git//azure/spn"
  spn_name                  =   "${var.spn_name}"
  spn_end_date              =   "${var.spn_end_date}"
  spn_role_definition_name  =   "${var.spn_role_definition_name}"
  spn_scope                 =   "${var.spn_scope}"
}

module "keyvault" {
  source                    =   "git::ssh://git@github.com/andresguisado/tf-modules.git//azure/keyvault"
  rg_name                   =   "${var.rg_name}"
  location                  =   "${var.location}"
  kv_name                   =   "${var.kv_name}"
  tenant_id                 =   "${var.tenant_id}"
  object_id_1               =   "${var.object_id_1}"
  object_id_2               =   "${module.spn.spn_principal}"
}

resource "azurerm_role_assignment" "app_spn_role" {
  depends_on           = ["module.keyvault"]
  scope                = "${var.spn_scope}" #/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  role_definition_name = "${var.spn_role_definition_name}"
  principal_id         = "${module.spn.spn_principal}"
}

/*resource "null_resource" "azure_role_assignment"
{
  depends_on           = ["module.keyvault"]
  provisioner "local-exec" {
    command = "az role assignment create --role ${var.spn_role_definition_name} --assignee-object-id ${module.spn.spn_principal} --scope ${var.spn_scope}"
  }
}*/

module "tf_id_secret" {
  source                    =   "git::ssh://git@github.com/andresguisado/tf-modules.git//azure/keyvault-secret"
  name                      =   "${var.tf_id_secret_name}"
  value                     =   "${module.spn.spn_app_id}"
  vault_uri                 =   "${module.keyvault.vault_uri}"
}

module "tf_pass_secret" {
  source                    =   "git::ssh://git@github.com/andresguisado/tf-modules.git//azure/keyvault-secret"
  name                      =   "${var.tf_pass_secret_name}"
  value                     =   "${module.spn.spn_password}"
  vault_uri                 =   "${module.keyvault.vault_uri}"
}