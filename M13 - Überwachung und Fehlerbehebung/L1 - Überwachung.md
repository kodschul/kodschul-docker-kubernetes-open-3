## Kubernetes: Überwachung von Kubernetes-Clustern mit kubectl und Kubernetes-Dashboard

Kubernetes ist eine Open-Source-Plattform zur Automatisierung der Bereitstellung, Skalierung und Verwaltung von Containeranwendungen. Die Überwachung von Kubernetes-Clustern ist entscheidend, um die Gesundheit und Leistung Ihrer Anwendungen sicherzustellen. Hier sind einige Methoden zur Überwachung von Kubernetes-Clustern mit `kubectl` und dem Kubernetes-Dashboard:

### Verwendung von kubectl

1. **Status des Clusters anzeigen:**
```bash
   kubectl cluster-info
```
2. Knotenstatus überprüfen:
```bash
   kubectl get nodes
```
3. Pods im Cluster auflisten:
```bash
   kubectl get pods --all-namespaces
```
4. Logs eines Pods anzeigen:
```bash
   kubectl logs <pod_name>
```
5. Ressourcennutzung eines Pods überwachen:
```bash
   kubectl top pod <pod_name>
```
### Verwendung des Kubernetes-Dashboards
Das Kubernetes-Dashboard installieren:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
```
Das Dashboard starten:
```bash
kubectl proxy
```
Das Dashboard im Browser öffnen:
Öffnen Sie http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ in Ihrem Browser und verwenden Sie das Bearer-Token zur Authentifizierung.