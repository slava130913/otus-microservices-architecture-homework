## Установка

Настройка Istio

```shell
istioctl install --set profile.html=default -y
```

Настройка развертывания приложений
```shell
./launch.sh
```

### Prometheus

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install --version 32.0.0 -n monitoring --create-namespace prometheus prometheus-community/kube-prometheus-stack
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
```

### Kiali

```shell
helm repo add kiali https://kiali.org/helm-charts
helm repo update
helm install --set auth.strategy="anonymous" kiali-server kiali/kiali-server --version 1.46.0 --namespace istio-system
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml
```

### Дополнительно

Добавьте SideCar в модули мониторинга пространства имен.

```shell
kubectl label namespace monitoring istio-injection=enabled --overwrite
```

### Отправить запросы

Получить доступ к сервису

```shell
minikube service -n istio-system istio-ingressgateway
```

Отправьте несколько запросов (просто обновите страницу)

### Результат

```shell
istioctl dashboard kiali
```

Скриншот управления трафиком

![](kiali-dashboard.png)