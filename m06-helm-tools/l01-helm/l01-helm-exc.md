# Lab 6.1 – Übung: metrics-server mit Helm installieren

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Nein — der metrics-server läuft im Namespace `kube-system` und bleibt bis Kursende installiert; Lab 6.2 und Lab 8.5 nutzen seine Messwerte.

## Vorbereitung

- Terminal im Ordner `project/` öffnen; `kubectl get nodes` zeigt `docker-desktop` als `Ready`.
- `helm version --short` beginnt mit `v4.` (sonst [Setup](../../00-setup-and-installation.md#helm-4)).
- Starter: keiner. Werte-Datei zum Vergleich: [`project/examples/m06-helm-tools/l01-helm/metrics-server-values.yaml`](../../project/examples/m06-helm-tools/l01-helm/metrics-server-values.yaml)

## Aufgaben

1. Trage das Repository mit `helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/` ein, lade die Chart-Liste mit `helm repo update` und suche das Chart mit `helm search repo metrics-server`.
2. Installiere das Chart als Release `metrics-server` in der Version `3.14.0` in den Namespace `kube-system` und setze dabei den Wert `args` auf `{--kubelet-insecure-tls}` (Docker Desktop, prüfen).
3. Zeige mit `helm list -A` alle Releases an und mit `helm get values metrics-server -n kube-system` die selbst gesetzten Werte. Prüfe mit `kubectl get pods -n kube-system`, dass der Pod `metrics-server-…` läuft.
4. Warte etwa eine Minute und zeige mit `kubectl top nodes` den Verbrauch des Nodes und mit `kubectl top pods -A` den Verbrauch aller Pods an.
5. Finde in `kubectl top pods -A` den Pod mit dem höchsten Speicherverbrauch.

## Checkpoint

- `helm search repo metrics-server` zeigt `metrics-server/metrics-server` mit `CHART VERSION 3.14.0` und `APP VERSION 0.9.0`.
- `helm list -A` zeigt `metrics-server` im Namespace `kube-system` mit `REVISION 1`, `STATUS deployed` und `CHART metrics-server-3.14.0`.
- Der Pod `metrics-server-…` zeigt `READY 1/1` und `STATUS Running`.
- `kubectl top nodes` zeigt für `docker-desktop` Werte in den Spalten `CPU(cores)` und `MEMORY(bytes)`.

## Abschlusskriterien

- Der metrics-server ist als Helm-Release installiert, und `kubectl top` liefert CPU- und Speicherwerte.

## Fallback

- Kein Zugriff auf `kubernetes-sigs.github.io` (Proxy): Fehlermeldung von `helm repo add` notieren und die Werte-Datei aus `examples/` beim späteren Versuch mit `-f` nutzen; die Messwerte sind bis Lab 8.5 nicht zwingend nötig.
- Pod bleibt `0/1`: Wert `args` fehlt; `helm upgrade` mit demselben Chart, derselben Version und dem Wert `args` ausführen (siehe Typische Fehler im Theorieteil).
