
variable "boundary_org_name" {
	type = string
	description = "Boundary Organization name for this Boundary project"
	validation {
		condition = var.boundary_org_name != null && var.boundary_org_name != ""
		error_message = "Organization name must be specified and must not be empty"
	}
}

variable "boundary_project_name" {
	type = string
	description = "Project name for this Boundary project"
	validation {
		condition = var.boundary_project_name != null && var.boundary_project_name != ""
		error_message = "Project name must be specified and must not be empty"
	}
}

variable "credential_store_id" {
	type = string
	description = "Credential store id for Vault in this project and region"
}

variable "vault_engine_path" {
	type = string
	description = "Mount path for the k8s engine in Vault"
	
}

variable "k8s_roles" {
	type = list(object({
			name = string
			vault_role_name = string
			idp_group_id = string
		}))
}

variable "k8s_targets" {
	type = list(object({
		name=string,
		cloud = string,
		region = string,
		fqdn = string,
	}))
}

variable "k8s_port" {
	type = number
	description = "TCP port number to access the Kubernetes API, defaults to 6443 if not specified"
        validation {
                condition = var.k8s_port != null && var.k8s_port > 0 && var.k8s_port < 65536
                error_message = "k8s_port must be a valid TCP port number"
        }
	default = 6443
}

