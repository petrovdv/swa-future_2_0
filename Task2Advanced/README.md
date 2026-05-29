# Terraform CI/CD: Yandex Cloud VM Module

## Описание
Автоматизированное развёртывание виртуальных машин в Yandex Cloud через GitHub Actions. 
Состояние инфраструктуры хранится удалённо (Yandex Object Storage), 
аутентификация происходит через Service Account JSON Key с автообновлением токена. 
Деплой защищён ручным апрувом для окружения `dev`.


## CI/CD Pipeline (GitHub Actions)

## Принцип работы пайплайна
| Триггер | Job | Действие |
|---------|-----|----------|
| `pull_request` (любая ветка) | `Plan (PR)` | Автогенерация плана изменений |
| `workflow_dispatch` (кнопка Run) | `Deploy to Dev` | Ручной деплой на `dev` с approval gate |

 **Безопасность:**
- Секреты хранятся в GitHub Secrets. В логах автоматически маскируются.
- Состояние пишется в Yandex Object Storage с включённым `Versioning`.
- Аутентификация через `SA_KEY_JSON` → токен обновляется автоматически, без 12-часовых лимитов.

## Подготовка к запуску

### 1. Yandex Cloud
1. Создайте бакет `tf-state-mydev` → включите `Versioning`
2. Создайте SA `terraform-ci` → назначьте роли:
   - `compute.editor`, `vpc.viewer` на каталог
   - `storage.editor` на бакет
3. Сгенерируйте два ключа:
   - Статический S3-ключ → `S3_ACCESS_KEY`, `S3_SECRET_KEY`
   - IAM JSON-ключ → `SA_KEY_JSON` (многострочный)

### 2. GitHub Secrets
Добавьте в репозиторий:
| Secret | Значение |
|--------|----------|
| `YC_CLOUD_ID` | ID облака |
| `YC_FOLDER_ID` | ID каталога |
| `STATE_BUCKET` | `tf-state-mydev` |
| `S3_ACCESS_KEY` | `key_id` из S3-ключа |
| `S3_SECRET_KEY` | `secret` из S3-ключа |
| `SA_KEY_JSON` | Полное содержимое IAM JSON-ключа |

### 3. GitHub Environments
`Settings → Environments → New environment` → `dev` → включите `Required reviewers`.

## Использование
1. Создайте PR с изменениями → во вкладке `Checks` появится результат `terraform plan`.
2. Для деплоя: `Actions → Terraform CI/CD → Run workflow` → выберите ветку → подтвердите в Environment.
3. Состояние автоматически сохраняется в `s3://tf-state-mydev/dev/terraform.tfstate`.

## Очистка
```bash
terraform destroy -var-file=envs/dev/dev.tfvars -auto-approve
```