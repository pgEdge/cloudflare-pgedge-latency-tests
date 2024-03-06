
locals {
  machine_type = "e2-small"
}

module "compute-lax" { // Los Angeles
  source       = "./modules/compute"
  name         = "cfb-lax"
  region       = "us-west2"
  zone         = "us-west2-a"
  machine_type = local.machine_type
  project_name = var.project_name
}

module "compute-slc" { // Salt Lake City
  source       = "./modules/compute"
  name         = "cfb-slc"
  region       = "us-west3"
  zone         = "us-west3-a"
  machine_type = local.machine_type
  project_name = var.project_name
}

module "compute-dfw" { // Dallas
  source       = "./modules/compute"
  name         = "cfb-dfw"
  region       = "us-south1"
  zone         = "us-south1-a"
  machine_type = local.machine_type
  project_name = var.project_name
}

module "compute-chs" { // Charleston
  source       = "./modules/compute"
  name         = "cfb-chs"
  region       = "us-east1"
  zone         = "us-east1-b"
  machine_type = local.machine_type
  project_name = var.project_name
}

module "compute-yyz" { // Toronto
  source       = "./modules/compute"
  name         = "cfb-yyz"
  region       = "northamerica-northeast2"
  zone         = "northamerica-northeast2-a"
  machine_type = local.machine_type
  project_name = var.project_name
}

output "ips" {
  value = {
    lax = module.compute-lax.instance_ip
    slc = module.compute-slc.instance_ip
    dfw = module.compute-dfw.instance_ip
    chs = module.compute-chs.instance_ip
    yyz = module.compute-yyz.instance_ip
  }
}
