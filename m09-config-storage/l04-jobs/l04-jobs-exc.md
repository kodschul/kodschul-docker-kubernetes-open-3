# Lab 9.4 – Übung: Jobs und CronJobs

**Dauer:** ca. 10 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — neuer Job `hello-count` und CronJob `hello-backup`, der `access.log` alle zwei Minuten nach `/data/backup/` auf dem PVC `hello-data` kopiert.

## Vorbereitung

- Terminal im Ordner `project/`.
- Starter: [`project/starters/m09-l04-job-count.yaml`](../../project/starters/m09-l04-job-count.yaml), [`project/starters/m09-l04-cronjob-backup.yaml`](../../project/starters/m09-l04-cronjob-backup.yaml)
- Arbeitsdateien: `project/playground/k8s/50-job-count.yaml` (neu), `project/playground/k8s/60-cronjob-backup.yaml` (neu)
- Prüfen: `kubectl get pvc hello-data` zeigt `Bound`, und `kubectl exec deploy/hello-frontend -- cat /data/access.log` zeigt mindestens eine Zeile (sonst die Seite einmal aufrufen: `curl -s -o /dev/null http://localhost:30080/`).
- Stand aus Lab 9.3 wiederherstellen (falls nötig): `kubectl apply -f examples/m09-config-storage/l03-volumes/`, danach die Seite einmal aufrufen.

## Aufgaben

1. Kopiere den Job-Starter nach `playground/k8s/50-job-count.yaml`, ergänze `restartPolicy` und `command` (`wc -l /data/access.log`) und wende die Datei an. Zeige mit `kubectl get jobs` den Status und mit `kubectl logs job/hello-count` das Ergebnis.
2. Kopiere den CronJob-Starter nach `playground/k8s/60-cronjob-backup.yaml`, ergänze Zeitplan (alle zwei Minuten) und `concurrencyPolicy` (keine parallelen Läufe) und wende die Datei an. Zeige den CronJob mit `kubectl get cronjob hello-backup`.
3. Löse einen Lauf sofort aus: `kubectl create job --from=cronjob/hello-backup hello-backup-manual`. Zeige mit `kubectl get jobs` den Status und mit `kubectl logs job/hello-backup-manual` die Ausgabe.
4. Warte etwa zwei Minuten und zeige danach erneut `kubectl get jobs` sowie die Sicherungsdateien mit `kubectl exec deploy/hello-frontend -- ls /data/backup`.

## Checkpoint

- Aufgabe 1: `hello-count` mit `STATUS Complete` und `COMPLETIONS 1/1`; das Log zeigt die Zeilenzahl, z. B. `4 /data/access.log`.
- Aufgabe 2: `SCHEDULE */2 * * * *`, `SUSPEND False`.
- Aufgabe 3: `hello-backup-manual` mit `STATUS Complete`; das Log nennt eine Datei `access-<Datum>-<Uhrzeit>.log`.
- Aufgabe 4: Ein Job `hello-backup-<zahl>` ist dazugekommen; in `/data/backup` liegen mindestens zwei Dateien.

## Abschlusskriterien

- `kubectl get cronjob hello-backup` existiert, beide Dateien nutzen `apiVersion: batch/v1`.
- Das Frontend sieht die Sicherungsdateien unter `/data/backup`, weil Job-Pods und Frontend denselben PVC einhängen.

## Fallback

- Job-Pod hängt in `ErrImagePull` (kein Netz): `docker pull busybox:1.37` ausführen (oder `bash pull-images.sh`), danach `kubectl delete job hello-count` und Aufgabe 1 wiederholen.
- Job `Failed` mit `No such file or directory`: Seite einmal aufrufen, Job löschen und neu anlegen.
- Fertiger Stand: `kubectl apply -f examples/m09-config-storage/l04-jobs/`
