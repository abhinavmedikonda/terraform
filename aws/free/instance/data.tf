data "terraform_remote_state" "ec2deployment" {
  backend = "remote"
  config = {
    organization = "abhinavmedikonda-terraform"
    workspaces = {
      name = "ec2-deployment"
    }
  }
}
