
module "k8s-aws" {
	source = "../terraform-boundary-k8s-target-sample"

	boundary_org_name = "customer"
	boundary_project_name = "test1aws"
	credential_store_id = "csvlt_..."

	vault_engine_path = "kubernetes"

	k8s_roles = [{
				name = "user"
				vault_role_name = "user"
				idp_group_id = module.aws.users_managed_group_id
			},
			{
				name = "admin"
				vault_role_name = "admin"
				idp_group_id = module.aws.admins_managed_group_id
	}]

	k8s_targets = [{
		name="test1-app-dev",
		cloud="aws",
		region="us-east-2",
		fqdn="k8s-dev.example.com",
		},{
		name="test1-web-dev",
		cloud="aws",
		region="us-east-2",
		fqdn="k8s-dev-web.example.com",
	}]



}

