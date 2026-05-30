terraform {
  required_version = ">= 1.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.120"
    }
  }
}

provider "yandex" {
  # Провайдер автоматически читает YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID, YC_ZONE
  # из переменных окружения. Явная передача не требуется.
}

variable "vm_name" { type = string }
variable "cores" { type = number }
variable "memory" { type = number }
variable "disk_size" { type = number }
variable "subnet_id" { type = string }
variable "ssh_public_key" { type = string }
variable "zone" { type = string }
variable "image_id" { type = string }

module "vm" {
  source = "../../modules/vm"

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
  value       = module.vm.public_ip
  description = "Публичный IP адрес ВМ"
}
