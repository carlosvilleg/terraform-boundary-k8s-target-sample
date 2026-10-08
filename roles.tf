
locals {
	k8s_roles = {for v in var.k8s_roles: v.name => v}
	k8s_targets_per_role = { for role in keys(local.k8s_roles): role => [for k, v in local.k8s_targets: v if v.role_name == role]}
	k8s_target_ids_per_role = { for k, v in local.k8s_targets_per_role: k => [for t in local.k8s_targets_per_role[k]: boundary_target.k8s[t.name].id ] }
}


resource "boundary_role" "target" {
  for_each = local.k8s_roles

  name         = "k8s-${each.key}"
  description = "Grants access to the Kubernetes for the ${each.key} role"
  scope_id        = data.boundary_scope.project.id
  grant_scope_ids = [ "this" ]
  grant_strings   = ["ids=${join(",", local.k8s_target_ids_per_role[each.key])};type=target;actions=list,read,authorize-session",
 	 "ids=*;type=target;actions=list"]
  principal_ids   = [each.value.idp_group_id]
}

