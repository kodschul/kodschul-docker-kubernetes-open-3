# Hello-App – Projektdateien

Die Hello-App besteht aus zwei kleinen Python/Flask-Diensten. An Tag 1 werden daraus Images und ein Compose-Projekt, an Tag 2 laufen dieselben Images im Kubernetes-Cluster.

| Dienst | Image | Antwort | Endpunkte |
| --- | --- | --- | --- |
| Frontend | `hello-frontend:v1` (hellblau), `hello-frontend:v2` (hellgrün) | HTML-Seite mit Version, Farbe, Name/IP, Backend-Antwort, Passwort-Status | `/`, `/healthz`, `/fail`, `/recover`, `/work` |
| Backend | `hello-backend:v1` | JSON mit Name, IP, Uhrzeit, Version | `/`, `/api`, `/healthz` |

Beide lauschen im Container auf Port 80. Einstellungen kommen aus Umgebungsvariablen:

| Variable | Dienst | Standard | Wirkung |
| --- | --- | --- | --- |
| `BACKEND_URL` | Frontend | `http://localhost:8081` | Adresse des Backends; in Compose und Kubernetes `http://backend` |
| `APP_VERSION` | beide | `v1` | angezeigte Version |
| `APP_COLOR` | Frontend | `lightblue` | Hintergrundfarbe |
| `PORT` | beide | `80` | Port im Container |
| `DATA_DIR` | Frontend | `/data` | Ordner für `access.log` |
| `SECRET_FILE` | Frontend | `/etc/hello-secret/admin-password` | Datei, deren Inhalt als „Passwort gesetzt" zählt |
| `STARTUP_DELAY` | Frontend | `0` | Sekunden Wartezeit vor dem Start |

## Ordner

| Ordner / Datei | Inhalt |
| --- | --- |
| `playground/` | Arbeitsbereich: Quellcode (`frontend/`, `backend/`), eigene `compose.yml`, ab Tag 2 Manifeste in `k8s/` |
| `starters/` | Startdateien mit `# TODO:`-Zeilen, Name `mNN-lNN-<datei>` |
| `examples/<modul>/<lab>/` | fertiger Stand nach dem Lab |
| `variants/m04-l03-debugging/` | drei Fehlerbilder für Lab 4.3 |
| `build-images.sh` | baut `hello-backend:v1`, `hello-frontend:v1`, `hello-frontend:v2` neu |
| `pull-images.sh` | lädt alle Kurs-Images vorab (`bash pull-images.sh`, nach dem Einschalten von Kubernetes `bash pull-images.sh k8s`) |

Alle Befehle laufen aus dem Ordner `project/`, wenn nichts anderes dabeisteht.

## Lab → Beispiel → Starter

| Lab | Beispiel (`examples/`) | Starter (`starters/`) |
| --- | --- | --- |
| 2.2 Dockerfile | `m02-images/l02-dockerfile/` | `m02-l02-backend.Dockerfile`, `m02-l02-frontend.Dockerfile` |
| 2.3 Registry | `m02-images/l03-registry/registry.sh` | – |
| 3.1 Compose | `m03-compose/l01-compose-basics/` | `m03-l01-compose.yml` |
| 3.2 Healthcheck, Watch | `m03-compose/l02-multi-service/` | `m03-l02-compose.yml` |
| 3.3 Volumes | `m03-compose/l03-volumes/` | `m03-l03-compose.yml` |
| 4.1 Netzwerke | `m04-networking/l01-networks/hello-net.sh` | – |
| 4.2 Netzwerke in Compose | `m04-networking/l02-compose-networks/` | `m04-l02-compose.yml` |
| 4.3 Fehlersuche, Limits | `m04-networking/l03-debugging/` | `m04-l03-compose.yml`, `variants/m04-l03-debugging/` |
| 4.4 Swarm (Demo) | `m04-networking/l04-swarm/stack.yml` | – |
| 5.3 Namespace | `m05-kubernetes-basics/l03-resources/` | – |
| 6.1 Helm, metrics-server | `m06-helm-tools/l01-helm/` | – |
| 6.2 Dashboard | `m06-helm-tools/l02-dashboard/` | – |
| 7.1 Pods | `m07-pods-services/l01-pods/` | `m07-l01-backend-pod.yaml`, `m07-l01-frontend-pod.yaml` |
| 7.2 ClusterIP | `m07-pods-services/l02-clusterip/` | `m07-l02-backend-service.yaml` |
| 7.3 NodePort | `m07-pods-services/l03-nodeport/` | `m07-l03-frontend-service.yaml` |
| 7.4 Ingress (Demo) | `m07-pods-services/l04-ingress/` | – |
| 8.1 ReplicaSet | `m08-deployments/l01-replicasets/` | `m08-l01-frontend-replicaset.yaml` |
| 8.2 Rollout | `m08-deployments/l02-rollouts/` | `m08-l02-backend-deployment.yaml`, `m08-l02-frontend-deployment.yaml` |
| 8.3 Zwei Versionen | `m08-deployments/l03-versions/` (Canary in `canary/`) | `m08-l03-frontend-canary.yaml` |
| 8.4 Probes | `m08-deployments/l04-probes/` | `m08-l04-frontend-deployment.yaml` |
| 8.5 HPA | `m08-deployments/l05-autoscaling/` | `m08-l05-frontend-deployment.yaml` |
| 9.1 ConfigMap | `m09-config-storage/l01-configmaps/` | `m09-l01-configmap.yaml`, `m09-l01-frontend-deployment.yaml` |
| 9.2 Secret | `m09-config-storage/l02-secrets/` | `m09-l02-frontend-deployment.yaml` |
| 9.3 Volumes, PV | `m09-config-storage/l03-volumes/` | `m09-l03-pvc.yaml`, `m09-l03-static-pv.yaml`, `m09-l03-frontend-deployment.yaml` |
| 9.4 Job, CronJob | `m09-config-storage/l04-jobs/` | `m09-l04-job-count.yaml`, `m09-l04-cronjob-backup.yaml` |
| 10.1 Helm-Chart (Demo) | `m10-helm-chart/l01-own-chart/hello/` | – |

## Stand wiederherstellen

Compose (Tag 1): Beispiel-Datei in den Arbeitsbereich kopieren und starten.

```bash
cp examples/m03-compose/l03-volumes/compose.yml playground/compose.yml
cd playground && docker compose up -d
```

Kubernetes (Tag 2): jeder Beispielordner enthält den vollständigen Stand und lässt sich direkt anwenden.

```bash
kubectl apply -f examples/m08-deployments/l04-probes/
```

Bis Lab 7.3 laufen einzelne Pods; deren Umgebungsvariablen lassen sich nicht nachträglich ändern. Dort vorher `kubectl delete pods --all -n hello` ausführen.
