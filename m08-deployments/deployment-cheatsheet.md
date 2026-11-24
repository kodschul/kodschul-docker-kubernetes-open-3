# Deployments – Cheatsheet (Modul 8)

Alle Befehle laufen im Ordner `project/` und wirken im Standard-Namespace des Kontexts (`hello`, Lab 5.3). Pods, Labels und Services: [Pod- und Service-Cheatsheet](../m07-pods-services/pod-service-cheatsheet.md).

## ReplicaSets (Lab 8.1)

| Befehl | Wirkung |
| --- | --- |
| `kubectl apply -f playground/k8s/30-frontend-replicaset.yaml` | ReplicaSet anlegen oder ändern |
| `kubectl get rs` | ReplicaSets mit `DESIRED`, `CURRENT`, `READY` |
| `kubectl get pods -l app=hello-frontend -w` | Pods live verfolgen (Ende mit **Strg+C**) |
| `kubectl scale rs hello-frontend --replicas=5` | Soll-Anzahl sofort ändern (bis zum nächsten `apply`) |
| `kubectl describe pod <name>` | `Controlled By` zeigt das verwaltende Objekt |
| `kubectl delete rs hello-frontend` | ReplicaSet samt seinen Pods löschen |
| `for i in $(seq 1 10); do curl -s http://localhost:30080/ \| grep -o 'Frontend:</b> [^<]*'; done` | Lastverteilung über den NodePort zeigen |

## Deployments anlegen und skalieren (Lab 8.2)

| Befehl | Wirkung |
| --- | --- |
| `kubectl create deployment hello-backend --image=hello-backend:v1 --port=80 --dry-run=client -o yaml` | Manifest-Vorlage erzeugen, nichts anlegen |
| `kubectl apply -f playground/k8s/` | alle Manifeste des Ordners anwenden |
| `kubectl get deploy` | Deployments mit `READY`, `UP-TO-DATE`, `AVAILABLE` |
| `kubectl get deploy,rs,pods` | alle drei Ebenen auf einen Blick |
| `kubectl scale deployment hello-frontend --replicas=3` | Anzahl ändern (bis zum nächsten `apply`) |
| `kubectl delete deployment hello-frontend` | Deployment mit ReplicaSets und Pods löschen |

## Rollout und Rollback (Lab 8.2)

| Befehl | Wirkung |
| --- | --- |
| Image, Label `version` und `change-cause` in der Datei ändern, `kubectl apply -f …` | Rollout deklarativ starten |
| `kubectl set image deployment/hello-frontend frontend=hello-frontend:v3` | Rollout per Befehl (Container `frontend`), Datei bleibt unverändert |
| `kubectl annotate deployment/hello-frontend kubernetes.io/change-cause="…" --overwrite` | Grund nachtragen, direkt nach `set image` |
| `kubectl rollout status deployment/hello-frontend` | warten, bis der Rollout fertig ist |
| `kubectl rollout status deployment/hello-frontend --timeout=30s` | höchstens 30 s warten, sonst Fehler |
| `kubectl rollout history deployment/hello-frontend` | Revisionen mit `CHANGE-CAUSE` |
| `kubectl rollout undo deployment/hello-frontend` | zur vorherigen Revision zurück |
| `kubectl rollout undo deployment/hello-frontend --to-revision=1` | zu einer bestimmten Revision zurück |

Nach einem `undo` prüfen, ob die Datei noch zum laufenden Stand passt.

## Zwei Versionen parallel (Lab 8.3)

| Befehl | Wirkung |
| --- | --- |
| `kubectl apply -f playground/k8s/35-frontend-canary-deployment.yaml` | Canary mit `v2` neben `hello-frontend` starten |
| `kubectl get pods -l app=hello-frontend -L version` | Pods mit dem Label `version` als Spalte |
| `for i in $(seq 1 40); do curl -s http://localhost:30080/ \| grep -m1 -o 'Hello-App v[0-9]'; done \| sort \| uniq -c` | Verteilung auf `v1` und `v2` zählen |
| `kubectl patch service frontend -p '{"spec":{"selector":{"version":"v2"}}}'` | Blue/Green: Service nur noch auf `v2` |
| `kubectl patch service frontend -p '{"spec":{"selector":{"version":null}}}'` | Label `version` aus dem Selector entfernen |
| `kubectl get service frontend -o jsonpath='{.spec.selector}'` | aktuellen Selector anzeigen |
| `kubectl delete -f playground/k8s/35-frontend-canary-deployment.yaml` | Canary löschen (danach Datei mit `rm` entfernen) |

## Probes (Lab 8.4)

| Befehl | Wirkung |
| --- | --- |
| `kubectl describe deployment hello-frontend \| grep -E "Liveness\|Readiness"` | eingestellte Probes anzeigen |
| `kubectl exec <pod> -- wget -qO- http://127.0.0.1/fail` | Ausfall in einem Pod simulieren (`/recover` hebt ihn auf) |
| `kubectl describe endpointslices -l kubernetes.io/service-name=frontend` | Endpunkte mit `Ready: true/false` |
| `kubectl describe pod <pod>` | Events `Readiness probe failed`, `Liveness probe failed`, Neustart |

## Requests, Limits und HPA (Lab 8.5)

| Befehl | Wirkung |
| --- | --- |
| `kubectl top pods -l app=hello-frontend` | aktueller CPU- und Speicherverbrauch |
| `kubectl describe node docker-desktop` | Abschnitt `Allocated resources`: Summe der Requests und Limits |
| `kubectl autoscale deployment hello-frontend --cpu=50% --min=1 --max=5` | HPA anlegen (ältere kubectl: `--cpu-percent=50`) |
| `kubectl get hpa -w` | `TARGETS` und `REPLICAS` live verfolgen |
| `kubectl describe hpa hello-frontend` | Events `SuccessfulRescale` mit Grund |
| `kubectl run load --image=busybox:1.37 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://frontend/work; done"` | Lastgenerator starten |
| `kubectl delete pod load` | Last beenden |
| `kubectl delete hpa hello-frontend` | HPA löschen |

## Manifest-Felder

| Feld | Wirkung |
| --- | --- |
| `apiVersion: apps/v1` | API-Gruppe für ReplicaSet und Deployment |
| `spec.replicas` | Soll-Anzahl der Pods; entfällt, sobald ein HPA steuert |
| `spec.selector.matchLabels` | Pods, die dazugehören (`app` + `tier`, nie `version`); später nicht änderbar |
| `spec.template` | Pod-Bauplan; jede Änderung erzeugt beim Deployment eine neue Revision |
| `spec.strategy.type: RollingUpdate` / `Recreate` | schrittweise austauschen / alle beenden, dann neu starten |
| `spec.strategy.rollingUpdate.maxSurge: 1` | höchstens ein Pod über `replicas` |
| `spec.strategy.rollingUpdate.maxUnavailable: 0` | nie weniger bereite Pods als `replicas` |
| `metadata.annotations."kubernetes.io/change-cause"` | Grund der Änderung in der Historie |
| `readinessProbe` / `livenessProbe` / `startupProbe` | Verkehr / Neustart / Startzeit; `httpGet` mit `path` und `port` |
| `periodSeconds`, `failureThreshold` | Takt und erlaubte Fehlschläge; Reaktionszeit ≈ Produkt |
| `resources.requests.cpu: 100m` | Reservierung für den Scheduler; Bezugsgröße des HPA |
| `resources.limits.memory: 128Mi` | Obergrenze; darüber `OOMKilled` |
| HPA `minReplicas`, `maxReplicas`, `averageUtilization` | Grenzen und CPU-Ziel in Prozent des Requests |
