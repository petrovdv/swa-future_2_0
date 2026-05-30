# События

| Событие | Домен-источник | Агрегат | Ключевые поля payload | Подписчики | Примечания |
|---|---|---|---|---|---|
| `PatientRegistered` | Клиники | `Patient` | `patientId`, `registeredAt`, статус согласия | Финтех, ИИ-сервисы, Витрина | Триггер для открытия счёта и профиля ИИ. PHI не включается. |
| `ConsentUpdated` | Клиники | `Patient` | `patientId`, `consentType`, `consentStatus`, `updatedAt` | ИИ-сервисы, Финтех | Обязательная проверка перед обработкой задач ИИ и финансовых операций. |
| `VisitScheduled` | Клиники | `Visit` | `visitId`, `patientId`, `doctorId`, `slotId`, `scheduledAt` | Витрина | Аналитика загрузки врачей и кабинетов. |
| `VisitCompleted` | Клиники | `Visit` | `visitId`, `patientId`, `completedAt`, `serviceCode` | ИИ-сервисы, Витрина | Инициирует создание `DiagnosticTask` при наличии показаний. |
| `VisitCancelled` | Клиники | `Visit` | `visitId`, `patientId`, `cancelledAt`, причина | Витрина | Освобождает слот для повторного бронирования. |
| `AccountOpened` | Финтех | `BankAccount` | `accountId`, `customerId`, `openedAt`, тип счёта | Витрина | Аналитика онбординга клиентов. |
| `FundsDeposited` | Финтех | `BankAccount` | `accountId`, сумма, валюта, `transactionId`, `depositedAt` | Витрина | — |
| `FundsWithdrawn` | Финтех | `BankAccount` | `accountId`, сумма, валюта, `transactionId`, `withdrawnAt` | Витрина | — |
| `CreditApplicationSubmitted` | Финтех | `CreditContract` | `applicationId`, `applicantId`, сумма, `submittedAt` | Витрина | Инициирует расчёт скоринга внутри домена. |
| `CreditScoreCalculated` | Финтех | `CreditContract` | `applicationId`, `applicantId`, балл, `calculatedAt` | Витрина | Промежуточное событие для аудита и BI. |
| `CreditContractCreated` | Финтех | `CreditContract` | `contractId`, `customerId`, лимит, ставка, срок, `createdAt` | Клиники, Витрина | Клиники используют для предоставления рассрочки на лечение. |
| `PaymentInitiated` | Финтех | `Payment` | `paymentId`, `accountId`, сумма, `idempotencyKey`, `initiatedAt` | Витрина | — |
| `PaymentCompleted` | Финтех | `Payment` | `paymentId`, `accountId`, сумма, `completedAt` | Клиники, Витрина | Клиники получают подтверждение оплаты услуг. |
| `PaymentFailed` | Финтех | `Payment` | `paymentId`, `accountId`, код ошибки, `failedAt` | Клиники, Витрина | Клиники могут заблокировать услугу до урегулирования. |
| `DiagnosticTaskCreated` | ИИ-сервисы | `DiagnosticTask` | `taskId`, `patientIdHash`, тип задачи, `createdAt` | Витрина | PHI не включается — только хеш пациента и тип диагностики. |
| `DiagnosticCompleted` | ИИ-сервисы | `DiagnosticTask` | `taskId`, `patientIdHash`, `resultRef`, `completedAt`, метрики уверенности | Клиники, Витрина | Клиники получают ссылку на результат (PHI в событии отсутствует). |
| `DiagnosticFailed` | ИИ-сервисы | `DiagnosticTask` | `taskId`, код ошибки, `failedAt` | Клиники | Сигнал для повторного исследования. |
| `ModelDeployed` | ИИ-сервисы | `MLModel` | `modelId`, версия, контекст применения, `deployedAt` | ИИ-сервисы (внутр.), Клиники | Клиники уведомляются о новой версии диагностической модели. |
| `ModelDeprecated` | ИИ-сервисы | `MLModel` | `modelId`, версия, `deprecatedAt`, `replacedByModelId` | ИИ-сервисы (внутр.) | Блокирует создание новых задач с устаревшей версией. |
| `SupplyOrderPlaced` | Партнёры | `SupplyOrder` | `orderId`, `partnerId`, позиции, `placedAt` | Партнёры (внешн.) | Уходит во внешнюю систему партнёра через IntegrationGatewayBC. |
| `SupplyDelivered` | Партнёры | `SupplyOrder` | `orderId`, `partnerId`, фактические позиции, `deliveredAt` | Клиники, Витрина | Клиники обновляют складские остатки. |
| `PartnerEventReceived` | Партнёры (ACL) | `PartnerContract` | `externalEventId`, `partnerId`, тип события, raw payload | → внутренние события доменов | ACL-точка трансляции. Внешняя схема не попадает в другие домены. |
| `ReportGenerated` | Витрина | `AnalyticalModel` | `reportId`, `modelId`, `generatedAt`, формат | BI-слой (внутр.) | Внутреннее событие. Уведомляет о готовности нового среза данных. |
| `DatasetRefreshed` | Витрина | `AnalyticalModel` | `datasetId`, `refreshedAt`, список обновлённых доменов | BI-слой (внутр.) | Внутреннее событие. Инвалидирует кеши и инициирует обновление дашбордов. |