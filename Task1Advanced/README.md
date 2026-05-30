
# Универсальный модуль Terraform для Yandex Cloud  
  
## Описание  
Модуль `vm_module` разворачивает виртуальную машину в Yandex Compute Cloud с настраиваемыми вычислительными ресурсами, автоматически подключает дополнительный сетевой диск и настраивает сетевой интерфейс с внешним IP.  

## Входные параметры

| Параметр         | Тип      | Обяз. | По умолчанию  | Описание                        |
| ---------------- | -------- | ----- | ------------- | ------------------------------- |
| `vm_name`        | `string` | ✅     |               | Имя виртуальной машины          |
| `cores`          | `number` | ✅     |               | Количество vCPU                 |
| `memory`         | `number` | ✅     |               | Объём RAM (ГБ)                  |
| `disk_size`      | `number` | ✅     |               | Размер подключаемого диска (ГБ) |
| `subnet_id`      | `string` | ✅     |               | ID VPC подсети                  |
| `ssh_public_key` | `string` | ✅     |               | Публичный SSH-ключ              |
| `zone`           | `string` | ✅     |               | Зона доступности (YC)           |
| `image_id`       | `string` | ✅     |               | ID загрузочного образа          |
| `platform_id`    | `string` | ❌     | `standard-v3` | Аппаратная платформа            |
| `os_username`    | `string` | ❌     | `ubuntu`      | Логин ОС для SSH                |
  
> 🔒 `ssh_public_key` помечен как `sensitive = true` и не логируется в выводе.  
  
---  
  
## Выходы (Outputs)  
| Выход        | Описание               |
| ------------ | ---------------------- |
| `vm_id`      | ID созданной ВМ        |
| `vm_name`    | Имя ВМ                 |
| `public_ip`  | Внешний IPv4-адрес     |
| `private_ip` | Внутренний IPv4-адрес  |
| `disk_id`    | ID подключённого диска |
  
---  
  
## Запуск окружений  
  
### 1. Подготовка  

Убедитесь, что экспортированы переменные окружения:  
```bash  
export YC_TOKEN=$(yc iam create-token --impersonate-service-account-id <sa_id>)  
export YC_CLOUD_ID=$(yc config get cloud-id)  
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_ENDPOINT="api.cloud.yandex.net:443" 
```

###  2. Деплой окружений 
  
# Dev  
```bash  
cd envs/dev  
terraform init  
terraform plan -var-file=dev.tfvars  
terraform apply -var-file=dev.tfvars  
```

# Stage  
```bash  
cd ../stage  
terraform init  
terraform plan -var-file=stage.tfvars  
terraform apply -var-file=stage.tfvars  
```
  
# Prod  
```bash  
cd ../prod  
terraform init  
terraform plan -var-file=prod.tfvars  
terraform apply -var-file=prod.tfvars
```
