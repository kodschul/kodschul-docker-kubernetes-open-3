# Lab 5.2 – Übung: Lokales Cluster und kubectl

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Nein — das Cluster `docker-desktop` wird nur geprüft; ab Lab 5.3 laufen darin die Objekte der Hello-App.

## Vorbereitung

- Docker Desktop läuft, Kubernetes ist eingeschaltet (Statusleiste `Kubernetes running`); falls nicht: [Setup](../../00-setup-and-installation.md#kubernetes-in-docker-desktop-einschalten), Cluster-Typ **Kubeadm**.
- Terminal öffnen (macOS/Linux: Terminal, Windows: Git Bash), Ordner beliebig.
- Starter und Arbeitsdatei: keine, alle Schritte sind Befehle.

## Aufgaben

1. Prüfe mit `kubectl version`, dass Client und Server antworten und höchstens eine Minor-Version auseinanderliegen.
2. Zeige mit `kubectl get nodes` den Node an und mit `kubectl get nodes -o wide` zusätzlich IP, Betriebssystem und Container-Runtime.
3. Zeige mit `kubectl config get-contexts` alle Kontexte an und prüfe, dass `docker-desktop` aktiv ist; wechsle bei Bedarf mit `kubectl config use-context docker-desktop`.
4. Liste mit `kubectl get pods -n kube-system` die Systemkomponenten auf und ordne jedem Pod eine Komponente aus dem Architekturbild von Lab 5.1 zu.
5. Zeige mit `kubectl config view --minify` die kubeconfig des aktuellen Kontexts an und finde darin die Adresse des API-Servers (`server:`).

## Checkpoint

- `kubectl version` zeigt `Client Version` und `Server Version`, beide 1.35 oder neuer.
- `kubectl get nodes` zeigt `docker-desktop` mit `STATUS Ready` und `ROLES control-plane`.
- In `kubectl config get-contexts` steht der Stern `*` vor `docker-desktop`.
- In `kube-system` laufen unter anderem `kube-apiserver-docker-desktop`, `etcd-docker-desktop`, `kube-scheduler-docker-desktop` und `kube-controller-manager-docker-desktop`, alle `Running`.

## Abschlusskriterien

- Der Node `docker-desktop` ist `Ready`, `kubectl` spricht mit diesem Cluster, und jede Komponente der Control Plane ist einem Pod zugeordnet.

## Fallback

- Kubernetes startet nicht: in Docker Desktop **Kubernetes** > **Reset cluster**; sonst minikube oder kind wie im [Setup](../../00-setup-and-installation.md#fallback-minikube-oder-kind). Node und Kontext heißen dann `minikube` bzw. `kurs-control-plane` / `kind-kurs`; die Pod-Liste in `kube-system` weicht in den Hilfs-Pods ab.
