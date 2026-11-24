# Lab 7.3 – Übung: NodePort für das Frontend

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — neuer Service `frontend` vom Typ NodePort; die Hello-Seite ist ohne Port-Forward unter `http://localhost:30080` erreichbar. Modul 8 ersetzt die einzelnen Pods hinter den Services.

## Vorbereitung

- Terminal im Ordner `project/` öffnen; `kubectl get pods` zeigt `backend`, `backend-2` und `frontend`, `kubectl get service backend` existiert (Lab 7.2).
- Starter: [`project/starters/m07-l03-frontend-service.yaml`](../../project/starters/m07-l03-frontend-service.yaml)
- Arbeitsdatei: `project/playground/k8s/40-frontend-service.yaml`
- Stand aus Lab 7.2 wiederherstellen (falls nötig): `kubectl delete pods --all`, dann `kubectl apply -f examples/m07-pods-services/l02-clusterip/`

## Aufgaben

1. Kopiere den Starter nach `playground/k8s/40-frontend-service.yaml`, ergänze Typ und `nodePort` und wende die Datei an. Zeige mit `kubectl get services` beide Services mit Typ und Ports an.
2. Öffne `http://localhost:30080` im Browser und lade die Seite mehrmals neu.
3. Beende das Port-Forward aus Lab 7.2 mit **Strg+C** und lade `http://localhost:8080` und `http://localhost:30080` neu.
4. Lösche den Frontend-Pod, lege ihn mit `playground/k8s/30-frontend-pod.yaml` neu an und lade `http://localhost:30080` erneut.
5. Öffne im Dashboard (Lab 6.2) im Namespace `hello` den Bereich **Service** > **Services** und vergleiche Typ, ClusterIP und Ports von `backend` und `frontend`.

## Checkpoint

- `kubectl get services` zeigt `backend` mit `ClusterIP`, `80/TCP` und `frontend` mit `NodePort`, `80:30080/TCP`.
- `http://localhost:30080` zeigt die Hello-Seite mit Backend-Antwort, ohne laufendes Port-Forward.
- Nach dem Beenden des Port-Forwards lädt `localhost:8080` nicht mehr, `localhost:30080` weiterhin.
- Nach dem Neuanlegen des Frontend-Pods antwortet `localhost:30080` ohne weitere Änderung; die Frontend-IP auf der Seite ist neu.

## Abschlusskriterien

- `playground/k8s/40-frontend-service.yaml` existiert mit `type: NodePort` und `nodePort: 30080`; die Hello-Seite ist unter `http://localhost:30080` erreichbar.

## Fallback

- `localhost:30080` lädt nicht (Docker Desktop leitet den NodePort nicht weiter): in `40-frontend-service.yaml` `type: LoadBalancer`, `port: 8080` setzen, die Zeile `nodePort` entfernen, Service löschen und neu anwenden, dann `http://localhost:8080`. Alternativ `kubectl port-forward service/frontend 8080:80`.
- Fertiger Stand: [`project/examples/m07-pods-services/l03-nodeport/`](../../project/examples/m07-pods-services/l03-nodeport/)
