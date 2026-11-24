<div align="center">

<img src="assets/kodschul-logo.png" alt="Kodschul" width="220" />

# Docker & Kubernetes Grundlagen

2-Tage-Workshop · Docker Engine 29, Compose, Kubernetes 1.3x, Helm 4 · Deutsch

**Eigene Container-Images bauen und als Anwendung im Kubernetes-Cluster betreiben**

</div>

---

[Worum es geht](#worum-es-geht) · [Start](#start) · [Tag 1](#tag-1) · [Tag 2](#tag-2) · [Hilfe](#hilfe)

## Worum es geht

- Container lösen das „Works on my machine"-Problem; Kubernetes betreibt sie auf vielen Servern.
- Ein durchgehendes Projekt: die Hello-App aus Frontend und Backend.
- Tag 1 baut die Images und betreibt sie mit Docker Compose, Tag 2 betreibt dieselben Images im Cluster.
- Stand November 2026: Compose v2, `registry:3`, Kubernetes 1.35–1.37, Helm 4.

| | |
| --- | --- |
| **Für** | Softwareentwicklung, DevOps und IT-Betrieb ohne Docker- und Kubernetes-Erfahrung |
| **Vorkenntnisse** | Terminal-Grundlagen; Programmierkenntnisse nicht nötig |
| **Werkzeuge** | Docker Desktop mit Kubernetes, kubectl, Helm 4, VS Code, Browser |
| **Projekt** | Hello-App: zwei Python/Flask-Dienste, vom Dockerfile zum Deployment mit Autoscaling |
| **Material** | Handout pro Lab, Cheatsheet pro Modul, fertiger Projektstand für jedes Lab |

## Start

1. Rechner einrichten und Images vorab laden: [Setup und Installation](00-setup-and-installation.md)
2. Ziel und Tagesablauf lesen: [Kursüberblick](m00-overview/overview.md)
3. Projektordner öffnen: [Hello-App](project/README.md), im Terminal `cd project`
4. Mit dem ersten Lab starten: [Lab 1.1: Warum Container?](m01-containers/l01-why-containers/l01-why-containers-thx.md)

## Tag 1

| Modul | Kernthemen | Ergebnis |
| --- | --- | --- |
| 1 [Container-Grundlagen](m01-containers/l01-why-containers/l01-why-containers-thx.md) | Warum Container, CLI, Logs, `exec`, Bind Mount | nginx im Browser, Unterschied Container/Host erlebt |
| 2 [Images und Registry](m02-images/l01-layers/l01-layers-thx.md) | Layer, Dockerfile, Build-Args, Registry, Image-Scan | `hello-backend:v1`, `hello-frontend:v1`/`v2` in der lokalen Registry |
| 3 [Docker Compose](m03-compose/l01-compose-basics/l01-compose-basics-thx.md) | Compose-Datei, Healthcheck, Watch, Replikas, Volumes | Hello-App mit einem Befehl, Daten bleiben |
| 4 [Netzwerke und Fehlersuche](m04-networking/l01-networks/l01-networks-thx.md) | Bridge, eigene Netzwerke, Fehlerbilder, Limits, Swarm | Backend nur intern, Fehler behoben, Swarm-Stack gesehen |

## Tag 2

| Modul | Kernthemen | Ergebnis |
| --- | --- | --- |
| 5 [Kubernetes-Grundlagen](m05-kubernetes-basics/l01-why-kubernetes/l01-why-kubernetes-thx.md) | Warum Kubernetes, Architektur, kubectl, Ressourcen, Manifeste | Cluster bereit, Namespace `hello` |
| 6 [Helm und Cluster-Werkzeuge](m06-helm-tools/l01-helm/l01-helm-thx.md) | Helm, metrics-server, Dashboard, Port-Forward | `kubectl top` und Dashboard im Browser |
| 7 [Pods und Services](m07-pods-services/l01-pods/l01-pods-thx.md) | Pods, Labels, ClusterIP, NodePort, Ingress | Hello-App unter `localhost:30080` |
| 8 [Deployments und Health Checks](m08-deployments/l01-replicasets/l01-replicasets-thx.md) | ReplicaSet, Rollout, Rollback, Canary, Probes, HPA | Update ohne Ausfall, Autoscaling unter Last |
| 9 [Konfiguration, Speicher, Jobs](m09-config-storage/l01-configmaps/l01-configmaps-thx.md) | ConfigMap, Secret, Volumes, PV/PVC, Job, CronJob | Farbe aus ConfigMap, Passwort aus Secret, Log auf PVC, Backup per CronJob |
| 10 [Helm-Chart](m10-helm-chart/l01-own-chart/l01-own-chart-thx.md) | eigenes Chart, Values, Upgrade, Rollback | Hello-App mit einem Befehl installiert |

- Jedes Lab ist eine Seite mit Theorie, dazu Übung und Lösung; Cheatsheets liegen im jeweiligen Modulordner.
- Alle Labs mit Zeiten: [Module und Labs](m00-overview/topics.md).

## Hilfe

- **Projektstand wiederherstellen:** jeder Lab-Stand liegt fertig unter `project/examples/<modul>/<lab>/`; Compose-Dateien nach `playground/` kopieren, Kubernetes-Manifeste direkt anwenden:

  ```bash
  cd project
  kubectl apply -f examples/m08-deployments/l02-rollouts/
  ```

- **Images fehlen** (neuer Rechner, Speicher aufgeräumt): `bash build-images.sh` im Ordner `project/` baut `hello-backend:v1`, `hello-frontend:v1` und `hello-frontend:v2` neu.
- **Lösungen vergleichen:** jede Übung hat eine Lösung mit Befehlen und erwarteter Ausgabe; die Projektdateien je Lab stehen in der [Projektübersicht](project/README.md).
- **Nachschlagen:** [Glossar](m00-overview/glossary.md) · [FAQ](m00-overview/faq.md) · [Best Practices](m00-overview/best-practices.md)

---

<div align="center">

<sub>© Nextise GmbH · <a href="https://www.kodschul.com">kodschul.com</a> · Kompetenz aufbauen – von der sicheren KI-Anwendung bis zur modernen IT-Basis</sub>

</div>
