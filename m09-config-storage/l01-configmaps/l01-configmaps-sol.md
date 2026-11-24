# Lab 9.1 – Lösung: ConfigMaps

Alle Befehle im Ordner `project/`. Pod-Namen und Zeiten weichen ab.

## Aufgabe 1: HPA löschen, ConfigMap anlegen

```bash
kubectl delete hpa hello-frontend
cp starters/m09-l01-configmap.yaml playground/k8s/05-configmap.yaml
```

```yaml
# playground/k8s/05-configmap.yaml, ergänzte Stellen
data:
  BACKEND_URL: http://backend
  APP_COLOR: lightyellow
```

```bash
kubectl apply -f playground/k8s/05-configmap.yaml
kubectl describe configmap hello-config
```

```text
horizontalpodautoscaler.autoscaling "hello-frontend" deleted
configmap/hello-config created

Name:         hello-config
Namespace:    hello
Labels:       app=hello-frontend
Annotations:  <none>

Data
====
APP_COLOR:
----
lightyellow

BACKEND_URL:
----
http://backend


BinaryData
====

Events:  <none>
```

Ohne HPA ändert niemand mehr die Pod-Zahl automatisch. Liegt der HPA zusätzlich als Datei in `playground/k8s/`, wird diese Datei ebenfalls gelöscht, damit ein späteres `kubectl apply -f playground/k8s/` ihn nicht zurückholt.

## Aufgabe 2: Frontend mit envFrom

```bash
cp starters/m09-l01-frontend-deployment.yaml playground/k8s/30-frontend-deployment.yaml
```

Ergänzter Ausschnitt (der `env`-Block mit `BACKEND_URL` ist entfallen, `replicas: 3` steht wieder im Manifest):

```yaml
        - name: frontend
          image: hello-frontend:v2
          imagePullPolicy: Never
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: hello-config
```

```bash
kubectl apply -f playground/k8s/30-frontend-deployment.yaml
kubectl rollout status deployment/hello-frontend
kubectl get deployment hello-frontend
```

```text
deployment.apps/hello-frontend configured
Waiting for deployment "hello-frontend" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "hello-frontend" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "hello-frontend" rollout to finish: 1 old replicas are pending termination...
deployment "hello-frontend" successfully rolled out

NAME             READY   UP-TO-DATE   AVAILABLE   AGE
hello-frontend   3/3     3            3           1h
```

Das Pod-Template hat sich geändert (`env` → `envFrom`), deshalb rollt `apply` neue Pods aus. `http://localhost:30080` ist jetzt hellgelb, Titel weiter „Hello-App v2": Die Farbe aus der ConfigMap überschreibt `lightgreen` aus dem Image, die Version kommt weiter aus dem Image.

Vollständige Datei: [`examples/m09-config-storage/l01-configmaps/30-frontend-deployment.yaml`](../../project/examples/m09-config-storage/l01-configmaps/30-frontend-deployment.yaml)

## Aufgabe 3: Umgebungsvariablen im Pod

```bash
kubectl exec deploy/hello-frontend -- env | grep -E '^(APP_|BACKEND_URL)'
```

```text
BACKEND_URL=http://backend
APP_COLOR=lightyellow
APP_VERSION=v2
```

`APP_VERSION` stammt aus dem Image (Lab 2.2), die anderen beiden aus der ConfigMap. Ohne den Filter zeigt `env` zusätzlich Variablen wie `BACKEND_SERVICE_HOST`: Kubernetes setzt sie für jeden Service, der beim Pod-Start existiert; der DNS-Name `backend` ist der übliche Weg.

## Aufgabe 4: Farbe ändern und übernehmen

```yaml
data:
  BACKEND_URL: http://backend
  APP_COLOR: lightpink
```

```bash
kubectl apply -f playground/k8s/05-configmap.yaml
kubectl exec deploy/hello-frontend -- env | grep APP_COLOR
```

```text
configmap/hello-config configured
APP_COLOR=lightyellow
```

Die Seite bleibt gelb: Umgebungsvariablen werden nur beim Start eines Containers gesetzt.

```bash
kubectl rollout restart deployment/hello-frontend
kubectl rollout status deployment/hello-frontend
kubectl get pods -l app=hello-frontend
```

```text
deployment.apps/hello-frontend restarted
Waiting for deployment "hello-frontend" rollout to finish: 1 out of 3 new replicas have been updated...
…
deployment "hello-frontend" successfully rolled out

NAME                              READY   STATUS    RESTARTS   AGE
hello-frontend-7b8f6d5c9c-5mzqp   1/1     Running   0          14s
hello-frontend-7b8f6d5c9c-hd2wx   1/1     Running   0          10s
hello-frontend-7b8f6d5c9c-t9r4k   1/1     Running   0          6s
```

Die Seite ist rosa. `rollout restart` setzt im Pod-Template die Annotation `kubectl.kubernetes.io/restartedAt`; dadurch entsteht ein neuer Rollout wie in Lab 8.2, ohne Ausfall. Die Datei `playground/k8s/30-frontend-deployment.yaml` bleibt dabei unverändert.

Fertiger Stand: [`examples/m09-config-storage/l01-configmaps/`](../../project/examples/m09-config-storage/l01-configmaps/)
