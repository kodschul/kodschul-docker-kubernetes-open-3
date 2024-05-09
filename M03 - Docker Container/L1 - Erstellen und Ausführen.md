## Docker: Erstellen und Ausführen von Containern

Docker ist eine Plattform zur Entwicklung, Bereitstellung und Ausführung von Anwendungen mithilfe von Containern. Container ermöglichen es, Anwendungen mit all ihren Abhängigkeiten in einer isolierten Umgebung auszuführen. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zum Erstellen und Ausführen von Containern mit Docker:

### Beispiel 1: Erstellen eines einfachen Containers

```dockerfile
# Verwenden eines Basisimages (hier: Alpine Linux)
FROM alpine:latest

# Führen eines Befehls im Container aus
CMD ["echo", "Hallo, Welt!"]
```

In diesem Beispiel wird ein Dockerfile definiert, um einen einfachen Container auf Basis des Alpine Linux-Images zu erstellen. Der Container führt den Befehl echo "Hallo, Welt!" aus, wenn er gestartet wird.

### Beispiel 2: Build und Run des Containers

```bash
# Dockerfile im aktuellen Verzeichnis bauen
docker build -t mein-container .

# Container aus dem gebauten Image starten
docker run mein-container
```

Dieser Befehl baut ein Docker-Image mit dem Namen mein-container aus dem Dockerfile im aktuellen Verzeichnis und startet dann einen Container aus diesem Image.

### Beispiel 3: Bereitstellung einer Anwendung mit Docker Compose

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "8080:80"
```

In dieser docker-compose.yml-Datei wird definiert, wie die Anwendung bereitgestellt werden soll. Hier wird ein Dienst namens "web" definiert, der das aktuelle Verzeichnis als Build-Context verwendet und den Container-Port 80 auf den Host-Port 8080 weiterleitet.