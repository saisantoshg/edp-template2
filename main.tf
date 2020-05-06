provider "aws"{
  version = "2.33.0"
  region="ap-south-1"
}

module "groups" {
  source = "./modules/groups/"

  group_map      = var.group_map

}

