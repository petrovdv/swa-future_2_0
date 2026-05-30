output "vm_id" {
  value       = yandex_compute_instance.vm.id
  description = "ID виртуальной машины"
}

output "vm_name" {
  value       = yandex_compute_instance.vm.name
  description = "Имя ВМ"
}

output "public_ip" {
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
  description = "Публичный IPv4-адрес"
}

output "private_ip" {
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
  description = "Приватный IPv4-адрес"
}

output "disk_id" {
  value       = yandex_compute_disk.data.id
  description = "ID подключённого диска"
}
