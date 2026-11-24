# Helm und Cluster-Werkzeuge – Cheatsheet (Modul 6)

Alle Befehle in der Kurs-Shell (bash), Dateipfade relativ zum Ordner `project/`. Versionen Stand: 24.11.2026.

## Repositories und Suche

| Befehl | Wirkung |
| --- | --- |
| `helm version --short` | Helm-Version, muss mit `v4.` beginnen |
| `helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/` | Repository unter dem Kurznamen `metrics-server` eintragen |
| `helm repo add kubernetes-dashboard https://kubernetes-retired.github.io/dashboard/` | Repository des Dashboards eintragen |
| `helm repo list` | eingetragene Repositories |
| `helm repo update` | Chart-Listen aller Repositories neu laden |
| `helm search repo metrics-server` | Chart suchen, mit Chart- und App-Version |
| `helm search repo metrics-server --versions` | auch ältere Versionen |
| `helm show values metrics-server/metrics-server --version 3.14.0` | Standardwerte eines Charts |

## Releases

| Befehl | Wirkung |
| --- | --- |
| `helm install <release> <chart> --version <v> -n <ns>` | Release installieren (Revision 1) |
| `… -n <ns> --create-namespace` | Namespace dabei anlegen |
| `… --set 'args={--kubelet-insecure-tls}'` | einen Wert setzen; `{a,b}` = Liste |
| `… -f datei.yaml` | Werte aus einer Datei |
| `helm upgrade <release> <chart> --version <v> -n <ns> …` | Release mit neuen Werten ändern (neue Revision) |
| `helm list -A` | alle Releases in allen Namespaces |
| `helm list -n kube-system` | Releases eines Namespace |
| `helm get values <release> -n <ns>` | selbst gesetzte Werte |
| `helm uninstall <release> -n <ns>` | Release mit allen Objekten entfernen |

## Releases im Kurs

| Release | Befehl |
| --- | --- |
| metrics-server (Lab 6.1) | `helm install metrics-server metrics-server/metrics-server --version 3.14.0 -n kube-system --set 'args={--kubelet-insecure-tls}'` |
| Dashboard (Lab 6.2) | `helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --version 7.14.0 -n kubernetes-dashboard --create-namespace` |

## Messwerte (metrics-server)

| Befehl | Wirkung |
| --- | --- |
| `kubectl top nodes` | CPU und Speicher je Node |
| `kubectl top pods -A` | CPU und Speicher aller Pods |
| `kubectl top pods -A --sort-by=memory` | sortiert nach Speicher (`--sort-by=cpu` nach CPU) |

## Dashboard und Port-Forward

| Befehl | Wirkung |
| --- | --- |
| `kubectl apply -f examples/m06-helm-tools/l02-dashboard/dashboard-admin.yaml` | Zugangskonto `admin-user` mit allen Rechten (nur Übungscluster) |
| `kubectl -n kubernetes-dashboard create token admin-user` | zeitlich begrenzten Token erzeugen |
| `kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443` | Tunnel; danach `https://localhost:8443` öffnen |
| **Strg+C** im Port-Forward-Terminal | Tunnel beenden |
| `kubectl get pods -n kubernetes-dashboard` | fünf Dashboard-Pods (`api`, `auth`, `kong`, `metrics-scraper`, `web`) |
| `helm uninstall kubernetes-dashboard -n kubernetes-dashboard` | Dashboard entfernen |
