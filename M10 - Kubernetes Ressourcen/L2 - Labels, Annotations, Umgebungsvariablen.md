# Kubernetes: Anpassen von Ressourcenkonfigurationen

In Kubernetes können Ressourcenkonfigurationen wie Pods, Deployments und Services durch die Verwendung von Labels, Annotations und Umgebungsvariablen angepasst werden. Diese Mechanismen bieten eine flexible Möglichkeit, Metadaten hinzuzufügen und das Verhalten von Anwendungen zu steuern. Im Folgenden sind einige grundlegende Konzepte und Beispiele zur Anpassung von Ressourcenkonfigurationen in Kubernetes:

## Labels

Labels sind Key-Value-Paare, die Ressourcen in Kubernetes markieren und kategorisieren. Sie werden verwendet, um Ressourcen zu identifizieren und Gruppen von Ressourcen zu erstellen. Labels können verwendet werden, um Ressourcen für das Routing, die Selektion und das Management zu organisieren.

Beispiel:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
  labels:
    app: frontend
    tier: production
spec:
  containers:
  - name: mycontainer
    image: nginx
```

In diesem Beispiel wird ein Pod mit den Labels "app: frontend" und "tier: production" erstellt. Diese Labels können verwendet werden, um den Pod für Anfragen zu selektieren oder für die Anwendung von Richtlinien.

## Annotations
Annotations sind zusätzliche Metadaten, die Ressourcen beschreiben oder erweiterte Konfigurationen bereitstellen. Im Gegensatz zu Labels werden Annotations nicht für die Selektion von Ressourcen verwendet, sondern enthalten allgemeine Informationen oder Konfigurationen.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myservice
  annotations:
    description: "My Service"
    version: "1.0"
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080

```

In diesem Beispiel wird ein Service mit Annotations für die Beschreibung und die Version erstellt. Diese Annotations können für Dokumentationszwecke oder für die Konfiguration von Load Balancern verwendet werden.

## Umgebungsvariablen
Umgebungsvariablen sind Werte, die in Containern innerhalb von Pods verfügbar sind. Sie ermöglichen die Konfiguration von Anwendungen zur Laufzeit und die Bereitstellung von Informationen, die von der Umgebung abhängen.


```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mycontainer
    image: myapp
    env:
      - name: DB_HOST
        value: "mysql.example.com"
      - name: DB_PORT
        value: "3306"
```

In diesem Beispiel wird ein Pod mit einem Container erstellt, der Umgebungsvariablen für die Datenbankverbindung konfiguriert. Diese Umgebungsvariablen werden von der Anwendung verwendet, um auf die richtige Datenbank zuzugreifen.