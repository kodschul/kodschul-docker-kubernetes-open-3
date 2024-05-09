# Kubernetes: Erstellen und Verwalten von Pods

In Kubernetes ist ein Pod die kleinste ausführbare Einheit, die eine oder mehrere Container enthält. In diesem Leitfaden werden grundlegende Konzepte und Schritte zum Erstellen und Verwalten von Pods in Kubernetes erläutert.

## Grundlagen

Ein Pod ist eine Gruppe von einem oder mehreren Containern, die eng miteinander verbunden sind und gemeinsam Ressourcen wie Netzwerk oder Speicher teilen. Hier sind einige grundlegende Konzepte:

- **Container**: Ein Container ist eine lauffähige Instanz einer Docker-Image-Datei.
- **Pod**: Ein Pod ist eine Gruppe von Containern, die gemeinsam auf einem gemeinsamen Netzwerk und Dateisystem ausgeführt werden.

## Erstellen eines Pods

Ein Pod wird in Kubernetes mithilfe einer YAML-Datei definiert. Hier ist ein einfaches Beispiel für einen Pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
    - name: nginx-container
      image: nginx
```

In diesem YAML-Dokument wird ein Pod mit einem einzelnen Container definiert, der das Nginx-Image verwendet.

## Verwalten von Pods
Nachdem ein Pod erstellt wurde, können verschiedene Aktionen darauf ausgeführt werden, wie z.B. das Abrufen von Informationen, das Aktualisieren oder Löschen des Pods.

### Informationen über einen Pod abrufen
Um Informationen über einen Pod abzurufen, verwenden Sie den Befehl kubectl describe pod <pod-name>:

```bash
kubectl describe pod nginx-pod
```

## Pods auflisten
Um eine Liste aller Pods im Cluster anzuzeigen, verwenden Sie den Befehl kubectl get pods:

```bash
kubectl get pods
```

## Einen Pod löschen
Um einen Pod zu löschen, verwenden Sie den Befehl kubectl delete pod <pod-name>:

```bash
kubectl delete pod nginx-pod
```
