## Docker: Installation von Docker auf verschiedenen Plattformen

Docker ist eine Open-Source-Plattform zur Containerisierung von Anwendungen. Sie ermöglicht es, Anwendungen und ihre Abhängigkeiten in isolierten Containern zu verpacken, die überall ausgeführt werden können. Im Folgenden sind Anleitungen zur Installation von Docker auf verschiedenen Plattformen:

### Installation auf Linux

#### Ubuntu

1. Aktualisieren Sie das Paketindex:

```bash
sudo apt-get update
```

2. Installieren Sie die erforderlichen Pakete zur Einrichtung des Docker-Repositories:

```bash
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

```

3. Fügen Sie den Docker GPG-Schlüssel hinzu:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

```

4. Fügen Sie das Docker-Repository zu den APT-Quellen hinzu:

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

```

5. Aktualisieren Sie erneut den Paketindex:

```bash
sudo apt-get update
```

6. Installieren Sie Docker:

```bash
sudo apt-get install docker-ce
```

### Installation auf macOS
Laden Sie den Docker Desktop für Mac herunter und installieren Sie ihn von der offiziellen Docker-Website.
Starten Sie Docker Desktop nach der Installation und melden Sie sich bei Ihrem Docker-Konto an.

### Installation auf Windows
Laden Sie den Docker Desktop für Windows herunter und installieren Sie ihn von der offiziellen Docker-Website.
Starten Sie Docker Desktop nach der Installation und melden Sie sich bei Ihrem Docker-Konto an.

### Überprüfung der Installation
Nach der Installation können Sie die Docker-Version überprüfen, um sicherzustellen, dass Docker erfolgreich installiert wurde. Öffnen Sie dazu die Befehlszeile (Terminal oder PowerShell) und geben Sie den folgenden Befehl ein:

```bash
docker --version
```