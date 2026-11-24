# Lab 7.3 – Lösung: NodePort für das Frontend

Alle Befehle laufen im Ordner `project/`. IPs, Zeiten und Endungen weichen im eigenen Cluster ab.

## Aufgabe 1: NodePort-Service anlegen

```bash
cp starters/m07-l03-frontend-service.yaml playground/k8s/40-frontend-service.yaml
```

Ergänzte Zeilen:

```yaml
spec:
  type: NodePort
  selector:
    app: hello-frontend
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      nodePort: 30080
```

```bash
kubectl apply -f playground/k8s/40-frontend-service.yaml
kubectl get services
```

```text
service/frontend created
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
backend    ClusterIP   10.106.45.17    <none>        80/TCP         25m
frontend   NodePort    10.104.12.200   <none>        80:30080/TCP   4s
```

`80:30080/TCP`: Im Cluster ist das Frontend unter `http://frontend:80` erreichbar, von außen über Port 30080 auf jedem Node.

## Aufgabe 2: Seite über den NodePort

`http://localhost:30080` zeigt die hellblaue Hello-Seite:

```text
Hello-App v1
Frontend: frontend (10.1.0.27)
Backend: backend-2 (10.1.0.26) um 10:31:12
Admin: kein Passwort gesetzt
```

Beim Neuladen wechselt weiter der Backend-Pod; der Frontend-Pod bleibt gleich, weil es nur einen gibt. Docker Desktop leitet Port 30080 des Nodes `docker-desktop` auf den Laptop weiter (Stand: 24.11.2026, prüfen).

## Aufgabe 3: Port-Forward beenden

Nach **Strg+C** im Port-Forward-Terminal:

| Adresse | Ergebnis | Grund |
| --- | --- | --- |
| `http://localhost:8080` | `ERR_CONNECTION_REFUSED` | der Tunnel lief nur, solange `kubectl port-forward` lief |
| `http://localhost:30080` | Hello-Seite | der Service existiert im Cluster, unabhängig von einem Terminal |

Port-Forward ist ein persönlicher Test-Tunnel mit eigener kubeconfig; der NodePort ist ein dauerhafter Zugang über das Netz, für alle, die den Node erreichen.

## Aufgabe 4: Frontend-Pod ersetzen

```bash
kubectl delete pod frontend
kubectl apply -f playground/k8s/30-frontend-pod.yaml
kubectl get endpointslices -l kubernetes.io/service-name=frontend
```

```text
pod "frontend" deleted
pod/frontend created
NAME             ADDRESSTYPE   PORTS   ENDPOINTS   AGE
frontend-k8p2m   IPv4          80      10.1.0.28   9m
```

`http://localhost:30080` antwortet nach wenigen Sekunden wieder, jetzt mit `Frontend: frontend (10.1.0.28)`. Der Service hat den neuen Pod über den Selector `app: hello-frontend` gefunden; ein Port-Forward auf `pod/frontend` hätte neu gestartet werden müssen.

## Aufgabe 5: Services im Dashboard

Dashboard > Namespace `hello` > **Service** > **Services**:

| Name | Typ | Cluster IP | Internal Endpoints |
| --- | --- | --- | --- |
| `backend` | ClusterIP | `10.106.45.17` | `backend.hello:80 TCP` |
| `frontend` | NodePort | `10.104.12.200` | `frontend.hello:80 TCP`, `frontend.hello:30080 TCP` |

Ein Klick auf `frontend` zeigt Selector `app: hello-frontend` und unten den Pod `frontend`; dieselben Angaben liefert `kubectl describe service frontend`.

## Fallback: LoadBalancer statt NodePort

```yaml
spec:
  type: LoadBalancer
  selector:
    app: hello-frontend
  ports:
    - port: 8080
      targetPort: 80
      protocol: TCP
```

```bash
kubectl delete service frontend
kubectl apply -f playground/k8s/40-frontend-service.yaml
kubectl get service frontend
```

```text
NAME       TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
frontend   LoadBalancer   10.104.12.201   localhost     8080:31847/TCP   5s
```

Docker Desktop meldet `EXTERNAL-IP localhost`; die Seite ist unter `http://localhost:8080` erreichbar.
