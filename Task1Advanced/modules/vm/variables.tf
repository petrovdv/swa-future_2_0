variable "vm_name" {
  type        = string
  description = "Имя виртуальной машины"
}

variable "cores" {
  type        = number
  description = "Количество vCPU"
}

variable "memory" {
  type        = number
  description = "Объём оперативной памяти (ГБ)"
}

variable "disk_size" {
  type        = number
  description = "Размер подключаемого диска (ГБ)"
}

variable "subnet_id" {
  type        = string
  description = "ID подсети Yandex VPC"
}

variable "ssh_public_key" {
  type        = string
  description = "Публичный SSH-ключ"
  sensitive   = true
}

variable "zone" {
  type        = string
  description = "Зона доступности"
}

variable "image_id" {
  type        = string
  description = "ID загрузочного образа ОС"
}

variable "platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Аппаратная платформа ВМ"
}

variable "os_username" {
  type        = string
  default     = "ubuntu"
  description = "Имя пользователя ОС для SSH-доступа"
}
