
locals {
	credential_libs = {for v in var.k8s_roles: v.name => {role=v.name,
		vault_role = v.vault_role_name,
		vault_path = "${var.vault_engine_path}/creds/${v.vault_role_name}"
		target_type = "k8s"}}
}

resource "boundary_credential_library_vault" "k8s" {
  for_each = tomap(local.credential_libs)
  name = "${each.value.target_type}-${each.value.role}"
  description         = "Vault credential library for ${each.value.role} role on ${each.value.target_type}"
  credential_store_id = var.credential_store_id
  path                = each.value.vault_path
  http_method = "POST"
}

