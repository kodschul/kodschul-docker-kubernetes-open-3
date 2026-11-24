# Lab 9.4 – Lösung: Jobs und CronJobs

Alle Befehle im Ordner `project/`. Namen, Zahlen und Zeiten weichen ab; die Zeitstempel in den Dateinamen sind UTC.

## Aufgabe 1: Job zählt die Log-Zeilen

```bash
cp starters/m09-l04-job-count.yaml playground/k8s/50-job-count.yaml
```

```yaml
# ergänzte Stellen
      restartPolicy: Never
      containers:
        - name: count
          image: busybox:1.37
          command: ["wc", "-l", "/data/access.log"]
```

```bash
kubectl apply -f playground/k8s/50-job-count.yaml
kubectl get jobs
kubectl logs job/hello-count
```

```text
job.batch/hello-count created

NAME          STATUS     COMPLETIONS   DURATION   AGE
hello-count   Complete   1/1           4s         7s

4 /data/access.log
```

Vier Zeilen: drei Aufrufe aus Lab 9.3, Aufgabe 2, und einer aus Aufgabe 3. Der Pod bleibt mit Status `Completed` stehen, damit `kubectl logs` das Ergebnis noch zeigen kann. Ein zweiter Lauf braucht `kubectl delete job hello-count` und erneutes `kubectl apply`.

## Aufgabe 2: CronJob anlegen

```bash
cp starters/m09-l04-cronjob-backup.yaml playground/k8s/60-cronjob-backup.yaml
```

```yaml
# ergänzte Stellen
spec:
  schedule: "*/2 * * * *"
  concurrencyPolicy: Forbid
```

```bash
kubectl apply -f playground/k8s/60-cronjob-backup.yaml
kubectl get cronjob hello-backup
```

```text
cronjob.batch/hello-backup created

NAME           SCHEDULE      TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
hello-backup   */2 * * * *   <none>     False     0        <none>          4s
```

Vollständige Datei: [`examples/m09-config-storage/l04-jobs/60-cronjob-backup.yaml`](../../project/examples/m09-config-storage/l04-jobs/60-cronjob-backup.yaml)

## Aufgabe 3: Lauf sofort auslösen

```bash
kubectl create job --from=cronjob/hello-backup hello-backup-manual
kubectl get jobs
kubectl logs job/hello-backup-manual
```

```text
job.batch/hello-backup-manual created

NAME                  STATUS     COMPLETIONS   DURATION   AGE
hello-backup-manual   Complete   1/1           4s         8s
hello-count           Complete   1/1           4s         2m

access-20261124-153512.log
```

Der Job nutzt den Bauplan (`jobTemplate`) des CronJobs, startet aber sofort. Ein so erzeugter Job bleibt stehen, bis er gelöscht wird (`kubectl delete job hello-backup-manual`); die History-Limits gelten nur für geplante Jobs.

## Aufgabe 4: Geplanter Lauf und Sicherungsdateien

```bash
kubectl get jobs
kubectl exec deploy/hello-frontend -- ls /data/backup
```

```text
NAME                    STATUS     COMPLETIONS   DURATION   AGE
hello-backup-29925576   Complete   1/1           3s         41s
hello-backup-manual     Complete   1/1           4s         2m10s
hello-count             Complete   1/1           4s         4m

access-20261124-153512.log
access-20261124-153602.log
```

Die Zahl im Namen `hello-backup-29925576` ist die geplante Startzeit in Minuten seit 01.01.1970. Job-Pods und Frontend hängen denselben PVC ein: Was der Job schreibt, sieht das Frontend unter `/data/backup`. Nach mehr als drei geplanten Läufen löscht der CronJob die ältesten Jobs (`successfulJobsHistoryLimit: 3`); die Sicherungsdateien auf dem PVC bleiben.

Den CronJob anhalten, ohne ihn zu löschen: `suspend: true` unter `spec` ergänzen und anwenden; `kubectl get cronjob hello-backup` zeigt dann `SUSPEND True`.

Fertiger Stand: [`examples/m09-config-storage/l04-jobs/`](../../project/examples/m09-config-storage/l04-jobs/)
