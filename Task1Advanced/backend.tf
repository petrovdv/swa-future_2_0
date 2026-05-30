terraform {
  # Бэкенд для удалённого состояния
  backend "s3" {}

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.120.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.sa_key_file != "" ? var.sa_key_file : null
  cloud_id                 = var.yc_cloud_id != "" ? var.yc_cloud_id : null
  folder_id                = var.yc_folder_id != "" ? var.yc_folder_id : null
}

module "vm" {
  source = "./modules/vm"

  vm_name        = var.vm_name
  cores          = var.cores
  memory         = var.memory
  disk_size      = var.disk_size
  subnet_id      = var.subnet_id
  ssh_public_key = var.ssh_public_key
  zone           = var.zone
  image_id       = var.image_id
}

output "vm_public_ip" {
  value = module.vm.public_ip
}