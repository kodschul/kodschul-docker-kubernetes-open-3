# Lab 9.3 – Übung: Volumes und PersistentVolumes

**Dauer:** ca. 12 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — neuer PVC `hello-data`; das Frontend läuft mit einer Replika und schreibt `access.log` darauf. Dazu das statische PV `hello-pv` mit Claim `hello-pv-claim`. Lab 9.4 wertet das Log mit Job und CronJob aus.

## Vorbereitung

- Terminal im Ordner `project/`; `http://localhost:30080` zeigt **Admin:** `Passwort gesetzt`.
- Starter: [`project/starters/m09-l03-pvc.yaml`](../../project/starters/m09-l03-pvc.yaml), [`project/starters/m09-l03-frontend-deployment.yaml`](../../project/starters/m09-l03-frontend-deployment.yaml), [`project/starters/m09-l03-static-pv.yaml`](../../project/starters/m09-l03-static-pv.yaml)
- Arbeitsdateien: `project/playground/k8s/07-pvc.yaml` (neu), `project/playground/k8s/30-frontend-deployment.yaml` (wird ersetzt), `project/playground/k8s/08-static-pv.yaml` (neu)
- Stand aus Lab 9.2 wiederherstellen (falls nötig): `kubectl apply -f examples/m09-config-storage/l02-secrets/`

## Aufgaben

1. Zeige mit `kubectl get storageclass` die StorageClass an. Kopiere den PVC-Starter nach `playground/k8s/07-pvc.yaml`, ergänze die drei TODOs (StorageClass, Access Mode, 100 Mebibyte), wende die Datei an und zeige mit `kubectl get pvc,pv` Claim und Volume an.
2. Kopiere den Frontend-Starter nach `playground/k8s/30-frontend-deployment.yaml`, setze eine Replika und den Claim `hello-data` ein und wende die Datei an. Warte mit `kubectl rollout status deployment/hello-frontend`, rufe die Seite dreimal mit `curl -s -o /dev/null http://localhost:30080/` auf und lies das Log mit `kubectl exec deploy/hello-frontend -- cat /data/access.log`.
3. Lösche den Frontend-Pod mit `kubectl delete pod -l app=hello-frontend`, warte mit `kubectl get pods -l app=hello-frontend` auf den Ersatz und lies das Log erneut. Rufe die Seite einmal auf und lies es noch einmal.
4. Kopiere den Starter für das statische PV nach `playground/k8s/08-static-pv.yaml`, ergänze im Claim `storageClassName`, wende die Datei an und prüfe die Bindung mit `kubectl get pv,pvc`.

## Checkpoint

- Aufgabe 1: `hostpath (default)`; `hello-data` mit `STATUS Bound`, `CAPACITY 100Mi`, `ACCESS MODES RWO`; das PV heißt `pvc-…` und hat `RECLAIM POLICY Delete`.
- Aufgabe 2: `kubectl get pods -l app=hello-frontend` zeigt genau einen Pod; das Log hat drei Zeilen mit seinem Namen.
- Aufgabe 3: Der Ersatz-Pod hat einen neuen Namen; die drei Zeilen sind noch da, die neue Zeile trägt den Namen des Ersatz-Pods.
- Aufgabe 4: `hello-pv` mit `STATUS Bound`, `CLAIM hello/hello-pv-claim`, `RECLAIM POLICY Retain`; `hello-pv-claim` zeigt `VOLUME hello-pv` und eine leere Spalte `STORAGECLASS`.

## Abschlusskriterien

- `kubectl get deployment hello-frontend` zeigt `1/1`; das Frontend hängt `hello-data` unter `/data` ein.
- `kubectl get pvc` zeigt `hello-data` und `hello-pv-claim`, beide `Bound`.

## Fallback

- PVC bleibt `Pending`: `kubectl describe pvc hello-data` lesen; bei minikube oder kind heißt die StorageClass `standard`, dann diesen Namen eintragen.
- `hello-pv-claim` bleibt `Pending`: `kubectl describe pvc hello-pv-claim` lesen; bei `storageClassName does not match` den Claim mit `kubectl delete pvc hello-pv-claim` löschen, TODO prüfen, erneut anwenden.
- Fertiger Stand: `kubectl apply -f examples/m09-config-storage/l03-volumes/`
