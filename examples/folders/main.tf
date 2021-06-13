# -----------------------------------------------------------------------------
# This is a testing example of the Denodo Provider
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    denodo = {
      version = "0.1"
      source  = "custom.com/bryannice/denodo"
    }
  }
}

# -----------------------------------------------------------------------------
# Setting the Denodo Provider
# -----------------------------------------------------------------------------

provider "denodo" {
  database = var.denodo_database
  host     = var.denodo_host
  password = var.denodo_password
  port     = var.denodo_port
  ssl_mode = "require"
  username = var.denodo_username
}

# -----------------------------------------------------------------------------
# Reading from Remote State File from Virtual Database
# -----------------------------------------------------------------------------

data "terraform_remote_state" "vbd" {
  backend = "local"
  config = {
    path = "../virtual_database/terraform.tfstate"
  }
}

# -----------------------------------------------------------------------------
# Create folder list
# -----------------------------------------------------------------------------

locals {
  folder_list = ["/base_view", "/data_source", "/dervived_view"]
}

# -----------------------------------------------------------------------------
# Creating Folders in Database
# -----------------------------------------------------------------------------

resource "denodo_database_folder" "db_folder" {
  count       = length(local.folder_list.*)
  database    = data.terraform_remote_state.vbd.outputs.id
  folder_path = local.folder_list[count.index]
}
