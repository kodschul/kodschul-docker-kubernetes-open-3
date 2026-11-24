# Cheatsheet: Konfiguration, Speicher und Jobs

Befehle und Felder aus Modul 9 (Labs 9.1–9.4). Alle Befehle im Namespace des Kontexts (`hello`).

## ConfigMaps

| Befehl | Wirkung |
| --- | --- |
| `kubectl apply -f playground/k8s/05-configmap.yaml` | ConfigMap aus Datei anlegen oder ändern |
| `kubectl create configmap hello-config --from-literal=APP_COLOR=lightyellow` | ConfigMap per Befehl anlegen |
| `kubectl create configmap … --dry-run=client -o yaml` | nur YAML ausgeben, als Vorlage für eine Datei |
| `kubectl get configmap` | ConfigMaps im Namespace auflisten |
| `kubectl describe configmap hello-config` | Schlüssel und Werte anzeigen |
| `kubectl exec deploy/hello-frontend -- env \| grep APP_` | Umgebungsvariablen in einem Pod prüfen |
| `kubectl rollout restart deployment/hello-frontend` | Pods ersetzen, damit geänderte Umgebungsvariablen wirken |

| Feld im Container | Wirkung |
| --- | --- |
| `envFrom: [{configMapRef: {name: hello-config}}]` | alle Schlüssel als Umgebungsvariablen |
| `env: [{name: X, valueFrom: {configMapKeyRef: {name: …, key: …}}}]` | ein Schlüssel als Variable `X` |

## Secrets

| Befehl | Wirkung |
| --- | --- |
| `kubectl create secret generic hello-secret --from-literal=admin-password=…` | Secret vom Typ `Opaque` anlegen |
| `kubectl get secret hello-secret` | Typ und Anzahl der Schlüssel |
| `kubectl describe secret hello-secret` | Schlüssel mit Länge in Bytes, ohne Wert |
| `kubectl get secret hello-secret -o yaml` | Werte Base64-codiert |
| `kubectl get secret hello-secret -o jsonpath='{.data.admin-password}' \| base64 -d` | einen Wert in Klartext zurückwandeln |
| `kubectl delete secret hello-secret` | Secret löschen |

| Feld | Wirkung |
| --- | --- |
| `stringData:` | Klartext beim Anlegen, wird als Base64 gespeichert |
| `volumes: [{name: admin-secret, secret: {secretName: hello-secret}}]` | Secret als Volume im Pod |
| `volumeMounts: [{name: admin-secret, mountPath: /etc/hello-secret, readOnly: true}]` | je Schlüssel eine Datei im Ordner |

## Volumes und PersistentVolumes

| Befehl | Wirkung |
| --- | --- |
| `kubectl get storageclass` | Speicherangebote; `(default)` markiert die Standard-Klasse |
| `kubectl get pvc,pv` | Claims und Volumes mit `STATUS`, `CLAIM`, `RECLAIM POLICY` |
| `kubectl describe pvc hello-data` | Details, Events, `Used By` |
| `kubectl exec deploy/hello-frontend -- cat /data/access.log` | Datei auf dem Volume lesen |
| `kubectl delete pod -l app=hello-frontend` | Pod ersetzen lassen, um Dauerhaftigkeit zu prüfen |
| `kubectl delete pvc hello-pv-claim` | Claim löschen; bei `Delete` sind die Daten weg |

| Feld | Wirkung |
| --- | --- |
| `storageClassName: hostpath` | Speicher über diese StorageClass (Docker Desktop) |
| `storageClassName: ""` | keine StorageClass: bindet nur ein vorhandenes PV |
| `volumeName: hello-pv` | genau dieses PV binden |
| `accessModes: [ReadWriteOnce]` | lesen und schreiben von einem Node |
| `resources.requests.storage: 100Mi` | gewünschte Größe |
| `persistentVolumeReclaimPolicy: Retain` | Daten bleiben nach Löschen des Claims |
| `volumes: [{name: data, persistentVolumeClaim: {claimName: hello-data}}]` | Claim im Pod |

## Jobs und CronJobs

| Befehl | Wirkung |
| --- | --- |
| `kubectl apply -f playground/k8s/50-job-count.yaml` | Job anlegen und starten |
| `kubectl get jobs` | Jobs mit `STATUS` und `COMPLETIONS` |
| `kubectl logs job/hello-count` | Ausgabe des Job-Pods |
| `kubectl delete job hello-count` | Job samt Pod löschen (für einen neuen Lauf) |
| `kubectl get cronjobs` | Zeitplan, `SUSPEND`, `LAST SCHEDULE` |
| `kubectl create job --from=cronjob/hello-backup hello-backup-manual` | CronJob sofort einmal ausführen |

| Feld | Wirkung |
| --- | --- |
| `restartPolicy: Never` / `OnFailure` | neuer Pod bzw. Neustart im selben Pod bei Fehler |
| `backoffLimit: 2` | höchstens 2 weitere Versuche |
| `schedule: "*/2 * * * *"` | alle 2 Minuten (Minute Stunde Tag Monat Wochentag) |
| `concurrencyPolicy: Forbid` | kein paralleler Lauf |
| `successfulJobsHistoryLimit: 3` | so viele erledigte Jobs bleiben sichtbar |
| `suspend: true` | CronJob pausieren |
| `timeZone: Europe/Berlin` | Zeitzone des Zeitplans |
