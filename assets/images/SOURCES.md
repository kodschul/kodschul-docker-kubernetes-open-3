# Bildquellen

Fremde Bilder sind per URL eingebunden (keine lokalen Kopien) und am 24.11.2026 per HTTP-GET geprüft (Status 200, `image/*`). Eigene Screenshots liegen unter `mNN/` und entstehen mit `scripts/capture.mjs` und den Definitionen in `scripts/shots/` des Kursordners.

## Bildquellen Modul 1 und 2

Externe Bilder sind per URL eingebunden; eigene Screenshots liegen unter `assets/images/m01/` und `assets/images/m02/` und entstehen mit `scripts/capture.mjs` und `scripts/shots/m01-m02.json`. Alle externen URLs geprüft am 24.11.2026 (HTTP 200, Bildformat).

### Modul 1

| Datei | Inhalt | Quelle | Bild-URL | Urheber/Lizenz | abgerufen am |
| --- | --- | --- | --- | --- | --- |
| docker-what-is-container | Containerized Applications: App A–F auf Docker, Host-OS, Infrastruktur (Lab 1.1) | https://www.docker.com/resources/what-container/ | https://www.docker.com/app/uploads/2021/11/container-what-is-container-1110x961.png | Docker Inc. | 24.11.2026 |
| docker-containerized-and-vm | Container auf Docker vs. VMs auf Hypervisor (Lab 1.1) | https://www.docker.com/resources/what-container/ | https://www.docker.com/app/uploads/2021/11/docker-containerized-and-vm-transparent-bg-1110x454.png | Docker Inc. | 24.11.2026 |
| docker-architecture | Client, Docker Host mit Daemon/Images/Containern, Registry (Lab 1.1) | https://commons.wikimedia.org/wiki/File:Docker-architecture.png | https://thumb.wikimedia.org/wikipedia/commons/thumb/2/20/Docker-architecture.png/960px-Docker-architecture.png | nach der Docker-Dokumentation, CC BY-SA 4.0 | 24.11.2026 |
| hello-world | eigener Screenshot: Ausgabe von `docker run hello-world` (Lab 1.1), aus `docker-3-open` übernommen | eigener Screenshot | m01/hello-world.png | Nextise GmbH | 23.11.2026 |
| docker-version | eigener Screenshot: `docker version` mit Client und Server (Lösung 1.1), aus `docker-3-open` übernommen | eigener Screenshot | m01/docker-version.png | Nextise GmbH | 23.11.2026 |
| nginx-willkommen | eigener Screenshot: nginx-Startseite unter localhost:8080 (Lab 1.2) | eigener Screenshot (Testlauf auf Port 18080) | m01/nginx-willkommen.png | Nextise GmbH | 24.11.2026 |
| docker-desktop-containers | Docker Desktop, Ansicht Containers mit Navigation und Statusleiste (Lab 1.2) | https://www.docker.com/products/docker-desktop/ | https://www.docker.com/app/uploads/2025/05/DD-hiroko-2320x1456.png | Docker Inc. | 24.11.2026 |
| docker-ps-a | eigener Screenshot: Port-Konflikt, stop/kill, `docker ps -a` mit Exit-Codes (Lab 1.2) | eigener Screenshot (echte Ausgabe; Testlauf mit Namen `a12-…` und Ports 18080/18081, im Bild Kursnamen und -ports) | m01/docker-ps-a.png | Nextise GmbH | 24.11.2026 |
| nginx-exec-geaendert | eigener Screenshot: per `docker exec` geänderte Startseite (Lab 1.3, Lösung 1.3) | eigener Screenshot | m01/nginx-exec-geaendert.png | Nextise GmbH | 24.11.2026 |
| container-layers | beschreibbare Container-Schicht über schreibgeschützten Image-Schichten (Lab 1.3) | https://docs.docker.com/engine/storage/drivers/ | https://docs.docker.com/engine/storage/drivers/images/container-layers.webp | Docker Inc. | 24.11.2026 |
| bind-mount-seite | eigener Screenshot: Seite aus eingebundenem Ordner `site/` (Lab 1.3, Lösung 1.3) | eigener Screenshot | m01/bind-mount-seite.png | Nextise GmbH | 24.11.2026 |

### Modul 2

| Datei | Inhalt | Quelle | Bild-URL | Urheber/Lizenz | abgerufen am |
| --- | --- | --- | --- | --- | --- |
| sharing-layers | vier Container teilen die Schichten eines Images (Lab 2.1) | https://docs.docker.com/engine/storage/drivers/ | https://docs.docker.com/engine/storage/drivers/images/sharing-layers.webp | Docker Inc. | 24.11.2026 |
| docker-history-python | eigener Screenshot: `docker history python:3.14-alpine` (Lab 2.1) | eigener Screenshot | m02/docker-history-python.png | Nextise GmbH | 24.11.2026 |
| docker-images-sizes | eigener Screenshot: `docker images` mit ubuntu:24.04, alpine:3.22, python:3.14-alpine (Lab 2.1) | eigener Screenshot (linux/arm64) | m02/docker-images-sizes.png | Nextise GmbH | 24.11.2026 |
| cache-stack-invalidated | Build-Cache: ab geänderter Anweisung wird neu gebaut (Lab 2.2) | https://docs.docker.com/build/cache/ | https://docs.docker.com/build/images/cache-stack-invalidated.png | Docker Inc. | 24.11.2026 |
| hello-build-cache | eigener Screenshot: Build des Hello-Frontends nach Änderung an `app.py`, Schritte `CACHED` (Lab 2.2) | eigener Screenshot (echte Ausgabe, Ausschnitt; Testlauf mit Tag `a12-hello-frontend:test`, im Bild Kursname) | m02/hello-build-cache.png | Nextise GmbH | 24.11.2026 |
| hello-frontend-v2 | eigener Screenshot: Hello-App v2 ohne Backend, „Backend nicht erreichbar" (Lab 2.2, Lösung 2.2) | eigener Screenshot (Testlauf auf Port 18082) | m02/hello-frontend-v2.png | Nextise GmbH | 24.11.2026 |
| hello-images | eigener Screenshot: `docker images` mit den drei Hello-Images (Lösung 2.2) | eigener Screenshot | m02/hello-images.png | Nextise GmbH | 24.11.2026 |
| harbor-list-artifacts | Harbor-Weboberfläche: Repository mit Artefakten, Tags, Pull Command (Lab 2.3) | https://goharbor.io/docs/main/working-with-projects/working-with-images/repositories/ | https://goharbor.io/docs/main/img/list-artifacts.png | Harbor Authors, Apache-2.0 | 24.11.2026 |
| registry-push-catalog | eigener Screenshot: Registry starten, Push von hello-frontend:v1, Katalog und Tag-Liste (Lab 2.3, Lösung 2.3) | eigener Screenshot (echte Ausgabe; Testlauf auf Port 15001, im Bild Kursport 5001; Zeilen `Waiting` weggelassen) | m02/registry-push-catalog.png | Nextise GmbH | 24.11.2026 |
| hub-supported-tags | Docker Hub, Supported tags des Ubuntu-Images (Lab 2.3) | https://docs.docker.com/docker-hub/image-library/trusted-content/ | https://docs.docker.com/docker-hub/images/supported_tags.webp | Docker Inc. | 24.11.2026 |
| semantic-versioning | Versionsnummer mit Breaking Changes, Features, Bugfixes (Lab 2.3) | https://commons.wikimedia.org/wiki/File:Semantic-versioning.svg | https://thumb.wikimedia.org/wikipedia/commons/thumb/0/09/Semantic-versioning.svg/330px-Semantic-versioning.svg.png | Surjit Bains, CC BY-SA 4.0 | 24.11.2026 |
| hello-registry-v1 | eigener Screenshot: Hello-App v1 aus der lokalen Registry gestartet (Lösung 2.3) | eigener Screenshot (Testlauf auf Port 18083) | m02/hello-registry-v1.png | Nextise GmbH | 24.11.2026 |
| trivy-image-scan | Ablauf eines Image-Scans mit Trivy (Lab 2.4) | https://trivy.dev/docs/latest/guide/target/container_image/ | https://trivy.dev/docs/latest/imgs/image.png | Aqua Security, Apache-2.0 | 24.11.2026 |
| docker-scout-hero | Docker Scout: Vulnerabilities, Policy, Repository health (Lab 2.4) | https://www.docker.com/products/docker-scout/ | https://www.docker.com/app/uploads/2025/04/pny-docker-scout-hero.png | Docker Inc. | 24.11.2026 |
| trivy-compare | eigener Screenshot: Trivy-Summen hello-frontend:v1 vs. python:3.9-alpine (Lab 2.4) | eigener Screenshot (echte Ausgabe Trivy 0.76.2, Zusammenfassungszeilen) | m02/trivy-compare.png | Nextise GmbH | 24.11.2026 |

## Bildquellen Modul 3 und 4

Eigene Aufnahmen: Testlauf am 24.11.2026 mit Docker Desktop (Engine 29.9.3, Compose 5.7.0), Definitionen in `scripts/shots/m03-m04.json` (Vorbereitung `scripts/shots/m03-m04-setup.sh`). Der Testlauf nutzte das Präfix `b34-` und Test-Ports (28080 ff.); die Ausgaben sind per `norm` auf die Namen und Ports der Handouts normiert (Projekt `hello`, Ports 8080/8081/8091–8093). `swarm-service-ps` ist die echte Ausgabe eines Swarm-Testlaufs (Text-Modus, gleich normiert).

| Datei | Inhalt (Lab) | Quelle | Bild-URL bzw. Pfad | Urheber/Lizenz | abgerufen am |
| --- | --- | --- | --- | --- | --- |
| compose-application | Compose-Anwendung mit Frontend, Backend, Netzwerk, Volume, Port 443 (Lab 3.1, 4.2) | https://docs.docker.com/compose/intro/compose-application-model/ | https://docs.docker.com/compose/images/compose-application.webp | Docker Inc. | 24.11.2026 |
| v1-versus-v2-versus-v5 | Compose v1, v2 und v5 im Vergleich (Lab 3.1) | https://docs.docker.com/compose/intro/history/ | https://docs.docker.com/compose/images/v1-versus-v2-versus-v5.png | Docker Inc. | 24.11.2026 |
| compose-ps | eigener Screenshot: `docker compose ps` mit Backend 8081 und Frontend 8080 (Lab 3.1) | eigener Screenshot | m03/compose-ps.png | Nextise GmbH | 24.11.2026 |
| hello-compose | eigener Screenshot: Hello-App über Compose, hellgelb aus `.env`, Backend-Antwort (Lab 3.1) | eigener Screenshot | m03/hello-compose.png | Nextise GmbH | 24.11.2026 |
| compose-watch-ga | Compose Watch: rebuild für package.json, sync für web/ (Lab 3.2) | https://www.docker.com/blog/announcing-docker-compose-watch-ga-release/ | https://www.docker.com/app/uploads/2023/09/compose-watch-ga_figure2-1110x646.png | Docker Inc. | 24.11.2026 |
| compose-watch | eigener Screenshot: `docker compose watch` baut nach Änderung an app.py neu (Lab 3.2) | eigener Screenshot | m03/compose-watch.png | Nextise GmbH | 24.11.2026 |
| compose-ps-replicas | eigener Screenshot: Backend healthy, drei Frontends mit zufälligen Ports, `compose port` (Lab 3.2) | eigener Screenshot | m03/compose-ps-replicas.png | Nextise GmbH | 24.11.2026 |
| container-layers | Image-Schichten nur lesbar, Container-Schicht beschreibbar (Lab 3.3) | https://docs.docker.com/engine/storage/drivers/ | https://docs.docker.com/engine/storage/drivers/images/container-layers.webp | Docker Inc. | 24.11.2026 |
| docker-desktop-containers | Docker Desktop mit Navigation (Containers, Images, Volumes) (Lab 3.3) | https://www.docker.com/products/docker-desktop/ | https://www.docker.com/app/uploads/2025/05/DD-hiroko-2320x1456.png | Docker Inc. | 24.11.2026 |
| volume-access-log | eigener Screenshot: access.log zählt mit Volume über down/up weiter, `docker volume ls` (Lab 3.3) | eigener Screenshot | m03/volume-access-log.png | Nextise GmbH | 24.11.2026 |
| nat-concept | NAT-Prinzip: private Adresse wird am Router übersetzt (Lab 4.1) | https://commons.wikimedia.org/wiki/File:NAT_Concept-en.svg | https://thumb.wikimedia.org/wikipedia/commons/thumb/c/c7/NAT_Concept-en.svg/330px-NAT_Concept-en.svg.png | Wikimedia Commons, CC BY-SA 4.0 | 24.11.2026 |
| hello-net-page | eigener Screenshot: Hello-App ohne Compose im Netzwerk hello-net (Lab 4.1) | eigener Screenshot | m04/hello-net-page.png | Nextise GmbH | 24.11.2026 |
| hello-net-connect | eigener Screenshot: `wget` aus Standard-Bridge scheitert, nach `network connect` JSON, `inspect` mit drei Containern (Lab 4.1) | eigener Screenshot | m04/hello-net-connect.png | Nextise GmbH | 24.11.2026 |
| compose-networks | eigener Screenshot: hello_frontend-net und hello_backend-net, wer wen erreicht (Lab 4.2) | eigener Screenshot | m04/compose-networks.png | Nextise GmbH | 24.11.2026 |
| fehler-cmd-logs | eigener Screenshot: Fehlerbild 1, Exited (2), Log `can't open file '/app/main.py'` (Lab 4.3) | eigener Screenshot | m04/fehler-cmd-logs.png | Nextise GmbH | 24.11.2026 |
| fehler-netzwerk-page | eigener Screenshot: Fehlerbild 2, Seite mit „Backend nicht erreichbar" (Lab 4.3) | eigener Screenshot | m04/fehler-netzwerk-page.png | Nextise GmbH | 24.11.2026 |
| docker-linux-interfaces | Docker nutzt Kernel-Funktionen (cgroups, namespaces) (Lab 4.3) | https://commons.wikimedia.org/wiki/File:Docker-linux-interfaces.svg | https://thumb.wikimedia.org/wikipedia/commons/thumb/0/09/Docker-linux-interfaces.svg/500px-Docker-linux-interfaces.svg.png | Maklaan, gemeinfrei | 24.11.2026 |
| docker-stats-limits | eigener Screenshot: `docker stats` mit 128MiB-Grenzen der Hello-App (Lab 4.3) | eigener Screenshot | m04/docker-stats-limits.png | Nextise GmbH | 24.11.2026 |
| fehler-speicher-oom | eigener Screenshot: Fehlerbild 3, Exited (137), `inspect` mit oom=true (Lab 4.3) | eigener Screenshot | m04/fehler-speicher-oom.png | Nextise GmbH | 24.11.2026 |
| swarm-diagram | Swarm mit drei Managern und sieben Workern (Lab 4.4) | https://docs.docker.com/engine/swarm/how-swarm-mode-works/nodes/ | https://docs.docker.com/engine/swarm/images/swarm-diagram.webp | Docker Inc. | 24.11.2026 |
| services-diagram | Service mit drei Tasks auf drei Nodes (Lab 4.4) | https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/ | https://docs.docker.com/engine/swarm/images/services-diagram.webp | Docker Inc. | 24.11.2026 |
| ingress-routing-mesh | Routing Mesh über drei Nodes (Lab 4.4) | https://docs.docker.com/engine/swarm/ingress/ | https://docs.docker.com/engine/swarm/images/ingress-routing-mesh.webp | Docker Inc. | 24.11.2026 |
| swarm-service-ps | eigener Screenshot: `docker service ps` nach gelöschtem Task, Ersatz-Task läuft (Lab 4.4) | eigener Screenshot (Text aus Swarm-Testlauf) | m04/swarm-service-ps.png | Nextise GmbH | 24.11.2026 |

## Bildquellen Modul 5–7

Alle Bilder per URL eingebunden (keine lokalen Kopien). Geprüft am 24.11.2026 mit GET (HTTP 200, `image/*`), auch mit Cross-Site-Referer.

| Datei | Inhalt | Quelle | Bild-URL | Urheber/Lizenz | abgerufen am |
| --- | --- | --- | --- | --- | --- |
| k8s-scaling | Vier Kopien einer App auf drei Nodes unter einer Adresse (Lab 5.1) | https://kubernetes.io/docs/tutorials/kubernetes-basics/scale/scale-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_05_scaling2.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| cncf-survey-2025 | Infografik CNCF Annual Cloud Native Survey 2025: 82 % Kubernetes in Produktion (Lab 5.1) | https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/ | https://www.cncf.io/wp-content/uploads/2026/01/CNCF-Annual-Cloud-Native-Survey-The-Infrastructure-of-AIs-Future-infographic-scaled.jpg | CNCF / The Linux Foundation | 24.11.2026 |
| k8s-components | Komponenten von Control Plane und Nodes (Lab 5.1, Lab 5.3) | https://kubernetes.io/docs/concepts/overview/components/ | https://kubernetes.io/images/docs/components-of-kubernetes.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| kind-diagram | kind: ganzer Node mit allen Komponenten in einem Container (Lab 5.2) | https://kind.sigs.k8s.io/docs/design/initial/ | https://kind.sigs.k8s.io/docs/images/diagram.png | Kubernetes SIG Testing (kind), Apache-2.0 | 24.11.2026 |
| k8s-cluster-schema | Cluster mit Control Plane und Nodes (Lab 5.2) | https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_01_cluster.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| aks-namespaces | Cluster mit Namespaces kube-system und engineering (Lab 5.3) | https://learn.microsoft.com/en-us/azure/aks/concepts-clusters-workloads | https://learn.microsoft.com/en-us/azure/aks/media/concepts-clusters-workloads/namespaces.png | Microsoft (Microsoft Learn), CC BY 4.0 | 24.11.2026 |
| artifacthub-chart-page | Chart-Seite mit helm repo add, helm install, Versionen (Lab 6.1) | https://github.com/artifacthub/hub | https://artifacthub.github.io/hub/screenshots/screenshot3.jpg | Artifact Hub Authors, Apache-2.0 | 24.11.2026 |
| artifacthub-values | Values schema reference: Standardwerte eines Charts (Lab 6.1) | https://github.com/artifacthub/hub | https://artifacthub.github.io/hub/screenshots/screenshot5.jpg | Artifact Hub Authors, Apache-2.0 | 24.11.2026 |
| dashboard-overview | Kubernetes Dashboard: Node-Detailseite mit CPU/Speicher und Navigation (Lab 6.2) | https://github.com/kubernetes-retired/dashboard | https://raw.githubusercontent.com/kubernetes-retired/dashboard/master/docs/images/overview.png | The Kubernetes Authors, Apache-2.0 | 24.11.2026 |
| dashboard-signin | Kubernetes Dashboard: Anmeldung mit Bearer token unter https://localhost:8443 (Lab 6.2) | https://github.com/kubernetes-retired/dashboard/tree/master/docs | https://raw.githubusercontent.com/kubernetes-retired/dashboard/master/docs/images/signin.png | The Kubernetes Authors, Apache-2.0 | 24.11.2026 |
| headlamp-pods | Headlamp-Desktop-App, Pod-Liste (Lab 6.2) | https://kubernetes.io/blog/2026/06/01/dashboard-to-headlamp/ | https://kubernetes.io/blog/2026/06/01/dashboard-to-headlamp/desktop-app.png | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| k8s-pods-overview | Pods mit IP, Containern und Volumes (Lab 7.1) | https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_03_pods.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| k8s-labels-selector | Labels und Selektor app=A (Lab 7.1, Lab 7.2) | https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_04_labels.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| dashboard-pods | Kubernetes Dashboard (ältere Version): Workloads > Pods in kube-system (Lab 7.1) | https://kubernetes.io/ja/docs/tasks/access-application-cluster/web-ui-dashboard/ | https://kubernetes.io/images/docs/ui-dashboard.png | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| pod-networking | Service X vor drei Pods mit eigenen IPs (Lab 7.2) | https://commons.wikimedia.org/wiki/File:Pod-networking.png | https://thumb.wikimedia.org/wikipedia/commons/thumb/6/63/Pod-networking.png/500px-Pod-networking.png | Marvin The Paranoid, CC BY-SA 4.0 | 24.11.2026 |
| kubernetes-high-availability | externer Load Balancer vor drei Nodes (Lab 7.3) | https://commons.wikimedia.org/wiki/File:Kubernetes_High-availability.png | https://thumb.wikimedia.org/wikipedia/commons/thumb/7/7d/Kubernetes_High-availability.png/960px-Kubernetes_High-availability.png | Natlibfi-arlehiko, CC BY-SA 4.0 | 24.11.2026 |
| net-loadbalancer | Load Balancer → Node → Services-Plugin → Pods (Lab 7.3) | https://kubernetes.io/blog/2024/04/05/diy-create-your-own-cloud-with-kubernetes-part-2/ | https://kubernetes.io/blog/2024/04/05/diy-create-your-own-cloud-with-kubernetes-part-2/net-loadbalancer.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| ingress | Ingress: Client → Load Balancer → Routing-Regel → Service → Pods (Lab 7.4) | https://kubernetes.io/docs/concepts/services-networking/ingress/ | https://kubernetes.io/docs/images/ingress.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| traefik-architecture | Traefik Proxy: Routing Engine zwischen Internet und Kubernetes/Servern (Lab 7.4) | https://doc.traefik.io/traefik/ | https://doc.traefik.io/traefik/assets/img/traefik-architecture.png | Traefik Labs, MIT | 24.11.2026 |
| gateway-resource-model | Ressourcenmodell GatewayClass → Gateway → Routen mit Rollen (Lab 7.4) | https://gateway-api.sigs.k8s.io/docs/introduction/ | https://gateway-api.sigs.k8s.io/images/resource-model.png | Kubernetes SIG Network, Apache-2.0 | 24.11.2026 |

## Bildquellen Modul 8

Alle Bilder sind per URL eingebunden (keine lokalen Kopien). Geprüft per HTTP-GET (Status 200, `image/*`) am 24.11.2026.

| Datei | Inhalt | Quelle | Bild-URL | Urheber/Lizenz | abgerufen am |
| --- | --- | --- | --- | --- | --- |
| k8s-labels-selector | ReplicaSet umschließt Pods mit app=A (Lab 8.1) | https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_04_labels.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| k8s-scaling-1 | Anwendung mit einem Pod (Lab 8.1) | https://kubernetes.io/docs/tutorials/kubernetes-basics/scale/scale-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_05_scaling1.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| k8s-scaling-2 | Anwendung nach Skalieren auf vier Pods (Lab 8.1) | https://kubernetes.io/docs/tutorials/kubernetes-basics/scale/scale-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_05_scaling2.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| k8s-dashboard-pods | Kubernetes Dashboard, Workloads > Pods mit Menü Replica Sets (Lab 8.1) | https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/ | https://kubernetes.io/images/docs/ui-dashboard.png | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| headlamp-workloads | Headlamp: Workloads mit Deployments und ReplicaSets (Lab 8.2) | https://github.com/kubernetes-sigs/headlamp | https://raw.githubusercontent.com/kubernetes-sigs/headlamp/screenshots/screenshots/workloads.png | Headlamp Contributors (kubernetes-sigs), Apache-2.0 | 24.11.2026 |
| k8s-rolling-update-2 | Rolling Update Schritt 1 (Lab 8.2) | https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_06_rollingupdates2.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| k8s-rolling-update-3 | Rolling Update Schritt 2 (Lab 8.2) | https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_06_rollingupdates3.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| k8s-rolling-update-4 | Rolling Update abgeschlossen (Lab 8.2) | https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/ | https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_06_rollingupdates4.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| fowler-blue-green | Blue/Green: Router schickt alles an eine von zwei Umgebungen (Lab 8.3) | https://martinfowler.com/bliki/BlueGreenDeployment.html | https://martinfowler.com/bliki/images/blueGreenDeployment/blue_green_deployments.png | Martin Fowler, © martinfowler.com | 24.11.2026 |
| fowler-canary-release | Canary: 95 % alte, 5 % neue Version (Lab 8.3) | https://martinfowler.com/bliki/CanaryRelease.html | https://martinfowler.com/bliki/images/canaryRelease/canary-release-2.png | Danilo Sato, © martinfowler.com | 24.11.2026 |
| gateway-traffic-splitting-90-10 | HTTPRoute verteilt 90/10 auf zwei Services (Lab 8.3, Ausblick) | https://gateway-api.sigs.k8s.io/guides/traffic-splitting/ | https://gateway-api.sigs.k8s.io/images/traffic-splitting-2.png | Kubernetes SIG Network, Apache-2.0 | 24.11.2026 |
| gcp-readiness-probe | Animation Readiness-Probe: nicht bereiter Pod bekommt keine Anfragen (Lab 8.4) | https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-setting-up-health-checks-with-readiness-and-liveness-probes | https://storage.googleapis.com/gweb-cloudblog-publish/original_images/google-kubernetes-probe-readiness6ktf.GIF | Google LLC | 24.11.2026 |
| gcp-liveness-probe | Animation Liveness-Probe: Container wird neu gestartet (Lab 8.4) | https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-setting-up-health-checks-with-readiness-and-liveness-probes | https://storage.googleapis.com/gweb-cloudblog-publish/original_images/google-kubernetes-probe-livenessae14.GIF | Google LLC | 24.11.2026 |
| headlamp-pods-ready-restarts | Headlamp Pod-Liste mit Restarts, Ready 0/1, Status (Lab 8.4) | https://kubernetes.io/blog/2026/06/01/dashboard-to-headlamp/ | https://kubernetes.io/blog/2026/06/01/dashboard-to-headlamp/view-workloads-resources-2.png | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| dashboard-node-resources | Kubernetes Dashboard, Node-Detail mit CPU/Memory Requests und Limits (Lab 8.5) | https://github.com/kubernetes-retired/dashboard | https://raw.githubusercontent.com/kubernetes-retired/dashboard/master/docs/images/overview.png | Kubernetes Dashboard Authors, Apache-2.0 | 24.11.2026 |
| k8s-hpa-diagram | HPA ändert Scale eines Deployments, Deployment steuert Pods (Lab 8.5) | https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ | https://kubernetes.io/images/docs/horizontal-pod-autoscaler.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |

## Bildquellen Modul 9 und 10

Externe Bilder per URL eingebunden, geprüft am 24.11.2026 (HTTP 200, Bildformat, auch mit Cross-Site-Headern). Eigene Aufnahmen liegen unter `m09/` und `m10/`; Aufnahme-Definitionen in `scripts/shots/m09.json` und `scripts/shots/m10.json`.

| Datei | Inhalt | Quelle | Bild-URL | Urheber/Lizenz | abgerufen am |
| --- | --- | --- | --- | --- | --- |
| m09/hello-configmap-lightpink.png | Hello-Seite v2 mit `APP_COLOR=lightpink` von außen gesetzt (Lab 9.1) | eigener Screenshot, `docker run` | `../../assets/images/m09/hello-configmap-lightpink.png` | Nextise GmbH | 24.11.2026 |
| dashboard-overview-nav | Kubernetes Dashboard, Navigation mit Workloads und Config and Storage (Lab 9.1) | https://github.com/kubernetes-retired/dashboard | https://raw.githubusercontent.com/kubernetes-retired/dashboard/master/docs/images/overview.png | The Kubernetes Authors, Apache-2.0 | 24.11.2026 |
| m09/base64-zurueckwandeln.png | Terminal: `uebung-2026` nach Base64 und zurück (Lab 9.2) | eigener Screenshot, bash | `../../assets/images/m09/base64-zurueckwandeln.png` | Nextise GmbH | 24.11.2026 |
| m09/hello-secret-passwort-gesetzt.png | Hello-Seite mit „Admin: Passwort gesetzt" (Lab 9.2) | eigener Screenshot, `docker run` mit eingebundener Datei | `../../assets/images/m09/hello-secret-passwort-gesetzt.png` | Nextise GmbH | 24.11.2026 |
| eso-high-level | External Secrets Operator holt Werte aus externem Tresor in Namespaces (Lab 9.2) | https://external-secrets.io/latest/ | https://external-secrets.io/latest/pictures/diagrams-high-level-simple.png | External Secrets Authors, Apache-2.0 | 24.11.2026 |
| docker-container-layers | Container-Schicht über Image-Schichten: warum Dateien ohne Volume verschwinden (Lab 9.3) | https://docs.docker.com/engine/storage/drivers/ | https://docs.docker.com/engine/storage/drivers/images/container-layers.webp | Docker Inc. | 24.11.2026 |
| k8s-storage-local | Lokaler Speicher je Node, wie `hostpath` auf Docker Desktop (Lab 9.3) | https://kubernetes.io/blog/2024/04/05/diy-create-your-own-cloud-with-kubernetes-part-2/ | https://kubernetes.io/blog/2024/04/05/diy-create-your-own-cloud-with-kubernetes-part-2/storage-local.svg | The Kubernetes Authors, CC BY 4.0 | 24.11.2026 |
| docker-volumes-shared-storage | Drei Nodes mit gemeinsamem Dateispeicher, Fall ReadWriteMany (Lab 9.3) | https://docs.docker.com/engine/storage/volumes/ | https://docs.docker.com/engine/storage/images/volumes-shared-storage.webp | Docker Inc. | 24.11.2026 |
| m09/busybox-job-befehle.png | Terminal: Befehle von Job und CronJob mit `busybox:1.37` per `docker run` (Lab 9.4) | eigener Screenshot, bash | `../../assets/images/m09/busybox-job-befehle.png` | Nextise GmbH | 24.11.2026 |
| headlamp-workloads-cronjobs | Headlamp Workloads-Übersicht mit allen Workload-Typen und CronJob-Jobs (Lab 9.4) | https://github.com/kubernetes-sigs/headlamp | https://raw.githubusercontent.com/kubernetes-sigs/headlamp/screenshots/screenshots/workloads.png | Headlamp Contributors (kubernetes-sigs), Apache-2.0 | 24.11.2026 |
| artifacthub-values-schema | `values.yaml` mit Kommentaren als Werte-Referenz in Artifact Hub (Lab 10.1) | https://github.com/artifacthub/hub | https://artifacthub.github.io/hub/screenshots/screenshot5.jpg | Artifact Hub Authors, Apache-2.0 | 24.11.2026 |
| m10/helm-lint-hello.png | Terminal: `helm lint hello` (Lab 10.1) | eigener Screenshot, Helm v4.3.2 | `../../assets/images/m10/helm-lint-hello.png` | Nextise GmbH | 24.11.2026 |
| m10/helm-template-werte.png | Terminal: `helm template` mit `values-dev.yaml` und `--set image.tag=v2`, gefiltert (Lab 10.1) | eigener Screenshot, Helm v4.3.2 | `../../assets/images/m10/helm-template-werte.png` | Nextise GmbH | 24.11.2026 |
