# Установка Prometheus
```
cd /helms

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update 
helm pull prometheus-community/prometheus 
tar zxf prometheus-27.12.0.tgz
rm prometheus-27.12.0.tgz -f 
cp prometheus/values.yaml prometheus-values.yaml 
subl prometheus-values.yaml

helm upgrade --install --create-namespace --values prometheus-values.yaml prometheus -n monitoring prometheus-community/prometheus \
  --set alertmanager.enabled=false \
  --set pushgateway.enabled=false \
  --set server.persistentVolume.enabled=false

```
# GRAFANA

```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm pull grafana/grafana 
tar zxf grafana-8.14.2.tgz 
rm grafana-8.14.2.tgz -f
cp grafana/values.yaml grafana-values.yaml 

subl grafana-values.yaml

persistence 
необходимо поставить в положение true иначе после смерти пода все настройки сбросятся
persistence:
type: pvc enabled: true

helm upgrade --install --create-namespace --values grafana-values.yaml grafana -n monitoring grafana/grafana


kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
OgV1dUpgBdMvGNJlYQMIryrwNDmT0fN6dshcXsvt
```

# Установка Trickster
```
helm repo add tricksterproxy https://helm.tricksterproxy.io
helm repo update
helm pull tricksterproxy/trickster 
tar zxf trickster-1.5.4.tgz 
rm trickster-1.5.4.tgz -f 
cp trickster/values.yaml trickster-values.yaml 

subl trickster-values.yaml

helm upgrade --install --create-namespace --values trickster-values.yaml trickster -n monitoring tricksterproxy/trickster

```

# Добавление репозитория Helm

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

# Установка ingress controller с параметрами для VK Cloud

```
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer \
  --set controller.service.externalTrafficPolicy=Local
```

# Добавление ingress для Grafana

```
apiVersion: networking.k8s.io/v1
kind: Ingress 
metadata:
  annotations:
    cert-manager.io/issuer: gitlab-issuer
    kubernetes.io/ingress.class: nginx
  name: grafana
  namespace: monitoring
spec:
  rules:
  - host: monitoring.89-208-86-40.sslip.io # вот здесь записываете <EXTERNAL-IP> в формате через дефис
    http:
      paths:
      - backend:
          service:
            name: grafana
            port:
              number: 80
        path: / 
        pathType: Prefix
```


# Дашборды Grafana для пробы

- 1860
- 9614
- 2842
- 315



