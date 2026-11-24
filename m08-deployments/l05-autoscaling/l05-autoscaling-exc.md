# Lab 8.5 – Übung: Autoscaling mit HPA

**Dauer:** ca. 10 Minuten (das Herunterskalieren wird nach der Pause geprüft)
**Ändert die Hello-App-Projektbasis?** Ja — `hello-frontend` hat Requests und Limits, kein Feld `replicas` mehr und einen HPA `hello-frontend` (1–5 Pods, 50 % CPU); Lab 9.1 löscht den HPA wieder.

## Vorbereitung

- Zwei Terminals (bash) im Ordner `project/` öffnen.
- Starter: [`project/starters/m08-l05-frontend-deployment.yaml`](../../project/starters/m08-l05-frontend-deployment.yaml) (Requests und Limits fertig eingetragen, `replicas` entfernt)
- Arbeitsdatei: `project/playground/k8s/30-frontend-deployment.yaml` (wird ersetzt)
- Prüfen: `kubectl top pods` zeigt Werte (metrics-server aus Lab 6.1); das Image `busybox:1.37` ist lokal vorhanden (`docker images busybox`).
- Stand aus Lab 8.4 wiederherstellen (falls nötig): `kubectl apply -f examples/m08-deployments/l04-probes/`

## Aufgaben

1. Kopiere den Starter nach `playground/k8s/30-frontend-deployment.yaml` (neu gegenüber Lab 8.4: Block `resources`, kein `replicas`), wende die Datei an und warte mit `kubectl rollout status deployment/hello-frontend`. Zeige `kubectl get deploy hello-frontend` und `kubectl top pods -l app=hello-frontend`.
2. Lege den HPA an: `kubectl autoscale deployment hello-frontend --cpu=50% --min=1 --max=5`. Zeige ihn mit `kubectl get hpa` an.
3. Starte im zweiten Terminal `kubectl get hpa -w`. Starte im ersten Terminal den Lastgenerator: `kubectl run load --image=busybox:1.37 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://frontend/work; done"`.
4. Beobachte zwei bis drei Minuten lang `TARGETS` und `REPLICAS` im zweiten Terminal; zeige zwischendurch `kubectl get pods -l app=hello-frontend` und `kubectl top pods -l app=hello-frontend`.
5. Beende die Last mit `kubectl delete pod load` und beende das Watch mit **Strg+C**. Prüfe nach der Pause mit `kubectl get hpa` und `kubectl describe hpa hello-frontend` (Events am Ende), dass die Replikazahl wieder gesunken ist.

## Checkpoint

- Aufgabe 1: `hello-frontend` zeigt `READY 1/1` (ohne `replicas` gilt der Standardwert 1); `kubectl top pods` zeigt wenige Millicores und rund 40 Mi.
- Aufgabe 2: `TARGETS cpu: 1%/50%` (oder ähnlich niedrig, in der ersten Minute `<unknown>`), `MINPODS 1`, `MAXPODS 5`, `REPLICAS 1`.
- Aufgabe 4: `TARGETS` steigt deutlich über `50%` (bis rund `450%`), `REPLICAS` wächst bis `5`; alle neuen Pods werden `1/1`.
- Aufgabe 5: `TARGETS` fällt sofort, `REPLICAS` erst nach etwa 5 Minuten; die Events zeigen `New size: 5; reason: cpu resource utilization (percentage of request) above target` und später `New size: 1; reason: All metrics below target`.

## Abschlusskriterien

- `kubectl get hpa hello-frontend` existiert und zeigt ohne Last `REPLICAS 1`; der Pod `load` ist gelöscht.
- `playground/k8s/30-frontend-deployment.yaml` enthält `resources` mit Requests und Limits und kein Feld `replicas`.

## Fallback

- Steigt die Last nicht über 50 %: einen zweiten Lastgenerator mit dem Namen `load2` starten und später ebenfalls löschen.
- `kubectl autoscale` meldet `unknown flag: --cpu` (ältere kubectl-Version): `--cpu-percent=50` verwenden oder `kubectl apply -f examples/m08-deployments/l05-autoscaling/50-frontend-hpa.yaml`.
- `busybox:1.37` lässt sich nicht laden: `docker pull busybox:1.37` (ggf. nach `docker login`) oder `bash pull-images.sh`.
- Endstand: `kubectl apply -f examples/m08-deployments/l05-autoscaling/` (legt auch den HPA an).
