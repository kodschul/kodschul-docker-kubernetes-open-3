# Lab 8.4 – Übung: Health Checks mit Probes

**Dauer:** ca. 12 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — `hello-frontend` hat eine Readiness- und eine Liveness-Probe auf `/healthz`; Lab 8.5 ergänzt Requests und Limits.

## Vorbereitung

- Zwei Terminals (bash) im Ordner `project/` öffnen.
- Starter: [`project/starters/m08-l04-frontend-deployment.yaml`](../../project/starters/m08-l04-frontend-deployment.yaml) (Stand nach Lab 8.3 ohne Probes)
- Arbeitsdatei: `project/playground/k8s/30-frontend-deployment.yaml` (wird ersetzt)
- Prüfen: `kubectl get deploy` zeigt `hello-backend 2/2` und `hello-frontend 3/3`, kein `hello-frontend-canary`.
- Stand aus Lab 8.3 wiederherstellen (falls nötig): `kubectl apply -f examples/m08-deployments/l03-versions/`

## Aufgaben

1. Kopiere den Starter nach `playground/k8s/30-frontend-deployment.yaml`, ergänze die beiden Probes nach den TODO-Kommentaren und wende die Datei an. Warte mit `kubectl rollout status deployment/hello-frontend` und zeige die Probes mit `kubectl describe deployment hello-frontend | grep -E "Liveness|Readiness"`.
2. Starte im zweiten Terminal `kubectl get pods -l app=hello-frontend -w`. Wähle im ersten Terminal mit `kubectl get pods -l app=hello-frontend` einen Pod und löse dort den Ausfall aus: `kubectl exec <pod> -- wget -qO- http://127.0.0.1/fail`.
3. Sobald der Pod `0/1` meldet: Zeige mit `kubectl describe endpointslices -l kubernetes.io/service-name=frontend` die Endpunkte mit ihren `Conditions` und rufe die Seite zehnmal ab: `for i in $(seq 1 10); do curl -s http://localhost:30080/ | grep -o 'Frontend:</b> [^<]*'; done`.
4. Warte, bis der Pod im zweiten Terminal `RESTARTS 1` und wieder `1/1` zeigt, und lies mit `kubectl describe pod <pod>` die Events am Ende der Ausgabe. Beende das Watch mit **Strg+C**.

## Checkpoint

- Aufgabe 1: `Liveness: http-get http://:80/healthz … period=10s #success=1 #failure=3` und `Readiness: http-get http://:80/healthz … period=5s #success=1 #failure=2`.
- Aufgabe 2: Der Befehl meldet `/healthz meldet jetzt 500`; nach etwa 10 Sekunden zeigt der gewählte Pod `READY 0/1`.
- Aufgabe 3: Die IP des gewählten Pods steht mit `Ready: false` in der EndpointSlice, die beiden anderen mit `Ready: true`; alle zehn Antworten kommen von den beiden anderen Pods.
- Aufgabe 4: Events `Readiness probe failed: HTTP probe failed with statuscode: 500`, `Liveness probe failed: …` und `Container frontend failed liveness probe, will be restarted`.

## Abschlusskriterien

- `kubectl get pods -l app=hello-frontend` zeigt drei Pods mit `1/1`, einer davon mit `RESTARTS 1`.
- `playground/k8s/30-frontend-deployment.yaml` enthält `readinessProbe` und `livenessProbe` auf `/healthz`, Port 80.

## Fallback

- `apply` meldet einen YAML-Fehler: Einrückung mit [`project/examples/m08-deployments/l04-probes/30-frontend-deployment.yaml`](../../project/examples/m08-deployments/l04-probes/30-frontend-deployment.yaml) vergleichen oder die Datei kopieren.
- `kubectl exec` klappt nicht: `kubectl port-forward pod/<pod> 8090:80` im zweiten Terminal starten und `curl http://localhost:8090/fail` aufrufen.
