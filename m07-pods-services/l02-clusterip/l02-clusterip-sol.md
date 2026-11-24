# Lab 7.2 – Lösung: Service für das Backend

Alle Befehle laufen im Ordner `project/`. IPs, Zeiten und Endungen weichen im eigenen Cluster ab.

## Aufgabe 1: Zweiter Backend-Pod

```bash
cp playground/k8s/10-backend-pod.yaml playground/k8s/11-backend-2-pod.yaml
```

Geänderte Zeile in `playground/k8s/11-backend-2-pod.yaml`:

```yaml
metadata:
  name: backend-2              # vorher: backend; Labels bleiben gleich
```

```bash
kubectl apply -f playground/k8s/11-backend-2-pod.yaml
kubectl get pods -l app=hello-backend -o wide
```

```text
pod/backend-2 created
NAME        READY   STATUS    RESTARTS   AGE   IP          NODE             NOMINATED NODE   READINESS GATES
backend     1/1     Running   0          12m   10.1.0.25   docker-desktop   <none>           <none>
backend-2   1/1     Running   0          5s    10.1.0.26   docker-desktop   <none>           <none>
```

Beide Pods tragen `app=hello-backend`; der Selektor `-l` findet sie unabhängig vom Namen.

## Aufgabe 2: Service anlegen

```bash
cp starters/m07-l02-backend-service.yaml playground/k8s/20-backend-service.yaml
```

Ergänzte Zeilen:

```yaml
spec:
  type: ClusterIP
  selector:
    app: hello-backend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

```bash
kubectl apply -f playground/k8s/20-backend-service.yaml
kubectl get service backend
kubectl get endpointslices -l kubernetes.io/service-name=backend
```

```text
service/backend created
NAME      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
backend   ClusterIP   10.106.45.17   <none>        80/TCP    3s
NAME            ADDRESSTYPE   PORTS   ENDPOINTS             AGE
backend-7xk2p   IPv4          80      10.1.0.25,10.1.0.26   3s
```

Die zwei Endpoints sind genau die IPs aus Aufgabe 1.

## Aufgabe 3: Frontend über den Service-Namen

Geänderte Zeilen in `playground/k8s/30-frontend-pod.yaml`:

```yaml
      env:
        - name: BACKEND_URL
          value: "http://backend"      # vorher: http://<Pod-IP>
```

```bash
kubectl delete pod frontend
kubectl apply -f playground/k8s/30-frontend-pod.yaml
```

```text
pod "frontend" deleted
pod/frontend created
```

Das Port-Forward im zweiten Terminal endete mit dem alten Pod; neu starten:

```bash
kubectl port-forward pod/frontend 8080:80
```

Mehrmals neu geladen zeigt `http://localhost:8080` wechselnde Backend-Pods:

```text
Backend: backend (10.1.0.25) um 10:14:31
Backend: backend-2 (10.1.0.26) um 10:14:33
Backend: backend-2 (10.1.0.26) um 10:14:34
Backend: backend (10.1.0.25) um 10:14:36
```

Die Reihenfolge ist zufällig; kube-proxy wählt je Verbindung einen Endpoint. Die Zeile **Frontend** bleibt gleich, weil das Port-Forward fest am Pod `frontend` hängt.

## Aufgabe 4: DNS prüfen

```bash
kubectl exec frontend -- nslookup backend
kubectl exec frontend -- wget -qO- http://backend.hello.svc.cluster.local/api
```

```text
Server:		10.96.0.10
Address:	10.96.0.10:53

Name:	backend.hello.svc.cluster.local
Address: 10.106.45.17

{"ip":"10.1.0.25","pod":"backend","time":"10:15:02","version":"v1"}
```

- `10.96.0.10` ist die Adresse von CoreDNS im Cluster.
- Der kurze Name `backend` wird über die Suchliste des Pods zum vollständigen Namen `backend.hello.svc.cluster.local`, die Antwort ist die ClusterIP aus Aufgabe 2, nicht eine Pod-IP.
- Der Pfad `/api` liefert dieselbe JSON-Antwort wie `/`.

## Aufgabe 5: Falscher Selector

Selector in `playground/k8s/20-backend-service.yaml` auf `app: hello-backnd` ändern:

```bash
kubectl apply -f playground/k8s/20-backend-service.yaml
kubectl get endpointslices -l kubernetes.io/service-name=backend
```

```text
service/backend configured
NAME            ADDRESSTYPE   PORTS     ENDPOINTS   AGE
backend-7xk2p   IPv4          <unset>   <unset>     4m
```

Die Hello-Seite meldet:

```text
Backend: Backend nicht erreichbar (http://backend): ConnectionError
```

Der Name `backend` löst weiter auf, aber hinter der ClusterIP steht kein Pod. Diagnose: `kubectl describe service backend` zeigt `Selector: app=hello-backnd`, `kubectl get pods --show-labels` zeigt `app=hello-backend`. Nach der Korrektur auf `app: hello-backend` und erneutem `apply` listet die EndpointSlice wieder beide IPs, und die Seite zeigt wieder Backend-Antworten.
