# Интернет-магазин

Приложение позволяет заказывать товары в интернет магазине

## Пользовательские сценарии

- Я как пользователь могу зарегистрироваться в интернет-магазине
- Я как пользователь могу авторизоваться в интернет-магазине
- Я как пользователь могу пополнить баланс своего счёта
- Я как пользователь могу получить баланс своего счёта
- Я как пользователь могу создать заказ
- Я как пользователь могу получить список уведомлений о заказах

### Предметные области

- Пользователь
- Заказ
- Уведомление
- Счёт

### Системные действия

- Регистрация
- Авторизация
- Пополнение счёта
- Получение баланса 
- Создание заказа
- Получение уведомлений

## Сервисы

- Сервис «Пользователи»
- Сервис «Биллинг»
- Сервис «Заказов»
- Сервис «Уведомлений»

## Спецификация OpenAPI

[OpenAPI.yaml]https://github.com/slava130913/otus-microservices-architecture-homework/blob/master/project/api-spec/static/open-api.yaml)

## Общая схема

![](screen1.png)


## Схема взаимодействия
![](structure.png)

---
### Сервис «Пользователи»

**Описание**

Сервис предоставляет API для работы с пользователями: регистрация, аутентификация и обновление информации про пользователя

**Запросы**

- None

**Команды**

- `POST /api/v1/users/register` — регистрация нового пользователя
- `PUT  /api/v1/users/{id}` — обновление информации пользователя
- `POST /api/v1/users/login` — аутентификация

**События**

- None

**Пробы**

- `GET /api/v1/users/health` — возвращает состояние сервиса

**Зависимости**

- Вызывает метод создания аккаунта в сервисе биллинга `POST /api/v1/billing/account` 

---
### Сервис «Биллинг»

**Описание**

Сервис предоставляет API для работы со счетом пользователя: создание счета, пополнение и списание

**Запросы**

- `GET /api/v1/billing/account/my` — отображает состояние счёта (баланса)

**Команды**

- `POST /api/v1/billing/account` — создание счёта
- `POST /api/v1/billing/account/deposit` — пополнение баланса счёта пользователя
- `POST /api/v1/billing/account/withdraw` — списание денег со счёта пользователя

**События**

- None

**Пробы**

- `GET /api/v1/billing/health` — возвращает состояние сервиса

**Зависимости**

- None

---

### Сервис «Заказы»

**Описание**

Сервис предоставляет API для работы с заказами

**Запросы**

- `GET /api/v1/orders` — отображает все заказы пользователя

**Команды**

- `POST /api/v1/orders` — создание заказа

**События**

- `OrderCreated` — событие при успешном создании заказа
- `OrderNotCreated` — событие при неуспешном создании заказа (не хватило денег)

**Пробы**

- `GET /api/v1/orders/health` — возвращает состояние сервиса

**Зависимости**

- Вызывает метод списание денег со счёта пользователя в сервисе биллинга `POST /api/v1/billing/account/withdraw`

---

### Сервис «Уведомления»

**Описание**

Сервис предоставляет API для работы с уведомлениями

**Запросы**

- `GET /api/v1/notifications` — отображает все уведомления пользователя

**Команды**

- None

**События**

- None

**Пробы**

- `GET /api/v1/notifications/health` — возвращает состояние сервиса

**Зависимости**

- Обрабатывает событие `OrderCreated`
- Обрабатывает событие `OrderNotCreated`

## Оглавление
- [Главное](#general)
- [Установка](#installation)
- [Тестирование](#testing)

### Главное

Схема связи служб

![](structure.png)

[OpenAPI spec](./api-spec/static/open-api.yaml)

![](swagger.png)

### Установка

Создание namespace

```shell
kubectl create namespace im-project
```

Выбор созданного namespace

```shell
kubectl config set-context --current --namespace=im-project
```

Установка и настройка Kafka
```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install kafka bitnami/kafka -f kafka/config.yaml
```

Установка postgres и настройка user-app

```shell
cd user
helm install user-db bitnami/postgresql -f database/postgres/config.yaml
helm install user-app application/.helm
```

Установка postgres и настройка billing-app
```shell
cd billing
helm install billing-db bitnami/postgresql -f database/postgres/config.yaml
helm install billing-app application/.helm
```

Установка postgres и настройка order-app
```shell
cd order
helm install order-db bitnami/postgresql -f database/postgres/config.yaml
helm install order-app application/.helm
```

Установка postgres и настройка notification-app
```shell
cd notification
helm install notification-db bitnami/postgresql -f database/postgres/config.yaml
helm install notification-app application/.helm
```

Настройка Api Gateway
```shell
kubectl apply -f api-gateway/ingress.yaml
```

### Тестирование

Запуск Postman по тестовому сценарию

```shell
bash .postman-test.sh
```


### Мониторинг

Установка Grafana
```shell
cd monitoring
helm install prom prometheus-community/kube-prometheus-stack -f k8s-prometheus.yaml --atomic
kubectl port-forward service/prom-grafana 9000:80 # expose grafana (pass: prom-operator)
```