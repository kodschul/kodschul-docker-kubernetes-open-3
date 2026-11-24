# Lab 7.1 – Übung: Pods

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — Backend und Frontend laufen als Pods `backend` und `frontend` mit Labels im Namespace `hello`; Lab 7.2 ersetzt die feste Backend-IP durch einen Service.

## Vorbereitung

- Terminal im Ordner `project/` öffnen; `kubectl config view --minify | grep namespace:` zeigt `namespace: hello` (Lab 5.3).
- `docker images --filter "reference=hello-*"` listet `hello-backend:v1` und `hello-frontend:v1`; sonst `bash build-images.sh`.
- Starter: [`project/starters/m07-l01-backend-pod.yaml`](../../project/starters/m07-l01-backend-pod.yaml), [`project/starters/m07-l01-frontend-pod.yaml`](../../project/starters/m07-l01-frontend-pod.yaml)
- Arbeitsdateien: `project/playground/k8s/10-backend-pod.yaml`, `project/playground/k8s/30-frontend-pod.yaml`
- Zweites Terminal im Ordner `project/` für das Port-Forward bereithalten.

## Aufgaben

1. Kopiere den Backend-Starter nach `playground/k8s/10-backend-pod.yaml`, ergänze die TODOs (Labels, Image, `imagePullPolicy`) und wende die Datei an. Zeige mit `kubectl get pods -o wide` Status und IP des Pods an.
2. Kopiere den Frontend-Starter nach `playground/k8s/30-frontend-pod.yaml`, ergänze `env` mit `BACKEND_URL=http://<Backend-IP>` und wende die Datei an. Zeige mit `kubectl get pods --show-labels` die Labels und mit `kubectl get pods -l app=hello-backend` nur das Backend an.
3. Starte im zweiten Terminal `kubectl port-forward pod/frontend 8080:80` und öffne `http://localhost:8080`. Lies danach mit `kubectl describe pod frontend` die Umgebungsvariable und die Events und mit `kubectl logs backend` die Anfrage des Frontends ab.
4. Lösche den Backend-Pod, lege ihn mit derselben Datei neu an, vergleiche die IP mit `kubectl get pods -o wide` und lade die Hello-Seite neu.
5. Öffne das Dashboard aus Lab 6.2 (Port-Forward in einem dritten Terminal, neuer Token falls nötig), wähle den Namespace `hello`, öffne **Workloads** > **Pods** und vergleiche die Labels beider Pods.

## Checkpoint

- `kubectl get pods -o wide` zeigt `backend` und `frontend` mit `READY 1/1`, `STATUS Running` und je einer IP.
- `kubectl get pods -l app=hello-backend` listet nur `backend`.
- Die Seite unter `http://localhost:8080` ist hellblau, zeigt „Hello-App v1", den Frontend-Pod mit IP und unter **Backend** den Pod `backend` mit IP und Uhrzeit.
- Nach Aufgabe 4 hat `backend` eine neue IP, und die Seite meldet `Backend nicht erreichbar (http://<alte IP>)`.
- Das Dashboard zeigt im Namespace `hello` die Pods `backend` und `frontend` mit den Labels `app`, `tier`, `version`.

## Abschlusskriterien

- `playground/k8s/10-backend-pod.yaml` und `30-frontend-pod.yaml` existieren; beide Pods laufen mit Labels im Namespace `hello`.
- Es ist sichtbar, dass eine fest eingetragene Pod-IP nach dem Neuanlegen des Backends nicht mehr stimmt.

## Fallback

- `ErrImageNeverPull`: im Ordner `project/` `bash build-images.sh` ausführen, dann den Pod löschen und neu anwenden.
- Port 8080 belegt: `kubectl port-forward pod/frontend 8081:80` und `http://localhost:8081` öffnen.
- Dashboard nicht verfügbar: `kubectl get pods --show-labels` zeigt dieselben Informationen.
- Fertiger Stand: [`project/examples/m07-pods-services/l01-pods/`](../../project/examples/m07-pods-services/l01-pods/) (die Backend-IP im Frontend ist ein Beispielwert).
