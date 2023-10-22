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
kubectl create namespace otus-hw06
```

Выбор созданного namespace

```shell
kubectl config set-context --current --namespace=otus-hw06
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