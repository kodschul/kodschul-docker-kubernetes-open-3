# Glossar

| Begriff | Bedeutung | Lab |
| --- | --- | --- |
| Bind Mount | Ordner vom Rechner im Container sichtbar | 1.3 |
| Build-Argument (`ARG`) | Wert, der nur beim Bauen gilt | 2.2 |
| Bridge-Netzwerk | Standard-Netzwerk für Container auf einem Rechner | 4.1 |
| Canary | neue Version erst für einen kleinen Teil der Anfragen | 8.3 |
| Chart (Helm) | Paket aus Kubernetes-Vorlagen und Standardwerten | 6.1 |
| Cluster | Gruppe von Servern (Nodes), die Kubernetes gemeinsam steuert | 5.1 |
| ClusterIP | Service-Typ: feste Adresse nur im Cluster | 7.2 |
| ConfigMap | Konfigurationswerte außerhalb des Images | 9.1 |
| Container | laufende, abgeschirmte Instanz eines Images | 1.1 |
| Control Plane | Steuerzentrale des Clusters (API-Server, etcd, Scheduler) | 5.1 |
| CronJob | Job nach Zeitplan | 9.4 |
| CVE | öffentlich gelistete Sicherheitslücke | 2.4 |
| Daemon (`dockerd`) | Hintergrunddienst, der Container ausführt | 1.1 |
| Dashboard | Web-Oberfläche für das Cluster (archiviert, Nachfolger Headlamp) | 6.2 |
| Deployment | hält Pods einer Version am Leben, rollt Versionen aus | 8.2 |
| Docker Compose | mehrere Container aus einer YAML-Datei | 3.1 |
| Dockerfile | Bauanleitung für ein Image | 2.2 |
| EndpointSlice | Liste der Pod-Adressen hinter einem Service | 7.2 |
| Healthcheck | Test, ob ein Container antwortet (Compose) | 3.2 |
| Helm | Paketmanager für Kubernetes | 6.1 |
| HPA (Horizontal Pod Autoscaler) | passt die Zahl der Pods an die Last an | 8.5 |
| Image | unveränderliche Vorlage aus Schichten und Startbefehl | 1.1 |
| Ingress | Routing von HTTP-Anfragen nach Name und Pfad | 7.4 |
| Job | Pod, der eine Aufgabe bis zum Ende ausführt | 9.4 |
| kubectl | Kommandozeilen-Werkzeug für Kubernetes | 5.2 |
| kubeconfig / Kontext | Datei mit Clustern und Zugangsdaten; Kontext = aktive Auswahl | 5.2 |
| Label / Selector | Schlüssel-Wert-Paar am Objekt / Filter darauf | 7.1 |
| Layer | Schicht eines Images, wird geteilt und gecacht | 2.1 |
| Limit / Request | Obergrenze / eingeplante Menge an CPU und Speicher | 8.5 |
| Liveness-Probe | startet einen hängenden Container neu | 8.4 |
| Manifest | YAML-Datei mit dem gewünschten Zustand einer Ressource | 5.3 |
| metrics-server | sammelt CPU- und Speicherwerte für `kubectl top` und HPA | 6.1 |
| Namespace | Ordner für Ressourcen im Cluster | 5.3 |
| Node | Server im Cluster, auf dem Pods laufen | 5.1 |
| NodePort | Service-Typ: Port 30000–32767 auf jedem Node | 7.3 |
| Orchestrierung | Container automatisch auf viele Server verteilen und betreuen | 4.4 |
| PersistentVolume (PV) / Claim (PVC) | Speicher im Cluster / Anforderung davon | 9.3 |
| Pod | kleinste Einheit in Kubernetes, ein oder mehrere Container | 7.1 |
| Port-Forward | Tunnel vom eigenen Rechner zu einem Pod oder Service | 6.2 |
| Readiness-Probe | Anfragen erst, wenn der Pod bereit ist | 8.4 |
| Registry | Speicher für Images, z. B. Docker Hub | 2.3 |
| Release (Helm) | installierte Instanz eines Charts | 6.1 |
| ReplicaSet | hält eine feste Zahl gleicher Pods am Leben | 8.1 |
| Ressource (Kubernetes) | Objekt in der API, z. B. Pod, Service, Namespace | 5.3 |
| Rolling Update / Rollback | Version schrittweise tauschen / zurück zur alten | 8.2 |
| Secret | Passwörter und Schlüssel als eigenes Objekt | 9.2 |
| Service | feste Adresse und Lastverteilung für Pods | 7.2 |
| StorageClass | Vorlage für automatisch angelegten Speicher | 9.3 |
| Swarm | in Docker eingebaute Orchestrierung | 4.4 |
| Tag | Versionsname eines Images, z. B. `v2` | 2.3 |
| Volume (Docker) | von Docker verwalteter Speicher außerhalb des Containers | 3.3 |
