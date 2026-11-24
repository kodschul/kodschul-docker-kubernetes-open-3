# Lab 8.3 – Übung: Zwei Versionen parallel

**Dauer:** ca. 10 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — zwischendurch laufen `v1` und `v2` parallel; am Ende läuft wieder nur `hello-frontend` mit 3 Pods `v2`, der Canary ist gelöscht. Lab 8.4 baut darauf auf.

## Vorbereitung

- Terminal (bash) im Ordner `project/`.
- Starter: [`project/starters/m08-l03-frontend-canary.yaml`](../../project/starters/m08-l03-frontend-canary.yaml)
- Arbeitsdatei: `project/playground/k8s/35-frontend-canary-deployment.yaml` (neu, wird am Ende wieder gelöscht)
- Prüfen: `kubectl rollout history deployment/hello-frontend` zeigt Revision `1` mit „Start mit v1"; `http://localhost:30080` zeigt „Hello-App v2".
- Stand aus Lab 8.2 wiederherstellen (falls nötig): `kubectl apply -f examples/m08-deployments/l02-rollouts/`. Gibt es danach keine Revision mit `v1`, in Aufgabe 1 statt `undo` den Befehl `kubectl set image deployment/hello-frontend frontend=hello-frontend:v1` verwenden.

## Aufgaben

1. Setze `hello-frontend` mit `kubectl rollout undo deployment/hello-frontend --to-revision=1` auf `v1` zurück und warte mit `kubectl rollout status deployment/hello-frontend`. Prüfe im Browser, dass die Seite hellblau „Hello-App v1" zeigt.
2. Kopiere den Starter nach `playground/k8s/35-frontend-canary-deployment.yaml`, ergänze die Labels in `selector` und `template` und wende die Datei an. Zeige mit `kubectl get pods -l app=hello-frontend -L version` alle Frontend-Pods mit ihrer Version.
3. Zähle die Verteilung mit 40 Anfragen: `for i in $(seq 1 40); do curl -s http://localhost:30080/ | grep -m1 -o 'Hello-App v[0-9]'; done | sort | uniq -c`.
4. Schalte den Service auf `v2` um: `kubectl patch service frontend -p '{"spec":{"selector":{"version":"v2"}}}'`, zähle erneut mit der Schleife aus Aufgabe 3 und schalte mit `kubectl patch service frontend -p '{"spec":{"selector":{"version":null}}}'` zurück.
5. Schließe den Umstieg ab: Wende `playground/k8s/30-frontend-deployment.yaml` an (die Datei enthält seit Lab 8.2 `v2`), warte mit `rollout status`, lösche den Canary mit `kubectl delete -f playground/k8s/35-frontend-canary-deployment.yaml` und danach die Datei mit `rm`. Zähle ein letztes Mal.

## Checkpoint

- Aufgabe 2: vier Frontend-Pods, drei mit `VERSION v1`, einer `hello-frontend-canary-…` mit `v2`.
- Aufgabe 3: ungefähr dreimal so viele `v1` wie `v2` (z. B. 29 zu 11).
- Aufgabe 4: nach dem Umschalten nur `Hello-App v2` (40 Treffer); nach dem Zurückschalten zeigt `kubectl get service frontend -o jsonpath='{.spec.selector}'` wieder nur `app`.
- Aufgabe 5: `kubectl get deploy` zeigt nur `hello-backend` und `hello-frontend 3/3`; die Zählung zeigt nur `Hello-App v2`.

## Abschlusskriterien

- Kein Deployment `hello-frontend-canary` und keine Datei `35-frontend-canary-deployment.yaml` mehr.
- `hello-frontend` läuft mit 3 Pods `hello-frontend:v2`; der Service `frontend` wählt nur nach `app: hello-frontend`.

## Fallback

- Fertiger Canary: [`project/examples/m08-deployments/l03-versions/canary/35-frontend-canary-deployment.yaml`](../../project/examples/m08-deployments/l03-versions/canary/35-frontend-canary-deployment.yaml)
- Endstand: `kubectl apply -f examples/m08-deployments/l03-versions/` und `kubectl delete deployment hello-frontend-canary --ignore-not-found`.
- Service nach einem verunglückten Patch reparieren: `kubectl apply -f examples/m08-deployments/l03-versions/40-frontend-service.yaml`.
