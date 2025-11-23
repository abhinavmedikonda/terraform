data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "abhinavmedikonda-terraform"
    workspaces = {
      name = "vpc"
    }
  }
}
