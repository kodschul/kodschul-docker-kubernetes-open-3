# Lab 9.2 – Übung: Secrets

**Dauer:** ca. 10 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — neues Secret `hello-secret`, im Frontend als Datei unter `/etc/hello-secret` eingebunden. Lab 9.3 ergänzt dauerhaften Speicher.

## Vorbereitung

- Terminal im Ordner `project/`; `http://localhost:30080` zeigt die rosa Seite mit **Admin:** `kein Passwort gesetzt`.
- Starter: [`project/starters/m09-l02-frontend-deployment.yaml`](../../project/starters/m09-l02-frontend-deployment.yaml)
- Arbeitsdatei: `project/playground/k8s/30-frontend-deployment.yaml` (wird ersetzt)
- Stand aus Lab 9.1 wiederherstellen (falls nötig): `kubectl apply -f examples/m09-config-storage/l01-configmaps/`
- `uebung-2026` ist ein Übungswert. Echte Passwörter nie in eine Datei schreiben, die in ein Repository gelangt.

## Aufgaben

1. Lege das Secret per Befehl an: `kubectl create secret generic hello-secret --from-literal=admin-password=uebung-2026`. Zeige es mit `kubectl get secret hello-secret` und `kubectl describe secret hello-secret` an.
2. Lies den gespeicherten Wert mit `kubectl get secret hello-secret -o yaml` und wandle ihn mit `kubectl get secret hello-secret -o jsonpath='{.data.admin-password}' | base64 -d` in Klartext zurück.
3. Kopiere den Starter nach `playground/k8s/30-frontend-deployment.yaml`, ergänze `mountPath` und `secretName` und wende die Datei an. Warte mit `kubectl rollout status deployment/hello-frontend` und lade `http://localhost:30080` neu.
4. Sieh in einem Frontend-Pod nach, was die App sieht: `kubectl exec deploy/hello-frontend -- ls /etc/hello-secret/` und `kubectl exec deploy/hello-frontend -- cat /etc/hello-secret/admin-password`. Prüfe mit `kubectl exec deploy/hello-frontend -- env | grep -i password`, dass der Wert nicht als Umgebungsvariable vorliegt.

## Checkpoint

- `kubectl get secret hello-secret` zeigt `TYPE Opaque` und `DATA 1`; `describe` zeigt `admin-password: 11 bytes`, nicht den Wert.
- `-o yaml` zeigt `admin-password: dWVidW5nLTIwMjY=`; `base64 -d` liefert `uebung-2026`.
- Die Hello-Seite zeigt **Admin:** `Passwort gesetzt`, Farbe weiter Rosa.
- `ls` zeigt `admin-password`, `cat` zeigt `uebung-2026`; `env | grep -i password` liefert keine Zeile.

## Abschlusskriterien

- Das Frontend-Deployment bindet `hello-secret` schreibgeschützt unter `/etc/hello-secret` ein.
- Kein Passwort steht in einer Datei unter `playground/k8s/`.

## Fallback

- Pods hängen in `ContainerCreating`: `kubectl describe pod -l app=hello-frontend` lesen; meist fehlt das Secret oder `secretName` ist falsch geschrieben.
- Fertiger Stand: `kubectl apply -f examples/m09-config-storage/l02-secrets/` (legt das Secret mit dem Übungswert aus `06-secret.yaml` an).
