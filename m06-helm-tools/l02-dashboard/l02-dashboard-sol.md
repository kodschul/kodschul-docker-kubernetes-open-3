# Lab 6.2 – Lösung: Kubernetes Dashboard und Port-Forward

Alle Befehle laufen im Ordner `project/`. Zeitstempel, Pod-Endungen, Token und Messwerte weichen im eigenen Cluster ab.

## Aufgabe 1: Dashboard per Helm installieren

```bash
helm repo add kubernetes-dashboard https://kubernetes-retired.github.io/dashboard/
helm repo update
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --version 7.14.0 -n kubernetes-dashboard --create-namespace
```

```text
"kubernetes-dashboard" has been added to your repositories
…
Update Complete. ⎈Happy Helming!⎈
NAME: kubernetes-dashboard
LAST DEPLOYED: Tue Nov 24 10:51:40 2026
NAMESPACE: kubernetes-dashboard
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
*************************************************************************************************
*** PLEASE BE PATIENT: Kubernetes Dashboard may need a few minutes to get up and become ready ***
*************************************************************************************************

Congratulations! You have just installed Kubernetes Dashboard in your cluster.

To access Dashboard run:
  kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
…
Dashboard will be available at:
  https://localhost:8443
```

```bash
kubectl get pods -n kubernetes-dashboard
```

```text
NAME                                                    READY   STATUS    RESTARTS   AGE
kubernetes-dashboard-api-6b9c7d8f4-2kq7x                1/1     Running   0          62s
kubernetes-dashboard-auth-7f5d9c6b8-m4tzp               1/1     Running   0          62s
kubernetes-dashboard-kong-6c8f7d5b9-r8wqn               1/1     Running   0          62s
kubernetes-dashboard-metrics-scraper-5d6c8b7f9-xj2lc    1/1     Running   0          62s
kubernetes-dashboard-web-8d4f6c7b5-p9v3h                1/1     Running   0          62s
```

Die NOTES des Charts nennen bereits den Port-Forward-Befehl aus Aufgabe 3.

## Aufgabe 2: Zugangskonto und Token

```bash
kubectl apply -f examples/m06-helm-tools/l02-dashboard/dashboard-admin.yaml
kubectl -n kubernetes-dashboard create token admin-user
```

```text
serviceaccount/admin-user created
clusterrolebinding.rbac.authorization.k8s.io/admin-user created
eyJhbGciOiJSUzI1NiIsImtpZCI6Ik…
```

Der Token ist eine einzige lange Zeile aus drei Teilen, getrennt durch Punkte. Er gilt nur begrenzt; nach Ablauf den Befehl erneut ausführen.

## Aufgabe 3: Port-Forward und Zertifikatswarnung

Zweites Terminal:

```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
```

```text
Forwarding from 127.0.0.1:8443 -> 8443
Forwarding from [::1]:8443 -> 8443
Handling connection for 8443
```

`-> 8443` ist der Port im Kong-Pod, auf den der Service-Port 443 zeigt. `https://localhost:8443` zeigt zuerst eine Warnung („Ihre Verbindung ist nicht privat" / „Warnung: Mögliches Sicherheitsrisiko erkannt"), weil Kong ein selbstsigniertes Zertifikat nutzt. Chrome/Edge: **Erweitert** > **Weiter zu localhost (unsicher)**; Firefox: **Erweitert** > **Risiko akzeptieren und fortfahren**. Danach erscheint die Anmeldeseite mit dem Feld **Bearer token**.

## Aufgabe 4: Anmelden und kube-system ansehen

Token aus Aufgabe 2 in **Bearer token** einfügen, **Sign in**. Oben in der Namespace-Auswahl `kube-system` wählen, links **Workloads** > **Pods**:

| Pod in der Liste | Komponente |
| --- | --- |
| `kube-apiserver-docker-desktop` | API-Server |
| `etcd-docker-desktop` | etcd |
| `kube-scheduler-docker-desktop` | Scheduler |
| `kube-controller-manager-docker-desktop` | Controller-Manager |
| `metrics-server-5d8f7c6b9d-x7k2p` | metrics-server aus Lab 6.1, z. B. CPU `4m`, Speicher `19Mi` |

Die Spalten **CPU Usage** und **Memory Usage** zeigen dieselben Werte wie `kubectl top pods -n kube-system`; das Dashboard liest sie über den metrics-server. Ein Klick auf einen Pod zeigt Details, Events und über das Log-Symbol die Ausgabe wie `kubectl logs`.

## Aufgabe 5: Tunnel beenden

Nach **Strg+C** im zweiten Terminal meldet der Browser beim Neuladen `localhost hat die Verbindung abgelehnt` (`ERR_CONNECTION_REFUSED`). Das Dashboard läuft im Cluster weiter; nur der private Tunnel ist weg. Erneuter Zugang: Port-Forward neu starten, bei abgelaufenem Token auch einen neuen Token erzeugen.
