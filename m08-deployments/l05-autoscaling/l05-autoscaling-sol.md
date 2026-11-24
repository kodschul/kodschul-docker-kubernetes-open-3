# Lab 8.5 – Lösung: Autoscaling mit HPA

Alle Befehle laufen im Ordner `project/`. Namen, Zeiten und Messwerte weichen ab.

## Aufgabe 1: Requests und Limits übernehmen

```bash
cp starters/m08-l05-frontend-deployment.yaml playground/k8s/30-frontend-deployment.yaml
kubectl apply -f playground/k8s/30-frontend-deployment.yaml
kubectl rollout status deployment/hello-frontend
kubectl get deploy hello-frontend
kubectl top pods -l app=hello-frontend
```

```text
deployment.apps/hello-frontend configured
deployment "hello-frontend" successfully rolled out
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
hello-frontend   1/1     1            1           1h
NAME                              CPU(cores)   MEMORY(bytes)
hello-frontend-6f8d7c9b5-4hx2p    1m           38Mi
```

Neu in der Datei:

```yaml
          resources:
            requests:
              cpu: 100m
              memory: 64Mi
            limits:
              cpu: 500m
              memory: 128Mi
```

Weil `replicas` in der Datei fehlt, entfernt `kubectl apply` das Feld, und das Deployment fällt einmalig auf den Standardwert 1 zurück. `kubectl top` zeigt erst etwa eine Minute nach dem Start eines Pods Werte; vorher meldet es `metrics not available yet`.

## Aufgabe 2: HPA anlegen

```bash
kubectl autoscale deployment hello-frontend --cpu=50% --min=1 --max=5
kubectl get hpa
```

```text
horizontalpodautoscaler.autoscaling/hello-frontend autoscaled
NAME             REFERENCE                   TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
hello-frontend   Deployment/hello-frontend   cpu: 1%/50%   1         5         1          30s
```

1 % von 100m sind 1 Millicore: Das Frontend tut ohne Anfragen fast nichts. Direkt nach dem Anlegen kann `TARGETS` noch `cpu: <unknown>/50%` zeigen, bis die ersten Messwerte da sind. Als Manifest: [`examples/m08-deployments/l05-autoscaling/50-frontend-hpa.yaml`](../../project/examples/m08-deployments/l05-autoscaling/50-frontend-hpa.yaml)

## Aufgabe 3: Last erzeugen

```bash
# Terminal 2
kubectl get hpa -w
# Terminal 1
kubectl run load --image=busybox:1.37 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://frontend/work; done"
```

```text
pod/load created
```

Der Pod `load` ruft in einer Endlosschleife `http://frontend/work` auf (Service `frontend`, Port 80); jeder Aufruf kostet das Frontend etwa 0,2 Sekunden CPU.

## Aufgabe 4: Hochskalieren beobachten

Terminal 2:

```text
NAME             REFERENCE                   TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
hello-frontend   Deployment/hello-frontend   cpu: 1%/50%     1         5         1          1m
hello-frontend   Deployment/hello-frontend   cpu: 452%/50%   1         5         1          1m45s
hello-frontend   Deployment/hello-frontend   cpu: 452%/50%   1         5         5          2m
hello-frontend   Deployment/hello-frontend   cpu: 168%/50%   1         5         5          2m15s
hello-frontend   Deployment/hello-frontend   cpu: 98%/50%    1         5         5          3m
```

```bash
kubectl get pods -l app=hello-frontend
kubectl top pods -l app=hello-frontend
```

```text
NAME                             READY   STATUS    RESTARTS   AGE
hello-frontend-6f8d7c9b5-4hx2p   1/1     Running   0          6m
hello-frontend-6f8d7c9b5-8mzq1   1/1     Running   0          70s
hello-frontend-6f8d7c9b5-c2vt9   1/1     Running   0          70s
hello-frontend-6f8d7c9b5-n4d7k   1/1     Running   0          55s
hello-frontend-6f8d7c9b5-x8wq3   1/1     Running   0          70s
NAME                             CPU(cores)   MEMORY(bytes)
hello-frontend-6f8d7c9b5-4hx2p   102m         40Mi
hello-frontend-6f8d7c9b5-8mzq1   97m          39Mi
hello-frontend-6f8d7c9b5-c2vt9   99m          39Mi
hello-frontend-6f8d7c9b5-n4d7k   95m          39Mi
hello-frontend-6f8d7c9b5-x8wq3   101m         39Mi
```

Rechnung beim ersten Sprung: aufrunden(1 × 452 / 50) = 10, begrenzt durch `maxReplicas` auf 5. Ein Lastgenerator schickt immer nur eine Anfrage gleichzeitig; die Last verteilt sich auf alle Pods, bleibt im Mittel aber über dem Ziel, deshalb bleibt es bei 5. Neue Pods werden erst `1/1`, wenn ihre Readiness-Probe aus Lab 8.4 besteht.

## Aufgabe 5: Last beenden, Herunterskalieren

```bash
kubectl delete pod load
# nach der Pause
kubectl get hpa
kubectl describe hpa hello-frontend
```

```text
pod "load" deleted
NAME             REFERENCE                   TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
hello-frontend   Deployment/hello-frontend   cpu: 1%/50%   1         5         1          21m
...
Events:
  Type    Reason             Age    From                       Message
  ----    ------             ----   ----                       -------
  Normal  SuccessfulRescale  19m    horizontal-pod-autoscaler  New size: 5; reason: cpu resource utilization (percentage of request) above target
  Normal  SuccessfulRescale  12m    horizontal-pod-autoscaler  New size: 1; reason: All metrics below target
```

Die Last fällt sofort, die Pod-Zahl erst nach dem Stabilisierungsfenster von 5 Minuten. So verhindert der HPA, dass kurze Pausen in der Last zu ständigem Auf und Ab führen.
