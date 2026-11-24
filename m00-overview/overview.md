# Docker & Kubernetes Grundlagen – Kursüberblick

## Die Entwicklung von Docker und Kubernetes

- Programme laufen auf jedem Rechner anders: „Works on my machine".
- 2013 macht Docker Container einfach: bauen, teilen, starten mit einem Befehl.
- 2014/2015 entsteht Kubernetes aus Googles Borg und wird zum Standard für viele Server.
- 2026: 59 % nutzen Docker intensiv (Stack Overflow Survey 2026).
- 82 % der Container-Nutzer betreiben Kubernetes in Produktion (CNCF Survey 2025).

## Was sind Docker und Kubernetes?

- **Docker** baut Images und startet sie als Container auf einem Rechner.
- **Kubernetes** betreibt Container auf einem Cluster: verteilen, ersetzen, skalieren, aktualisieren.
- Vergleich: Container = genormte Schiffskiste, Kubernetes = Hafenleitstelle.

| Begriff | Bedeutung |
| --- | --- |
| Image | unveränderliche Vorlage aus Dateien und Startbefehl |
| Container | laufende Instanz eines Images |
| Compose | mehrere Container aus einer YAML-Datei starten |
| Pod | kleinste Einheit in Kubernetes: ein oder mehrere Container |
| Deployment | hält N Pods einer Version am Leben, rollt neue Versionen aus |
| Service | feste Adresse für wechselnde Pods |

Details: [Lab 1.1](../m01-containers/l01-why-containers/l01-why-containers-thx.md) · [Lab 5.1](../m05-kubernetes-basics/l01-why-kubernetes/l01-why-kubernetes-thx.md)

## Warum Container und Orchestrierung?

| Aufgabe | ohne Container | mit Docker | mit Kubernetes |
| --- | --- | --- | --- |
| Umgebung aufsetzen | Anleitung, Stunden | `docker compose up` | `kubectl apply -f` / `helm install` |
| gleiche Version überall | Hoffnung | dasselbe Image | dasselbe Image, viele Server |
| Absturz nachts | Bereitschaft ruft an | Neustart-Regel je Container | Ersatz-Pod automatisch |
| Lastspitze | Server nachkaufen | Replikas von Hand | Autoscaling |
| Update ohne Ausfall | Wartungsfenster | – | Rolling Update, Rollback |

## Ziel und Ergebnis

- Container über die CLI steuern, eigene Images bauen und ablegen.
- Mehrere Dienste mit Compose, Volumes und Netzwerken betreiben.
- Dieselben Images im Kubernetes-Cluster als Pods, Services und Deployments betreiben.
- Updates ohne Ausfall, Health Checks, Autoscaling, Konfiguration und Speicher einrichten.
- Software im Cluster mit Helm installieren.

## Projekt: Hello-App

- Zwei Python/Flask-Dienste: `hello-frontend` (Webseite) und `hello-backend` (JSON).
- Die Seite zeigt Version, Farbe, Name und IP: Replikas und Updates werden sichtbar.
- `access.log` zählt jeden Aufruf: verlorene und dauerhafte Daten werden sichtbar.

| Tag | Stand der Hello-App am Ende |
| --- | --- |
| 1 | Images `v1`/`v2`, Compose mit Healthcheck, Volume, eigenen Netzwerken, Limits |
| 2 | im Cluster: Deployments, Services, Probes, HPA, ConfigMap, Secret, PVC, CronJob |

Projektdateien: [project/README.md](../project/README.md)

## Tagesablauf

| Zeit | Tag 1 – Docker | Tag 2 – Kubernetes |
| --- | --- | --- |
| 09:00–10:30 | Auftakt, Modul 1 Container-Grundlagen | Modul 5 Grundlagen, Modul 6 Helm |
| 10:30–10:45 | Pause | Pause |
| 10:45–12:15 | Modul 2 Images und Registry | Modul 6 Dashboard, Modul 7 Pods und Services |
| 12:15–13:15 | Mittag | Mittag |
| 13:15–14:45 | Modul 3 Docker Compose | Modul 8 Deployments und Health Checks |
| 14:45–15:00 | Pause | Pause |
| 15:00–16:30 | Modul 4 Netzwerke, Fehlersuche, Swarm-Demo | Modul 8 Autoscaling, Modul 9 Konfiguration und Speicher, Modul 10 Helm-Chart |

Alle Labs mit Zeiten: [topics.md](topics.md)

## Arbeitsweise

- Jedes Lab: Theorie (`-thx.md`), Übung (`-exc.md`), Lösung (`-sol.md`); Demo-Labs nur Theorie mit Befehlen zum Nachmachen.
- Gearbeitet wird in `project/playground/`; Startdateien liegen in `project/starters/`.
- Jeder Lab-Stand liegt fertig in `project/examples/` zum Vergleichen und Wiederherstellen.

## Voraussetzungen

- Docker Desktop mit Kubernetes (Typ Kubeadm), Helm 4, VS Code.
- Terminal-Grundlagen; Programmierkenntnisse sind nicht nötig.
- Anleitung: [Setup und Installation](../00-setup-and-installation.md)
