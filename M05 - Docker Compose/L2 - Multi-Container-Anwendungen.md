## Docker: Erstellen von Multi-Container-Anwendungen mit Docker Compose

Docker ist eine Container-Technologie, die es Entwicklern ermöglicht, Anwendungen in isolierten Umgebungen auszuführen. Docker Compose ist ein Tool zur Definition und Ausführung von Multi-Container-Anwendungen. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zur Erstellung von Multi-Container-Anwendungen mit Docker Compose:

### Beispiel 1: Dockerfile für eine Node.js-Anwendung

```Dockerfile
# Verwende das offizielle Node.js-Image als Basisimage
FROM node:alpine

# Setze das Arbeitsverzeichnis innerhalb des Containers
WORKDIR /app

# Kopiere die package.json-Datei in das Arbeitsverzeichnis
COPY package.json .

# Installiere Abhängigkeiten
RUN npm install

# Kopiere den restlichen Anwendungscode in das Arbeitsverzeichnis
COPY . .

# Exponiere den Port 3000
EXPOSE 3000

# Starte die Anwendung
CMD ["npm", "start"]
```

In diesem Beispiel wird ein Dockerfile für eine Node.js-Anwendung erstellt. Es verwendet das offizielle Node.js-Image als Basis, kopiert die package.json und installiert die Abhängigkeiten mit npm install. Schließlich wird der Anwendungscode kopiert und die Anwendung gestartet.

### Beispiel 2: Docker Compose-Konfigurationsdatei

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
  db:
    image: mongo
    ports:
      - "27017:27017"
```

Dies ist eine Docker Compose-Konfigurationsdatei, die zwei Dienste definiert: web für die Node.js-Anwendung und db für eine MongoDB-Datenbank. Die web-Anwendung wird mit dem lokalen Verzeichnis gebaut und der Port 3000 wird nach außen freigegeben. Die db-Dienst verwendet das offizielle MongoDB-Image und freigeben den Port 27017.

### Beispiel 3: Starten von Multi-Container-Anwendungen
Um die Multi-Container-Anwendung zu starten, führen Sie den folgenden Befehl im Verzeichnis mit der docker-compose.yml-Datei aus:

```bash
docker-compose up
```

Dieser Befehl erstellt und startet alle Dienste gemäß der Konfiguration in der docker-compose.yml-Datei. Die Anwendungen können dann über die angegebenen Ports erreicht werden.