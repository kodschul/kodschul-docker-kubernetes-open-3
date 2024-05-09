## Docker: Was ist Docker Compose?

Docker Compose ist ein Tool, das entwickelt wurde, um die Konfiguration und Ausführung von Docker-Anwendungen zu vereinfachen, die aus mehreren Containern bestehen. Es ermöglicht die Definition einer Anwendungsumgebung mit einer YAML-Datei und das Ausführen von Anwendungen mit nur einem Befehl.

### Hauptmerkmale von Docker Compose:

- **Deklarative Konfiguration**: Docker Compose verwendet eine einfache YAML-Syntax, um die Konfiguration von Diensten, Netzwerken und Volumes zu definieren.

- **Mehrere Container**: Mit Docker Compose können Sie eine Anwendung aus mehreren miteinander verbundenen Containern definieren, die zusammenarbeiten, um eine bestimmte Aufgabe auszuführen.

- **Einfache Orchestrierung**: Durch die Verwendung von Docker Compose können Entwickler eine Anwendung mit einem einzigen Befehl starten, stoppen und neu erstellen, wodurch die Orchestrierung und Verwaltung von Containern vereinfacht wird.

### Beispiel für eine Docker Compose-Datei:

```yaml
version: '3.8'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
  db:
    image: postgres:latest
    environment:
      POSTGRES_PASSWORD: example
```

In diesem Beispiel wird eine einfache Anwendungsumgebung mit zwei Diensten definiert: web und db. Der web-Dienst verwendet das Nginx-Image und leitet den Port 8080 des Hosts an Port 80 des Containers weiter. Der db-Dienst verwendet das PostgreSQL-Image und konfiguriert das Postgres-Passwort über eine Umgebungsvariable.

### Verwendung von Docker Compose:
Konfigurationsdatei erstellen: Erstellen Sie eine docker-compose.yml-Datei, um die Dienste, Netzwerke und Volumes Ihrer Anwendung zu definieren.
Anwendung starten: Verwenden Sie den Befehl docker-compose up, um Ihre Anwendungsumgebung gemäß der Konfigurationsdatei zu starten.
Anwendung stoppen: Verwenden Sie den Befehl docker-compose down, um Ihre Anwendungsumgebung und alle zugehörigen Container zu stoppen und zu entfernen.
Docker Compose erleichtert die Verwaltung von Docker-Anwendungen durch die Bereitstellung einer einfachen und konsistenten Schnittstelle für die Konfiguration und Ausführung von Containern. Es ist ein unverzichtbares Tool für die Entwicklung und Bereitstellung containerisierter Anwendungen.