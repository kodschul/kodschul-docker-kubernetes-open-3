# Lab 7.1 – Lösung: Pods

Alle Befehle laufen im Ordner `project/`. IPs, Zeiten und Pod-Alter weichen im eigenen Cluster ab.

## Aufgabe 1: Backend-Pod anlegen

```bash
cp starters/m07-l01-backend-pod.yaml playground/k8s/10-backend-pod.yaml
```

`playground/k8s/10-backend-pod.yaml` nach dem Ergänzen:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: backend
  labels:
    app: hello-backend
    tier: backend
    version: v1
spec:
  containers:
    - name: backend
      image: hello-backend:v1
      imagePullPolicy: Never
      ports:
        - containerPort: 80
```

```bash
kubectl apply -f playground/k8s/10-backend-pod.yaml
kubectl get pods -o wide
```

```text
pod/backend created
NAME      READY   STATUS    RESTARTS   AGE   IP          NODE             NOMINATED NODE   READINESS GATES
backend   1/1     Running   0          5s    10.1.0.23   docker-desktop   <none>           <none>
```

Ohne `imagePullPolicy: Never` nutzt Kubernetes bei Tag `v1` `IfNotPresent`; das klappt meist auch, versucht aber einen Download von Docker Hub, sobald das Image auf dem Node fehlt.

## Aufgabe 2: Frontend-Pod mit BACKEND_URL

```bash
cp starters/m07-l01-frontend-pod.yaml playground/k8s/30-frontend-pod.yaml
```

Ergänzte Zeilen am Ende von `playground/k8s/30-frontend-pod.yaml`:

```yaml
      env:
        - name: BACKEND_URL
          value: "http://10.1.0.23"    # eigene Backend-IP aus Aufgabe 1
```

```bash
kubectl apply -f playground/k8s/30-frontend-pod.yaml
kubectl get pods --show-labels
kubectl get pods -l app=hello-backend
```

```text
pod/frontend created
NAME       READY   STATUS    RESTARTS   AGE   LABELS
backend    1/1     Running   0          2m    app=hello-backend,tier=backend,version=v1
frontend   1/1     Running   0          6s    app=hello-frontend,tier=frontend,version=v1
NAME      READY   STATUS    RESTARTS   AGE
backend   1/1     Running   0          2m
```

## Aufgabe 3: Port-Forward, describe und logs

Zweites Terminal:

```bash
kubectl port-forward pod/frontend 8080:80
```

```text
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
```

`http://localhost:8080` zeigt auf hellblauem Hintergrund:

```text
Hello-App v1
Frontend: frontend (10.1.0.24)
Backend: backend (10.1.0.23) um 09:42:03
Admin: kein Passwort gesetzt
```

„kein Passwort gesetzt" ist richtig so; das Passwort kommt in Lab 9.2.

```bash
kubectl describe pod frontend
```

```text
Name:             frontend
Namespace:        hello
Node:             docker-desktop/192.168.65.3
Labels:           app=hello-frontend
                  tier=frontend
                  version=v1
Status:           Running
IP:               10.1.0.24
Containers:
  frontend:
    Image:          hello-frontend:v1
    Port:           80/TCP
    State:          Running
    Ready:          True
    Restart Count:  0
    Environment:
      BACKEND_URL:  http://10.1.0.23
…
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  2m    default-scheduler  Successfully assigned hello/frontend to docker-desktop
  Normal  Pulled     2m    kubelet            Container image "hello-frontend:v1" already present on machine
  Normal  Created    2m    kubelet            Created container: frontend
  Normal  Started    2m    kubelet            Started container frontend
```

Die Events zeigen den Weg aus der Theorie: Der Scheduler teilt zu, das kubelet findet das lokale Image und startet den Container.

```bash
kubectl logs backend
```

```text
Hello-Backend v1 auf Port 80
 * Serving Flask app 'app'
 * Debug mode: off
…
 * Running on http://10.1.0.23:80
Press CTRL+C to quit
10.1.0.24 - - [24/Nov/2026 09:42:03] "GET / HTTP/1.1" 200 -
```

Die Anfrage kommt von `10.1.0.24`, der IP des Frontend-Pods.

## Aufgabe 4: Backend neu anlegen

```bash
kubectl delete pod backend
kubectl apply -f playground/k8s/10-backend-pod.yaml
kubectl get pods -o wide
```

```text
pod "backend" deleted
pod/backend created
NAME       READY   STATUS    RESTARTS   AGE   IP          NODE             NOMINATED NODE   READINESS GATES
backend    1/1     Running   0          4s    10.1.0.25   docker-desktop   <none>           <none>
frontend   1/1     Running   0          6m    10.1.0.24   docker-desktop   <none>           <none>
```

Die Seite meldet nach dem Neuladen:

```text
Backend: Backend nicht erreichbar (http://10.1.0.23): ConnectTimeout
```

Je nach Netz steht dort auch `ConnectionError`. Das Frontend fragt weiter die alte IP, unter der kein Pod mehr antwortet. Von Hand nachziehen hieße: neue IP eintragen, Frontend-Pod löschen und neu anlegen, bei jedem Neustart des Backends wieder. Lab 7.2 löst das mit einem Service.

## Aufgabe 5: Pods im Dashboard

Drittes Terminal: `kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443`, Token bei Bedarf mit `kubectl -n kubernetes-dashboard create token admin-user` neu erzeugen, `https://localhost:8443` öffnen und anmelden. Namespace oben auf `hello`, dann **Workloads** > **Pods**: Die Liste zeigt `backend` und `frontend` mit Status `Running`, Node `docker-desktop` und je drei Label-Chips (`app`, `tier`, `version`). Ein Klick auf `frontend` zeigt dieselbe Umgebungsvariable und dieselben Events wie `kubectl describe`.
