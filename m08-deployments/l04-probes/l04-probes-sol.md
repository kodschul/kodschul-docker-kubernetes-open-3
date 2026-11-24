# Lab 8.4 – Lösung: Health Checks mit Probes

Alle Befehle laufen im Ordner `project/`. Namen, Zeiten und IPs weichen ab.

## Aufgabe 1: Probes ergänzen

```bash
cp starters/m08-l04-frontend-deployment.yaml playground/k8s/30-frontend-deployment.yaml
```

Ergänzte Zeilen im Container `frontend` (statt der TODO-Kommentare, gleiche Einrückung wie `env`):

```yaml
          readinessProbe:
            httpGet:
              path: /healthz
              port: 80
            periodSeconds: 5
            failureThreshold: 2
          livenessProbe:
            httpGet:
              path: /healthz
              port: 80
            periodSeconds: 10
            failureThreshold: 3
```

```bash
kubectl apply -f playground/k8s/30-frontend-deployment.yaml
kubectl rollout status deployment/hello-frontend
kubectl describe deployment hello-frontend | grep -E "Liveness|Readiness"
```

```text
deployment.apps/hello-frontend configured
Waiting for deployment "hello-frontend" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "hello-frontend" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "hello-frontend" rollout to finish: 1 old replicas are pending termination...
deployment "hello-frontend" successfully rolled out
    Liveness:     http-get http://:80/healthz delay=0s timeout=1s period=10s #success=1 #failure=3
    Readiness:    http-get http://:80/healthz delay=0s timeout=1s period=5s #success=1 #failure=2
```

Probes gehören zum Pod-Template: Die Änderung startet einen Rollout (neue Revision „Probes auf /healthz"). Vollständige Datei: [`examples/m08-deployments/l04-probes/30-frontend-deployment.yaml`](../../project/examples/m08-deployments/l04-probes/30-frontend-deployment.yaml)

## Aufgabe 2: Ausfall in einem Pod auslösen

```bash
# Terminal 2
kubectl get pods -l app=hello-frontend -w
# Terminal 1
kubectl get pods -l app=hello-frontend
kubectl exec hello-frontend-8b6f5c7d9-4kq2m -- wget -qO- http://127.0.0.1/fail
```

```text
hello-frontend-8b6f5c7d9-4kq2m: /healthz meldet jetzt 500
```

Terminal 2 nach etwa 10 Sekunden:

```text
NAME                             READY   STATUS    RESTARTS   AGE
hello-frontend-8b6f5c7d9-4kq2m   1/1     Running   0          2m
hello-frontend-8b6f5c7d9-9wz7t   1/1     Running   0          2m
hello-frontend-8b6f5c7d9-tr5ln   1/1     Running   0          2m
hello-frontend-8b6f5c7d9-4kq2m   0/1     Running   0          2m12s
```

## Aufgabe 3: Pod ist aus dem Verkehr

```bash
kubectl describe endpointslices -l kubernetes.io/service-name=frontend
for i in $(seq 1 10); do curl -s http://localhost:30080/ | grep -o 'Frontend:</b> [^<]*'; done
```

```text
Endpoints:
  - Addresses:  10.1.0.101
    Conditions:
      Ready:    false
    Hostname:   <unset>
    TargetRef:  Pod/hello-frontend-8b6f5c7d9-4kq2m
    NodeName:   docker-desktop
  - Addresses:  10.1.0.102
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/hello-frontend-8b6f5c7d9-9wz7t
    NodeName:   docker-desktop
  - Addresses:  10.1.0.103
    Conditions:
      Ready:    true
    Hostname:   <unset>
    TargetRef:  Pod/hello-frontend-8b6f5c7d9-tr5ln
    NodeName:   docker-desktop

Frontend:</b> hello-frontend-8b6f5c7d9-9wz7t (10.1.0.102)
Frontend:</b> hello-frontend-8b6f5c7d9-tr5ln (10.1.0.103)
Frontend:</b> hello-frontend-8b6f5c7d9-9wz7t (10.1.0.102)
Frontend:</b> hello-frontend-8b6f5c7d9-9wz7t (10.1.0.102)
Frontend:</b> hello-frontend-8b6f5c7d9-tr5ln (10.1.0.103)
Frontend:</b> hello-frontend-8b6f5c7d9-tr5ln (10.1.0.103)
Frontend:</b> hello-frontend-8b6f5c7d9-9wz7t (10.1.0.102)
Frontend:</b> hello-frontend-8b6f5c7d9-tr5ln (10.1.0.103)
Frontend:</b> hello-frontend-8b6f5c7d9-9wz7t (10.1.0.102)
Frontend:</b> hello-frontend-8b6f5c7d9-tr5ln (10.1.0.103)
```

Der Pod bleibt in der EndpointSlice, aber mit `Ready: false`; der Service schickt nur an bereite Pods. Im Browser fällt der Ausfall nicht auf.

## Aufgabe 4: Liveness startet den Container neu

Terminal 2 nach etwa 30 Sekunden:

```text
hello-frontend-8b6f5c7d9-4kq2m   0/1     Running   1 (2s ago)   2m45s
hello-frontend-8b6f5c7d9-4kq2m   1/1     Running   1 (7s ago)   2m50s
```

```bash
kubectl describe pod hello-frontend-8b6f5c7d9-4kq2m
```

```text
Events:
  Type     Reason     Age                From     Message
  ----     ------     ----               ----     -------
  Warning  Unhealthy  45s (x5 over 65s)  kubelet  Readiness probe failed: HTTP probe failed with statuscode: 500
  Warning  Unhealthy  45s (x3 over 65s)  kubelet  Liveness probe failed: HTTP probe failed with statuscode: 500
  Normal   Killing    45s                kubelet  Container frontend failed liveness probe, will be restarted
  Normal   Pulled     44s                kubelet  Container image "hello-frontend:v2" already present on machine
  Normal   Started    44s                kubelet  Started container frontend
```

Der neue Prozess startet mit `/healthz` = `200`; der Schalter aus `/fail` gilt nur bis zum Neustart. Readiness hat nach 2 × 5 s reagiert, Liveness nach 3 × 10 s. Der Pod behält Namen und IP, weil nur der Container neu startet, nicht der Pod.
