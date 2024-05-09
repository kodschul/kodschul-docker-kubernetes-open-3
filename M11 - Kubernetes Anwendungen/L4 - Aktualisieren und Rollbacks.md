# Kubernetes: Aktualisieren und Rollbacks von Anwendungen

In Kubernetes können Anwendungen mithilfe von Deployments aktualisiert und zurückgerollt werden. Dies ermöglicht eine einfache Verwaltung von Updates und die Rückkehr zu früheren Versionen im Falle von Problemen. Im Folgenden sind grundlegende Konzepte und Beispiele für das Aktualisieren und Rollbacks von Anwendungen in Kubernetes aufgeführt:

## Aktualisieren von Anwendungen

1. **Ändern der Anwendungsspezifikationen**: Aktualisieren Sie die Spezifikationen Ihrer Anwendung, z. B. Docker-Image-Tags oder Ressourcenlimits, in der Deploymentkonfiguration.

2. **Anwendung neu bereitstellen**: Wenden Sie die aktualisierten Spezifikationen an, indem Sie das Deployment aktualisieren:

   ```bash
   kubectl apply -f deployment.yaml
    ```

3. **Überwachen des Aktualisierungsfortschritts**: Verwenden Sie kubectl rollout status oder das Kubernetes-Dashboard, um den Fortschritt der Aktualisierung zu überwachen.

## Rollbacks von Anwendungen
Überprüfen des Rollback-Verlaufs: Zeigen Sie den Rollback-Verlauf des Deployments an, um verfügbare Revisionen zu sehen:

```bash
   kubectl rollout history deployment/<deployment-name>
```
Rollback auf eine frühere Revision: Wenden Sie das Deployment auf eine frühere Revision an:
```bash
   kubectl rollout undo deployment/<deployment-name> --to-revision=<revision-number>

```
Überwachen des Rollback-Fortschritts: Verwenden Sie kubectl rollout status oder das Kubernetes-Dashboard, um den Fortschritt des Rollbacks zu überwachen.
```bash
   kubectl apply -f deployment.yaml
```

## Beispiel: Aktualisieren und Rollback eines Deployments

```yaml
   apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: example-container
        image: example/image:latest   # Aktualisiere das Docker-Image
        ports:
        - containerPort: 80
```

In diesem Beispiel wird ein Deployment namens example-app definiert. Um die Anwendung zu aktualisieren, ändern Sie einfach das Docker-Image und wenden Sie das aktualisierte Deployment an. Wenn Probleme auftreten, können Sie das Deployment auf eine frühere Revision zurückrollen.