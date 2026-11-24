# Lab 6.2 – Übung: Kubernetes Dashboard und Port-Forward

**Dauer:** ca. 12 Minuten
**Ändert die Hello-App-Projektbasis?** Nein — das Dashboard läuft im eigenen Namespace `kubernetes-dashboard`; Modul 7 zeigt darin die Pods und Services der Hello-App.

## Vorbereitung

- Terminal im Ordner `project/` öffnen; metrics-server aus Lab 6.1 installiert (`kubectl top nodes` zeigt Werte).
- Vorbereitetes Manifest: [`project/examples/m06-helm-tools/l02-dashboard/dashboard-admin.yaml`](../../project/examples/m06-helm-tools/l02-dashboard/dashboard-admin.yaml) (nur lesen und anwenden, nicht ändern).
- Ein zweites Terminal im selben Ordner bereithalten (für das Port-Forward).

## Aufgaben

1. Trage das Repository `kubernetes-dashboard` mit der Adresse `https://kubernetes-retired.github.io/dashboard/` ein, lade die Chart-Liste neu und installiere das Chart `kubernetes-dashboard/kubernetes-dashboard` in der Version `7.14.0` als Release `kubernetes-dashboard` in den neuen Namespace `kubernetes-dashboard`. Warte, bis `kubectl get pods -n kubernetes-dashboard` fünf Pods mit `Running` zeigt.
2. Wende `dashboard-admin.yaml` an und erzeuge mit `kubectl -n kubernetes-dashboard create token admin-user` einen Token.
3. Starte im zweiten Terminal `kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443`, öffne `https://localhost:8443` und bestätige die Zertifikatswarnung des Browsers.
4. Füge den Token in das Feld **Bearer token** ein, wähle **Sign in**, danach oben den Namespace `kube-system` und öffne **Workloads** > **Pods**. Finde die Pods der Control Plane aus Lab 5.2 und den `metrics-server` aus Lab 6.1 mit seinen CPU- und Speicherwerten.
5. Beende das Port-Forward mit **Strg+C** und lade die Seite neu.

## Checkpoint

- `helm list -n kubernetes-dashboard` zeigt `kubernetes-dashboard` mit `STATUS deployed` und `CHART kubernetes-dashboard-7.14.0`.
- `kubectl get pods -n kubernetes-dashboard` zeigt fünf Pods (`…-api-…`, `…-auth-…`, `…-kong-…`, `…-metrics-scraper-…`, `…-web-…`), alle `Running`.
- Nach der Anmeldung zeigt das Dashboard in `kube-system` die Pods `kube-apiserver-docker-desktop`, `etcd-docker-desktop` und `metrics-server-…`.
- Nach Strg+C meldet der Browser, dass `localhost:8443` nicht erreichbar ist.

## Abschlusskriterien

- Das Dashboard ist installiert, die Anmeldung per Token hat funktioniert, und es zeigt die Systemkomponenten des eigenen Clusters.

## Fallback

- `kubernetes-retired.github.io` nicht erreichbar oder Images fehlen (Projekt archiviert): die Pods in `kube-system` mit `kubectl get pods -n kube-system` und `kubectl top pods -n kube-system` ansehen; dieselben Informationen zeigt die Desktop-App Headlamp ohne Installation im Cluster.
