# Lab 6.1 – Lösung: metrics-server mit Helm installieren

Alle Befehle laufen im Ordner `project/`. Zeitstempel, Pod-Endungen und Messwerte weichen im eigenen Cluster ab.

## Aufgabe 1: Repository eintragen und suchen

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm search repo metrics-server
```

```text
"metrics-server" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "metrics-server" chart repository
Update Complete. ⎈Happy Helming!⎈
NAME                         	CHART VERSION	APP VERSION	DESCRIPTION
metrics-server/metrics-server	3.14.0       	0.9.0      	Metrics Server is a scalable, efficient source ...
```

`metrics-server/metrics-server` heißt: Repository-Kurzname / Chart-Name. Die Chart-Version (3.14.0) zählt die Paketversion, die App-Version (0.9.0) die Version des metrics-servers selbst. Stand: 24.11.2026.

## Aufgabe 2: Chart installieren

```bash
helm install metrics-server metrics-server/metrics-server --version 3.14.0 \
  -n kube-system --set 'args={--kubelet-insecure-tls}'
```

```text
NAME: metrics-server
LAST DEPLOYED: Tue Nov 24 10:12:03 2026
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
***********************************************************************
* Metrics Server                                                      *
***********************************************************************
  Chart version: 3.14.0
  App version:   0.9.0
  Image tag:     registry.k8s.io/metrics-server/metrics-server:v0.9.0
***********************************************************************
```

Gleichwertig mit der Werte-Datei:

```bash
helm install metrics-server metrics-server/metrics-server --version 3.14.0 \
  -n kube-system -f examples/m06-helm-tools/l01-helm/metrics-server-values.yaml
```

`-n kube-system` braucht kein `--create-namespace`, weil der Namespace immer existiert.

## Aufgabe 3: Release und Pod prüfen

```bash
helm list -A
helm get values metrics-server -n kube-system
kubectl get pods -n kube-system
```

```text
NAME          	NAMESPACE  	REVISION	UPDATED                             	STATUS  	CHART                	APP VERSION
metrics-server	kube-system	1       	2026-11-24 10:12:03.512 +0100 CET	deployed	metrics-server-3.14.0	0.9.0
USER-SUPPLIED VALUES:
args:
- --kubelet-insecure-tls
NAME                                     READY   STATUS    RESTARTS   AGE
coredns-7db6d8ff4d-k2m9x                 1/1     Running   0          14h
…
metrics-server-5d8f7c6b9d-x7k2p          1/1     Running   0          58s
…
```

`helm get values` zeigt nur die eigenen Werte; alle übrigen kommen aus den Standardwerten des Charts.

## Aufgabe 4: Messwerte anzeigen

```bash
kubectl top nodes
kubectl top pods -A
```

```text
NAME             CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)
docker-desktop   412m         5%       2675Mi          34%

NAMESPACE     NAME                                     CPU(cores)   MEMORY(bytes)
kube-system   coredns-7db6d8ff4d-k2m9x                 3m           14Mi
kube-system   coredns-7db6d8ff4d-wq5hl                 3m           15Mi
kube-system   etcd-docker-desktop                      28m          48Mi
kube-system   kube-apiserver-docker-desktop            71m          312Mi
kube-system   kube-controller-manager-docker-desktop   22m          55Mi
kube-system   kube-proxy-7xq2d                         1m           18Mi
kube-system   kube-scheduler-docker-desktop            5m           22Mi
kube-system   metrics-server-5d8f7c6b9d-x7k2p          4m           19Mi
kube-system   storage-provisioner                      1m           9Mi
kube-system   vpnkit-controller                        1m           12Mi
```

- `412m` heißt 412 Millicores, also etwa 0,4 CPU-Kerne; die Prozentwerte beziehen sich auf die Kapazität des Nodes.
- Meldet `kubectl top` `error: Metrics API not available`, ist der metrics-server noch nicht bereit: eine Minute warten.

## Aufgabe 5: höchster Speicherverbrauch

Im Beispiel ist es `kube-apiserver-docker-desktop` mit `312Mi`: Der API-Server hält Daten aller Objekte im Speicher, weil jede Anfrage über ihn läuft (Lab 5.1). Sortiert zeigt es `kubectl top pods -A --sort-by=memory`.
