# Lab 8.2 – Lösung: Deployments: Rollout und Rollback

Alle Befehle laufen im Ordner `project/`. Hash-Werte in Namen, IPs und Zeiten weichen im eigenen Cluster ab.

## Aufgabe 1: Einzelobjekte abräumen

```bash
kubectl delete rs hello-frontend
kubectl delete pod backend backend-2
rm playground/k8s/*-pod.yaml playground/k8s/30-frontend-replicaset.yaml
```

```text
replicaset.apps "hello-frontend" deleted
pod "backend" deleted
pod "backend-2" deleted
```

Das Löschen des ReplicaSets löscht auch seine Pods. Bis Aufgabe 2 angewendet ist, antwortet `http://localhost:30080` nicht: Der Service `frontend` hat gerade keine Pods.

## Aufgabe 2: Deployments anlegen

```bash
cp starters/m08-l02-backend-deployment.yaml playground/k8s/10-backend-deployment.yaml
cp starters/m08-l02-frontend-deployment.yaml playground/k8s/30-frontend-deployment.yaml
```

Ergänzte Stellen in `playground/k8s/30-frontend-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-frontend
  labels:
    app: hello-frontend
    tier: frontend
  annotations:
    kubernetes.io/change-cause: "Start mit v1"
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
  ...
```

```bash
kubectl apply -f playground/k8s/
kubectl get deploy,rs,pods
```

```text
namespace/hello unchanged
deployment.apps/hello-backend created
service/backend unchanged
deployment.apps/hello-frontend created
service/frontend unchanged

NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/hello-backend    2/2     2            2           8s
deployment.apps/hello-frontend   3/3     3            3           8s

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/hello-backend-6c8d9f7b5d    2         2         2       8s
replicaset.apps/hello-frontend-7d9c5b8f6b   3         3         3       8s

NAME                                  READY   STATUS    RESTARTS   AGE
pod/hello-backend-6c8d9f7b5d-4tq9w    1/1     Running   0          8s
pod/hello-backend-6c8d9f7b5d-n7xkp    1/1     Running   0          8s
pod/hello-frontend-7d9c5b8f6b-m8vtl   1/1     Running   0          8s
pod/hello-frontend-7d9c5b8f6b-q4zrn   1/1     Running   0          8s
pod/hello-frontend-7d9c5b8f6b-x2kqp   1/1     Running   0          8s
```

Die Zeilen für Namespace und Services hängen von den Dateinamen aus Modul 7 ab. Die Seite unter `http://localhost:30080`:

```text
Hello-App v1
Frontend: hello-frontend-7d9c5b8f6b-q4zrn (10.1.0.41)
Backend: hello-backend-6c8d9f7b5d-4tq9w (10.1.0.39) um 14:12:03
Admin: kein Passwort gesetzt
```

## Aufgabe 3: Rollout auf v2

Geänderte Zeilen in `playground/k8s/30-frontend-deployment.yaml`:

```yaml
  annotations:
    kubernetes.io/change-cause: "Update auf v2"
...
      labels:
        app: hello-frontend
        tier: frontend
        version: v2
...
          image: hello-frontend:v2
```

```bash
kubectl get pods -l app=hello-frontend -w            # zweites Terminal
kubectl apply -f playground/k8s/30-frontend-deployment.yaml
kubectl rollout status deployment/hello-frontend
kubectl get rs -l app=hello-frontend
```

Watch-Terminal (gekürzt):

```text
hello-frontend-5f6b8c4d7c-9vk2m   0/1     Pending             0          0s
hello-frontend-5f6b8c4d7c-9vk2m   0/1     ContainerCreating   0          0s
hello-frontend-5f6b8c4d7c-9vk2m   1/1     Running             0          1s
hello-frontend-7d9c5b8f6b-m8vtl   1/1     Terminating         0          4m
hello-frontend-5f6b8c4d7c-h7xqt   0/1     Pending             0          0s
hello-frontend-5f6b8c4d7c-h7xqt   1/1     Running             0          1s
hello-frontend-7d9c5b8f6b-q4zrn   1/1     Terminating         0          4m
hello-frontend-5f6b8c4d7c-t4wpl   0/1     Pending             0          0s
hello-frontend-5f6b8c4d7c-t4wpl   1/1     Running             0          1s
hello-frontend-7d9c5b8f6b-x2kqp   1/1     Terminating         0          4m
```

```text
deployment.apps/hello-frontend configured
Waiting for deployment "hello-frontend" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "hello-frontend" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "hello-frontend" rollout to finish: 1 old replicas are pending termination...
deployment "hello-frontend" successfully rolled out
NAME                        DESIRED   CURRENT   READY   AGE
hello-frontend-5f6b8c4d7c   3         3         3       15s
hello-frontend-7d9c5b8f6b   0         0         0       5m
```

Jeder neue Pod läuft, bevor ein alter endet (`maxUnavailable: 0`), und es sind nie mehr als vier Pods (`maxSurge: 1`). Während des Rollouts wechselt die Seite zwischen hellblau `v1` und hellgrün `v2`, danach bleibt sie grün.

## Aufgabe 4: kaputter Rollout auf v3

```bash
kubectl set image deployment/hello-frontend frontend=hello-frontend:v3
kubectl annotate deployment/hello-frontend kubernetes.io/change-cause="Update auf v3" --overwrite
kubectl rollout status deployment/hello-frontend --timeout=30s
kubectl get pods -l app=hello-frontend
```

```text
deployment.apps/hello-frontend image updated
deployment.apps/hello-frontend annotated
Waiting for deployment "hello-frontend" rollout to finish: 1 out of 3 new replicas have been updated...
error: timed out waiting for the condition
NAME                              READY   STATUS              RESTARTS   AGE
hello-frontend-5f6b8c4d7c-9vk2m   1/1     Running             0          4m
hello-frontend-5f6b8c4d7c-h7xqt   1/1     Running             0          4m
hello-frontend-5f6b8c4d7c-t4wpl   1/1     Running             0          4m
hello-frontend-6b7d9f5c8d-r2nzx   0/1     ErrImageNeverPull   0          35s
```

`kubectl describe pod hello-frontend-6b7d9f5c8d-r2nzx` nennt den Grund in den Events:

```text
  Warning  ErrImageNeverPull  10s (x4 over 35s)  kubelet  Container image "hello-frontend:v3" is not present with pull policy of Never
```

Der neue Pod wird nie bereit; wegen `maxUnavailable: 0` bleiben alle drei `v2`-Pods. Die Seite lädt weiter grün mit `v2`. `frontend=` in `set image` ist der Containername aus dem Template.

## Aufgabe 5: Rollback

```bash
kubectl rollout undo deployment/hello-frontend
kubectl rollout status deployment/hello-frontend
kubectl rollout history deployment/hello-frontend
```

```text
deployment.apps/hello-frontend rolled back
deployment "hello-frontend" successfully rolled out
deployment.apps/hello-frontend
REVISION  CHANGE-CAUSE
1         Start mit v1
3         Update auf v3
4         Update auf v2
```

Revision 2 (`v2`) ist als Revision 4 zurückgekommen; der `v3`-Pod ist gelöscht. Die Datei enthält weiterhin `v2`, weil `v3` nur per Befehl kam:

```bash
kubectl apply -f playground/k8s/30-frontend-deployment.yaml
kubectl rollout history deployment/hello-frontend
```

```text
deployment.apps/hello-frontend configured
deployment.apps/hello-frontend
REVISION  CHANGE-CAUSE
1         Start mit v1
3         Update auf v3
4         Update auf v2
```

Keine neue Revision: Das Template in der Datei entspricht dem laufenden Stand. `configured` statt `unchanged` erscheint, weil `kubectl apply` seine Notiz über den zuletzt angewendeten Stand aktualisiert.
