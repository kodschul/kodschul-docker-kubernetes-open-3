## Kubernetes: Verwendung von Konfigurationsdateien (YAML) für die Definition von Kubernetes-Ressourcen

Kubernetes verwendet YAML-Dateien zur Definition von Ressourcen wie Pods, Services, Deployments usw. Diese YAML-Dateien sind eine deklarative Möglichkeit, die gewünschten Zustände der Kubernetes-Ressourcen zu beschreiben. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zur Verwendung von Konfigurationsdateien (YAML) für die Definition von Kubernetes-Ressourcen:

### Beispiel 1: Pod-Definition

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
```

Dieses YAML-Beispiel definiert einen einfachen Pod mit dem Namen "nginx-pod", der einen Nginx-Container verwendet, der auf Port 80 läuft.

### Beispiel 2: Service-Definition

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

Dieses YAML-Beispiel definiert einen Service mit dem Namen "nginx-service", der auf Pods mit dem Label "app: nginx" abzielt und eingehenden Datenverkehr auf Port 80 an diese Pods weiterleitet.

### Beispiel 3: Deployment-Definition

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
```

Dieses YAML-Beispiel definiert ein Deployment mit dem Namen "nginx-deployment", das drei Replikas des Nginx-Pods bereitstellt.