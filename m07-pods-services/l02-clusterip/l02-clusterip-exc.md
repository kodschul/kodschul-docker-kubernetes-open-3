# Lab 7.2 – Übung: Service für das Backend

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — zweiter Backend-Pod `backend-2`, Service `backend`; das Frontend erreicht das Backend über `http://backend`. Lab 7.3 ergänzt einen Service für das Frontend.

## Vorbereitung

- Terminal im Ordner `project/` öffnen; `kubectl get pods` zeigt `backend` und `frontend` aus Lab 7.1.
- Starter: [`project/starters/m07-l02-backend-service.yaml`](../../project/starters/m07-l02-backend-service.yaml)
- Arbeitsdateien: `project/playground/k8s/11-backend-2-pod.yaml` (neu), `project/playground/k8s/20-backend-service.yaml` (neu), `project/playground/k8s/30-frontend-pod.yaml` (ändern)
- Stand aus Lab 7.1 wiederherstellen (falls nötig): `kubectl apply -f examples/m07-pods-services/l01-pods/10-backend-pod.yaml`; der Frontend-Pod entsteht in Aufgabe 3 neu.

## Aufgaben

1. Kopiere `playground/k8s/10-backend-pod.yaml` nach `playground/k8s/11-backend-2-pod.yaml`, ändere den Pod-Namen in `backend-2` (Labels unverändert) und wende die Datei an. Zeige mit `kubectl get pods -l app=hello-backend -o wide` beide Backend-Pods mit IP an.
2. Kopiere den Starter nach `playground/k8s/20-backend-service.yaml`, ergänze die TODOs und wende die Datei an. Zeige mit `kubectl get service backend` die ClusterIP und mit `kubectl get endpointslices -l kubernetes.io/service-name=backend` die Endpoints an.
3. Setze in `playground/k8s/30-frontend-pod.yaml` den Wert von `BACKEND_URL` auf `http://backend`, lösche den Frontend-Pod und lege ihn neu an. Starte das Port-Forward `pod/frontend 8080:80` neu und lade `http://localhost:8080` mehrmals.
4. Prüfe den DNS-Namen mit `kubectl exec frontend -- nslookup backend` und rufe das Backend mit `kubectl exec frontend -- wget -qO- http://backend.hello.svc.cluster.local/api` über den vollständigen Namen auf.
5. Ändere im Selector von `20-backend-service.yaml` den Wert in `hello-backnd`, wende die Datei an und prüfe EndpointSlice und Hello-Seite. Behebe den Fehler danach und wende die Datei erneut an.

## Checkpoint

- `kubectl get service backend` zeigt `TYPE ClusterIP` und `PORT(S) 80/TCP`.
- Die EndpointSlice listet zwei IPs, dieselben wie die Pods `backend` und `backend-2`.
- Die Hello-Seite zeigt unter **Backend** mal `backend`, mal `backend-2`, jeweils mit eigener IP.
- `nslookup backend` antwortet mit `backend.hello.svc.cluster.local` und der ClusterIP.
- Mit falschem Selector zeigt die EndpointSlice `<unset>` und die Seite `Backend nicht erreichbar (http://backend)`; nach der Korrektur sind beide IPs zurück.

## Abschlusskriterien

- `playground/k8s/20-backend-service.yaml` existiert mit Selector `app: hello-backend` und Port 80 → 80.
- Die Hello-Seite zeigt Antworten von beiden Backend-Pods, ohne dass eine Pod-IP im Frontend steht.

## Fallback

- Port 8080 belegt: `kubectl port-forward pod/frontend 8081:80` und `http://localhost:8081` öffnen.
- Fertiger Stand: [`project/examples/m07-pods-services/l02-clusterip/`](../../project/examples/m07-pods-services/l02-clusterip/); vorher die eigenen Pods löschen (`kubectl delete pods --all`), dann `kubectl apply -f examples/m07-pods-services/l02-clusterip/`.
