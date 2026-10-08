
locals {
	k8s_target_and_roles = setproduct(var.k8s_roles, var.k8s_targets)

	k8s_targets =  {for p in local.k8s_target_and_roles: "k8s-${p[1].name}-${p[0].name}" => {
		name="k8s-${p[1].name}-${p[0].name}",
		description = "This target grants k8s access for the ${p[1].fqdn} cluster",
		credential_library_id = boundary_credential_library_vault.k8s["${p[0].name}"].id,
		cloud = p[1].cloud,
		group_id = p[0].idp_group_id
		target_name = p[1].name
		role_name = p[0].name
		region = p[1].region,
		fqdn = p[1].fqdn
		}}
}

resource "boundary_target" "k8s" {
  for_each = local.k8s_targets
  name         = each.key
  description  = each.value.description
  type         = "tcp"
  default_port = var.k8s_port
  scope_id     = data.boundary_scope.project.id
  address      = each.value.fqdn
  brokered_credential_source_ids = [
    each.value.credential_library_id
  ]

  egress_worker_filter = "\"egress\" in \"/tags/type\" and `${each.value.cloud}` in \"/tags/cloud\" and `${each.value.region}` in \"/tags/region\""
}

