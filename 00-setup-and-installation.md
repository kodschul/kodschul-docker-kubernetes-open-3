# Setup und Installation

Alle Übungen laufen auf dem eigenen Rechner: Docker Desktop stellt an Tag 1 Container und an Tag 2 ein lokales Kubernetes-Cluster bereit, dazu kommen `kubectl`, Helm und VS Code.
Die Installation gehört vor den ersten Kurstag; sie dauert etwa 30–45 Minuten, Downloads eingeschlossen.

## Software für den Kurs

| Software | Zweck im Kurs | Prüfen mit | Gebraucht ab |
| --- | --- | --- | --- |
| Docker Desktop (aktuelle Version) | Container bauen und starten, Compose; lokales Kubernetes-Cluster | `docker version` | Lab 1.1 |
| Kubernetes in Docker Desktop (Cluster-Typ **Kubeadm**) | lokales Ein-Node-Cluster `docker-desktop` | `kubectl get nodes` | Lab 5.2 |
| `kubectl` | Kommandozeilen-Werkzeug für Kubernetes; kommt mit Docker Desktop | `kubectl version` | Lab 5.2 |
| Helm 4 (aktuell 4.3) | Paketmanager für Kubernetes | `helm version --short` | Lab 6.1 |
| VS Code mit Erweiterungen **Container Tools**, **Kubernetes** und **YAML** | Dockerfiles, Compose-Dateien und Manifeste schreiben | Erweiterungen-Ansicht | Lab 2.2 |
| Browser und `curl` | Seiten und Endpunkte aufrufen | `curl --version` | Lab 1.2 |
| nur Windows: WSL 2 | Linux-Unterbau für Docker Desktop | `wsl --version` | Lab 1.1 |
| nur Windows: Git for Windows (Git Bash) | Kurs-Shell `bash` | `bash --version` | Lab 1.1 |
| optional: kostenloses Docker-Konto | Docker Hub (Lab 2.3), höheres Download-Limit | `docker login` | Lab 2.3 |

Stand der Versionen: 24.11.2026, vor Kursbeginn prüfen.

## Voraussetzungen am Rechner

- **Arbeitsspeicher:** 16 GB empfohlen; Docker Desktop mit Kubernetes braucht mindestens 6 GB für die Docker-VM.
- **Betriebssystem:** macOS in einer der drei neuesten Hauptversionen; Windows 10 22H2 oder Windows 11 23H2 und neuer, jeweils 64 Bit.
- **Virtualisierung:** im BIOS/UEFI eingeschaltet (Windows); auf Firmenrechnern kann eine Richtlinie sie sperren.
- **Rechte:** Docker Desktop lässt sich unter Windows ohne Administratorrechte installieren (Modus „Per-user"); WSL 2 einschalten braucht einmalig Administratorrechte.
- **Netzwerk:** Zugriff auf `docker.io` (Docker Hub), `registry.k8s.io`, `github.com`, `kubernetes-sigs.github.io` und `kubernetes-retired.github.io` (Helm-Charts); hinter einem Firmen-Proxy muss Docker Desktop den Proxy kennen (**Settings > Resources > Proxies**).
- **Lizenz:** Docker Desktop ist für Firmen ab 250 Beschäftigten oder 10 Mio. USD Jahresumsatz kostenpflichtig ([Docker Desktop License](https://docs.docker.com/subscription/desktop-license/), Stand: 11/2026).
- **Linux-Rechner:** Docker Desktop für Linux bringt kein `kubectl` mit; der Host braucht cgroup v2 (Kubernetes ab 1.35). Einfacher ist dort der Fallback mit kind oder minikube (siehe unten).

Quellen: [Docker Desktop für Windows](https://docs.docker.com/desktop/setup/install/windows-install/), [Docker Desktop für Mac](https://docs.docker.com/desktop/setup/install/mac-install/), abgerufen am 24.11.2026.

## Kurs-Shell: bash

Alle Befehle in den Handouts sind für die Shell `bash` geschrieben.

| System | Shell | Öffnen |
| --- | --- | --- |
| macOS | Terminal (zsh versteht alle Kursbefehle) | **Programme > Dienstprogramme > Terminal** oder Terminal in VS Code |
| Linux | Terminal mit bash | Terminal oder Terminal in VS Code |
| Windows | **Git Bash** aus Git for Windows | Startmenü > **Git Bash**, oder in VS Code als Standard-Terminal |

Git Bash unter Windows einrichten:

1. Installiere Git for Windows von [git-scm.com](https://git-scm.com/downloads/win) oder per `winget install --id Git.Git -e` (PowerShell). Die vorgeschlagenen Standardoptionen passen.
2. Setze Git Bash in VS Code als Standard-Terminal: `Strg+Umschalt+P` > **Terminal: Select Default Profile** > **Git Bash**.
3. Schalte in Git Bash die automatische Pfad-Umwandlung ab. Git Bash schreibt sonst Linux-Pfade wie `/usr/share/nginx/html` in Windows-Pfade um, und Befehle wie `docker exec … ls /usr/share/nginx/html` schlagen fehl:

   ```bash
   echo 'export MSYS_NO_PATHCONV=1' >> ~/.bashrc
   source ~/.bashrc
   ```

4. Für interaktive Befehle (`docker run -it`, `docker exec -it`) das Terminal in VS Code nutzen oder `winpty` voranstellen.

## Docker Desktop installieren

| System | Weg |
| --- | --- |
| macOS | Installer von [docs.docker.com/desktop/setup/install/mac-install](https://docs.docker.com/desktop/setup/install/mac-install/) (Apple silicon oder Intel wählen) oder `brew install --cask docker-desktop` |
| Windows | Zuerst WSL 2: PowerShell **als Administrator** öffnen, `wsl --install` (neu) bzw. `wsl --update` (vorhanden), neu starten. Dann den Installer von [docs.docker.com/desktop/setup/install/windows-install](https://docs.docker.com/desktop/setup/install/windows-install/) ausführen, Backend **WSL 2** belassen. |

Nach dem ersten Start fragt Docker Desktop nach einer Anmeldung; sie ist für den Kurs optional, hilft aber gegen das Download-Limit (siehe [Docker-Hub-Limit](#docker-hub-limit-und-docker-login)).

Unter Windows braucht WSL 2 die Windows-Features **Virtual Machine Platform** und **Windows Subsystem for Linux**; `wsl --install` schaltet beide ein. Prüfen lässt es sich unter **Systemsteuerung > Programme > Windows-Features aktivieren oder deaktivieren**:

<img src="https://raw.githubusercontent.com/docker/docs/main/content/manuals/desktop/images/wsl2-enabled.png" alt="Windows-Dialog „Windows-Features aktivieren oder deaktivieren" mit markierten Häkchen bei Virtual Machine Platform und Windows Subsystem for Linux" width="480">

_Quelle: Docker Docs, Repository docker/docs (https://github.com/docker/docs/tree/main/content/manuals/desktop/images), abgerufen am 24.11.2026._

Nach dem Start zeigt Docker Desktop links die Ansichten **Containers**, **Images**, **Volumes** und **Kubernetes**; die Statusleiste unten meldet `Engine running`.

## Kubernetes in Docker Desktop einschalten

Kubernetes wird erst an Tag 2 gebraucht. Einmal vor Kursbeginn testen ist sinnvoll; spätestens am Ende von Tag 1 einschalten, damit die Downloads bis zum nächsten Morgen fertig sind.

1. Öffne das Docker Desktop Dashboard und wähle links **Kubernetes**.
2. Wähle **Create cluster**.
3. Wähle als Cluster-Typ **Kubeadm** (ein Node, Version von Docker Desktop festgelegt).
4. Bestätige mit **Create** und warte, bis die Statusleiste `Kubernetes running` zeigt (1–3 Minuten, beim ersten Mal länger).

Docker Desktop installiert dabei `kubectl` mit und legt den Kontext `docker-desktop` in `~/.kube/config` an.

Nur der Kubeadm-Cluster nutzt den Image-Speicher von Docker Desktop. Die Hello-Images, die an Tag 1 mit `docker build` entstehen, sind damit an Tag 2 ohne Registry im Cluster nutzbar. Der kind-Cluster kann mehrere Nodes, braucht dafür aber den containerd-Image-Store.

Bedienung Stand: 11/2026, vor Kursbeginn prüfen; Quelle: [Explore the Kubernetes view](https://docs.docker.com/desktop/use-desktop/kubernetes/), abgerufen am 24.11.2026.

## kubectl

- Kommt mit Docker Desktop; unter macOS liegt es in `/usr/local/bin/kubectl`, unter Windows im Programmordner von Docker Desktop (`…\resources\bin\kubectl.exe`), jeweils im Suchpfad.
- `kubectl` darf höchstens eine Minor-Version vom Cluster abweichen (Client 1.36 passt zu Cluster 1.35–1.37).
- Ein älteres `kubectl` aus Homebrew oder Chocolatey kann das von Docker Desktop überdecken: `which kubectl` zeigt, welches aufgerufen wird.

## Helm 4

| System | Installation |
| --- | --- |
| macOS | `brew install helm` |
| Windows | `winget install Helm.Helm` (PowerShell), danach Git Bash neu öffnen |
| Linux | Skript oder Paket laut [helm.sh/docs/intro/install](https://helm.sh/docs/intro/install/) |

`helm version --short` muss mit `v4.` beginnen (Stand 24.11.2026: v4.3.2).

## VS Code mit Erweiterungen

Installiere VS Code von [code.visualstudio.com](https://code.visualstudio.com/) und danach die Erweiterungen, entweder über die Erweiterungen-Ansicht (`Strg+Umschalt+X`, macOS `Cmd+Shift+X`) oder im Terminal:

```bash
code --install-extension ms-azuretools.vscode-containers
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension redhat.vscode-yaml
```

| Erweiterung | Nutzen im Kurs |
| --- | --- |
| Container Tools (Microsoft, früher „Docker") | Fehler in Dockerfiles und Compose-Dateien, Container und Images in der Seitenleiste |
| Kubernetes (Microsoft) | Cluster-Baum in der Seitenleiste, Hilfe für Manifeste |
| YAML (Red Hat) | prüft Einrückung und Felder von Compose-Dateien und Kubernetes-Manifesten beim Tippen |

Namen der Erweiterungen: Stand 11/2026, vor Kursbeginn prüfen.

## Kursdateien holen

Beide Wege führen zum selben Ordner; Git ist dafür nicht nötig.

| Weg | Schritte |
| --- | --- |
| ZIP | [ZIP herunterladen](https://github.com/kodschul/kodschul-docker-kubernetes-open-3/archive/refs/heads/2-days.zip), entpacken, z. B. nach `~/kurs/` |
| git | `git clone -b 2-days https://github.com/kodschul/kodschul-docker-kubernetes-open-3.git ~/kurs/kodschul-docker-kubernetes` |

Öffne den entpackten Ordner danach in VS Code (**File > Open Folder**) und im Terminal den Unterordner `project/`:

```bash
cd ~/kurs/kodschul-docker-kubernetes/project    # beim ZIP heißt der Ordner kodschul-docker-kubernetes-open-3-2-days
ls
```

```text
build-images.sh  examples  playground  pull-images.sh  starters  variants
```

| Ordner / Datei | Inhalt |
| --- | --- |
| `playground/` | eigener Arbeitsbereich: Quellcode der Hello-App (`frontend/`, `backend/`), eigene Compose-Datei, ab Tag 2 eigene Manifeste in `playground/k8s/` |
| `starters/` | unvollständige Startdateien der Übungen zum Kopieren in `playground/` |
| `examples/<modul>/<lab>/` | fertiger Stand jedes Labs zum Vergleichen und Wiederherstellen |
| `variants/` | absichtlich fehlerhafte Varianten für die Fehlersuche in Lab 4.3 |
| `build-images.sh` | baut die drei Hello-Images neu |
| `pull-images.sh` | lädt alle Kurs-Images vorab |

Alle Befehle in den Übungen laufen aus dem Ordner `project/`, wenn nichts anderes dabeisteht.

## Images vorab laden

Im Schulungsraum laden viele Rechner gleichzeitig dieselben Images. Das Skript `pull-images.sh` holt sie vorher, einmal für Tag 1 und einmal für die Helm-Charts von Tag 2:

```bash
bash pull-images.sh          # vor Tag 1: Basis-Images, nginx, busybox, registry
bash pull-images.sh k8s      # nach dem Einschalten von Kubernetes: Images von metrics-server und Dashboard
```

Das Skript zeigt je Image `==>` und den Namen; Zeilen mit `Fehler bei …` später wiederholen (meist Netzwerk oder Download-Limit).

## Installation prüfen

Führe die Befehle in der Kurs-Shell aus. Versionsnummern dürfen abweichen; wichtig ist, dass jeder Befehl antwortet.

```bash
docker version --format 'Client {{.Client.Version}} / Server {{.Server.Version}}'
docker run --rm hello-world
docker compose version
helm version --short
kubectl version --client
```

Erwartete Ausgabe (gekürzt):

```text
Client 29.x.x / Server 29.x.x
Hello from Docker!
This message shows that your installation appears to be working correctly.
…
Docker Compose version v2.x.x
v4.3.2+g…
Client Version: v1.3x.x
```

Mit eingeschaltetem Kubernetes zusätzlich:

```bash
kubectl get nodes
kubectl config current-context
```

```text
NAME             STATUS   ROLES           AGE   VERSION
docker-desktop   Ready    control-plane   5m    v1.3x.x
docker-desktop
```

## Docker-Hub-Limit und docker login

Docker Hub begrenzt Downloads (Pulls) von Images je 6 Stunden:

| Nutzer | Pulls je 6 Stunden |
| --- | --- |
| ohne Anmeldung | 100 je IPv4-Adresse |
| mit kostenlosem Docker-Konto | 200 je Konto |

In einem Firmennetz teilen sich oft alle Rechner eine öffentliche IP-Adresse; dann ist das anonyme Limit schnell aufgebraucht und `docker pull` meldet `toomanyrequests`. Abhilfe: ein kostenloses Konto auf [hub.docker.com](https://hub.docker.com/) anlegen und anmelden.

```bash
docker login
```

Der Befehl zeigt einen Code und eine Adresse; im Browser bestätigen, danach meldet das Terminal `Login Succeeded`. Alternativ in Docker Desktop oben rechts **Sign in** wählen. Quelle: [Docker Hub Pull-Limits](https://docs.docker.com/docker-hub/usage/pulls/), Stand: 11/2026.

## Fallback: minikube oder kind

Wenn Docker Desktop nicht erlaubt ist oder Kubernetes darin nicht startet, läuft Tag 2 auch mit minikube oder kind. Beide brauchen eine Container-Engine (Docker Engine, Docker Desktop oder Podman).

| | minikube | kind |
| --- | --- | --- |
| Installation | `brew install minikube` / `winget install Kubernetes.minikube` | `brew install kind` / `winget install Kubernetes.kind` |
| Cluster starten | `minikube start --driver=docker` | `kind create cluster --name kurs` |
| Kontext | `minikube` | `kind-kurs` |
| lokales Image ins Cluster laden | `minikube image load hello-backend:v1` | `kind load docker-image hello-backend:v1 --name kurs` |
| NodePort im Browser (Lab 7.3) | `minikube service frontend -n hello --url` | `kubectl port-forward` statt NodePort |

Unterschied zu Docker Desktop: Die Hello-Images sind dort nicht automatisch im Cluster. Nach jedem `docker build` das Image mit der Zeile aus der Tabelle laden, sonst meldet der Pod `ErrImageNeverPull`. Installationsbefehle Stand: 11/2026, vor Kursbeginn prüfen; Quellen: [minikube](https://minikube.sigs.k8s.io/docs/start/), [kind](https://kind.sigs.k8s.io/docs/user/quick-start/).

## Typische Installationsprobleme

| Symptom | Ursache | Lösung |
| --- | --- | --- |
| `Cannot connect to the Docker daemon` / `failed to connect to the docker API` | Docker Desktop läuft nicht | Docker Desktop starten, warten bis `Engine running` |
| Windows: „WSL 2 installation is incomplete" oder „Virtualization support not detected" | WSL fehlt oder Virtualisierung aus | PowerShell als Administrator: `wsl --install` bzw. `wsl --update`; Virtualisierung im BIOS/UEFI einschalten |
| `kubectl: command not found` | Kubernetes in Docker Desktop noch nicht erstellt, oder Terminal vor der Installation geöffnet | Schritt „Kubernetes einschalten" ausführen, Terminal neu öffnen |
| `The connection to the server localhost:8080 was refused` | keine kubeconfig oder falscher Kontext | `kubectl config use-context docker-desktop` |
| `kubectl get nodes` zeigt `NotReady` | Cluster startet noch | 1–2 Minuten warten; sonst in Docker Desktop **Kubernetes > Reset cluster** |
| Kubernetes startet nicht („Starting…" bleibt) | zu wenig Speicher für die Docker-VM, Proxy blockiert Downloads | **Settings > Resources** mindestens 6 GB Speicher; Proxy unter **Settings > Resources > Proxies** eintragen |
| `toomanyrequests: You have reached your pull rate limit` | Docker-Hub-Limit der gemeinsamen IP erreicht | `docker login` (siehe oben), `pull-images.sh` vorab ausführen |
| an Tag 2: Pod meldet `ErrImageNeverPull` | Cluster-Typ kind statt Kubeadm, oder Hello-Images fehlen | Docker Desktop > **Kubernetes** > **Edit cluster** > **Kubeadm**; fehlende Images mit `bash build-images.sh` im Ordner `project/` bauen |
| Git Bash: `ls: cannot access 'C:/Program Files/Git/usr/share/…'` | Pfad-Umwandlung von Git Bash | `export MSYS_NO_PATHCONV=1` in `~/.bashrc` (siehe Kurs-Shell) |
| Git Bash: `the input device is not a TTY` bei `docker exec -it` | Git-Bash-Fenster ohne echtes Terminal | Befehl mit `winpty` beginnen oder das Terminal in VS Code nutzen |
| `helm version` zeigt `v3.…` | altes Helm im Suchpfad | Helm 4 installieren, `which helm` prüfen, altes entfernen |
| Port 8080 belegt (`port is already allocated`) | anderer Container oder Dienst nutzt den Port | `docker ps` prüfen, alten Container mit `docker rm -f <name>` entfernen |
