# module "instance" {
#   source                      = "github.com/abhinavmedikonda/terraform//modules/aws/instance?ref=main"
#   instance_type               = local.instance_type
#   instance_count              = 1
#   subnet_id                   = data.terraform_remote_state.vpc.outputs.subnet_ids[0]
#   associate_public_ip_address = false
# }
