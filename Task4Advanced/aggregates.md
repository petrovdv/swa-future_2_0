# Агрегаты

| Агрегат | Bounded Context | Домен | Ключевые поля | Инварианты / правила | Публикуемые события |
|---|---|---|---|---|---|
| `Patient` | PatientManagementBC | Клиники | `patientId`, контакты, статус согласия | Только операционные демо-данные. Мед. карты — в legacy. PHI не покидает домен. | `PatientRegistered`, `ConsentUpdated` |
| `Visit` | VisitSchedulingBC | Клиники | `visitId`, `patientId`, `doctorId`, `roomId`, `slotId`, статус | Один слот — один визит. Врач и кабинет не пересекаются по времени. | `VisitScheduled`, `VisitCompleted`, `VisitCancelled` |
| `BankAccount` | BankingAccountsBC | Финтех | `accountId`, `customerId`, баланс, движения средств | ACID-транзакции. Баланс < 0 только при явном овердрафтном соглашении. | `AccountOpened`, `FundsDeposited`, `FundsWithdrawn` |
| `CreditContract` | CreditScoringBC | Финтех | `contractId`, `applicantId`, скоринг-профиль, лимит, статус | Риск-логика изолирована от платежей. Контракт — только при скоринге выше порога. | `CreditApplicationSubmitted`, `CreditScoreCalculated`, `CreditContractCreated` |
| `Payment` | PaymentsBC | Финтех | `paymentId`, `accountId`, сумма, статус, `idempotencyKey` | Идемпотентность по `idempotencyKey`. Каждый платёж пишется в аудит-лог. | `PaymentInitiated`, `PaymentCompleted`, `PaymentFailed` |
| `DiagnosticTask` | DiagnosticTasksBC | ИИ-сервисы | `taskId`, `patientIdHash`, статус, `resultRef` | PHI не хранится. Только хеш пациента и ссылка на артефакт результата. | `DiagnosticTaskCreated`, `DiagnosticCompleted`, `DiagnosticFailed` |
| `MLModel` | ModelLifecycleBC | ИИ-сервисы | `modelId`, версия, метрики качества, статус lifecycle | Одна активная версия на контекст. Депрекация требует наличия замены. | `ModelDeployed`, `ModelDeprecated` |
| `SupplyOrder` | SupplyChainBC | Партнёры | `orderId`, `partnerId`, позиции (препараты / оборудование), партия | Остатки обновляются только после подтверждения доставки. | `SupplyOrderPlaced`, `SupplyDelivered` |
| `PartnerContract` | IntegrationGatewayBC | Партнёры | `contractId`, `partnerId`, схема интеграции, версия контракта | ACL: внешние события транслируются во внутреннюю модель. Внешняя схема не проникает в домены. | `PartnerEventReceived` |
| `AnalyticalModel` | AnalyticalModelsBC | Витрина | `modelId`, материализованные представления, политики доступа | CQRS read-модель. Только события без PHI. Не публикует событий наружу. | `ReportGenerated`, `DatasetRefreshed` (внутр.) |
| `DataCatalog` | DataCatalogBC | Витрина | `catalogId`, реестр схем, политики RBAC/ABAC, версии контрактов | Смена схемы без обратной совместимости — только через новую мажорную версию. | — |