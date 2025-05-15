# Реализация GitOps-пайплайна с Argo CD в VK Cloud (или любом другом облаке). 

Дока ArgoCD: https://argo-cd.readthedocs.io/en/stable/

**Инструменты**:  
- Kubernetes-кластер в VK Cloud (Managed Kubernetes или развернутый вручную).  
- Git-репозиторий (например, GitHub, GitLab или внутренний репозиторий VK Cloud).  
- Argo CD (устанавливается в кластер).


## Примерный план

### **1. Подготовка инфраструктуры**
- **Задача**: Создать Kubernetes-кластер в VK Cloud.  
  - Используйте Managed Kubernetes (если доступно) или разверните кластер через интерфейс VK Cloud.  
  - Убедитесь, что `kubectl` настроен для доступа к кластеру.

### **2. Установка Argo CD**

```bash
# Установите Argo CD в кластер
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Получите доступ к Argo CD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
- **Проверка**: Откройте `https://localhost:8080` в браузере. Логин: `admin`, пароль можно получить командой:
  ```bash
  kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  ```

### **3. Настройка Git-репозитория**
- **Задача**: Создать Git-репозиторий с конфигурацией приложения.  
  Пример структуры:
  ```
  my-app/
  ├── k8s/
  │   ├── deployment.yaml
  │   ├── service.yaml
  │   └── ingress.yaml
  └── README.md
  ```
Пример git-репозитория с манифестами: https://github.com/DariaMinina/argocd-demo-app.git

- Убедитесь, что манифесты корректны (например, указан образ контейнера).

### **4. Создание Application в Argo CD**
- **Задача**: Настроить синхронизацию между Git-репозиторием и кластером.  
  Создайте YAML-файл `my-app-application.yaml`:
  ```yaml
  apiVersion: argoproj.io/v1alpha1
  kind: Application
  metadata:
    name: my-app
    namespace: argocd
  spec:
    project: default
    source:
      repoURL: https://github.com/DariaMinina/argocd-demo-app.git
      targetRevision: main
      path: k8s/  # Путь к манифестам в репозитории
    destination:
      server: https://kubernetes.default.svc
      namespace: my-app-ns
    syncPolicy:
      automated:
        selfHeal: true  # Автоматически исправлять расхождения
        prune: true     # Удалять ресурсы, удаленные из Git
  ```
- Примените конфигурацию:
  ```bash
  kubectl apply -f my-app-application.yaml
  ```

### **5. Автоматическая синхронизация через Webhook** (сначала попробуйте без этого шага)
- **Задача**: Настроить автоматический триггер при изменении Git-репозитория.  
  - В Argo CD UI перейдите в настройки приложения и включите **Auto-Sync**.  
  - Для GitHub/GitLab:  
    - Добавьте webhook в репозиторий:  
      URL: `https://<argocd-server>/api/webhook` (если Argo CD доступен публично).  
      Секрет: Укажите токен из настроек Argo CD.  


### **6. Расширенные настройки (опционально)**
- **Уведомления**: Настройте интеграцию с Slack/Telegram для оповещений о статусе деплоя.  
- **Роллбек**: Если деплой неудачен, откатитесь через Argo CD UI или командой:
  ```bash
  argocd app rollback my-app <commit-hash>
  ```

---

### **Типичные проблемы и решения**:
1. **Argo CD не видит репозиторий**:  
   - Проверьте URL и токены доступа.  
   - Убедитесь, что репозиторий публичный или добавлен SSH-ключ в настройках Argo CD.  

2. **Синхронизация не запускается**:  
   - Включите **Auto-Sync** в настройках приложения.  
   - Проверьте webhook-запросы в истории Git-репозитория.  

3. **Доступ к Argo CD UI**:

#### **1. Обновите сервис argocd-server**
Измените тип сервиса на `LoadBalancer`:
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
#### **2. Получите внешний IP-адрес**

```
kubectl get svc -n argocd argocd-server

```

Дождитесь, когда в поле `EXTERNAL-IP` появится адрес.

#### **3. Откройте Argo CD UI**

Перейдите по адресу `https://<EXTERNAL-IP>`. Логин: `admin`, пароль можно получить командой:

```
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
