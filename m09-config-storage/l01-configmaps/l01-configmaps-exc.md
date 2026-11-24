# Lab 9.1 – Übung: ConfigMaps

**Dauer:** ca. 10 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — neue ConfigMap `hello-config`; das Frontend liest `BACKEND_URL` und `APP_COLOR` daraus, der HPA entfällt. Lab 9.2 ergänzt ein Secret.

## Vorbereitung

- Terminal im Ordner `project/`; `http://localhost:30080` zeigt die grüne Seite „Hello-App v2".
- Starter: [`project/starters/m09-l01-configmap.yaml`](../../project/starters/m09-l01-configmap.yaml), [`project/starters/m09-l01-frontend-deployment.yaml`](../../project/starters/m09-l01-frontend-deployment.yaml)
- Arbeitsdateien: `project/playground/k8s/05-configmap.yaml` (neu), `project/playground/k8s/30-frontend-deployment.yaml` (wird ersetzt)
- Stand aus Lab 8.5 wiederherstellen (falls nötig): `kubectl apply -f examples/m08-deployments/l05-autoscaling/`

## Aufgaben

1. Lösche den HPA aus Lab 8.5 mit `kubectl delete hpa hello-frontend`. Kopiere den ConfigMap-Starter nach `playground/k8s/05-configmap.yaml`, trage `BACKEND_URL` und `APP_COLOR` (`lightyellow`) ein, wende die Datei an und prüfe sie mit `kubectl describe configmap hello-config`.
2. Kopiere den Deployment-Starter nach `playground/k8s/30-frontend-deployment.yaml`, ergänze `envFrom` mit der ConfigMap `hello-config` und wende die Datei an. Warte mit `kubectl rollout status deployment/hello-frontend` und lade `http://localhost:30080` neu.
3. Zeige die Umgebungsvariablen eines Frontend-Pods: `kubectl exec deploy/hello-frontend -- env | grep -E '^(APP_|BACKEND_URL)'`.
4. Ändere in `playground/k8s/05-configmap.yaml` den Wert von `APP_COLOR` auf `lightpink`, wende die Datei an und lade die Seite neu. Übernimm die Farbe danach mit `kubectl rollout restart deployment/hello-frontend`, warte auf den Rollout und lade die Seite erneut.

## Checkpoint

- Nach Aufgabe 1 zeigt `kubectl get hpa` keinen Eintrag mehr; `describe` listet `APP_COLOR` und `BACKEND_URL`.
- Nach Aufgabe 2 ist die Seite hellgelb, Titel weiter „Hello-App v2", Backend antwortet; `kubectl get deployment hello-frontend` zeigt `3/3`.
- Aufgabe 3 zeigt `APP_COLOR=lightyellow`, `APP_VERSION=v2` und `BACKEND_URL=http://backend`.
- In Aufgabe 4 bleibt die Seite nach `kubectl apply` gelb und wird erst nach `rollout restart` rosa; die Pod-Namen sind danach neu.

## Abschlusskriterien

- `playground/k8s/30-frontend-deployment.yaml` enthält kein `env` mit `BACKEND_URL` mehr, sondern `envFrom` mit `hello-config`.
- Die Farbe der Hello-Seite stammt aus der ConfigMap; das Image ist unverändert `hello-frontend:v2`.

## Fallback

- Pods hängen in `CreateContainerConfigError`: `kubectl describe pod -l app=hello-frontend` lesen; meist ist der Name der ConfigMap falsch geschrieben.
- `kubectl apply` meldet `field is immutable`: `kubectl delete deployment hello-frontend` und die Datei erneut anwenden.
- Fertiger Stand: `kubectl apply -f examples/m09-config-storage/l01-configmaps/` (Farbe dort `lightpink`).
