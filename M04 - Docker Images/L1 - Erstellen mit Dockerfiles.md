## Docker: Erstellen von eigenen Docker Images mit Dockerfiles

Dockerfiles sind Textdateien, die die Befehle enthalten, um Docker-Images zu erstellen. Mit Dockerfiles können Sie benutzerdefinierte Docker-Images erstellen, die spezifische Anwendungen oder Umgebungen enthalten. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zum Erstellen eigener Docker-Images mit Dockerfiles:

### Beispiel 1: Einfaches Dockerfile

```Dockerfile
# Verwenden des offiziellen Node.js-Basisimages
FROM node:14

# Setzen des Arbeitsverzeichnisses im Container
WORKDIR /app

# Kopieren der Dateien vom Host ins Arbeitsverzeichnis im Container
COPY package.json package-lock.json /app/

# Installieren von Abhängigkeiten
RUN npm install

# Kopieren des restlichen Anwendungscodes
COPY . /app/

# Port öffnen
EXPOSE 3000

# Starten der Anwendung
CMD ["npm", "start"]
```

In diesem Beispiel wird ein einfaches Dockerfile für eine Node.js-Anwendung gezeigt. Es verwendet das offizielle Node.js-Basisimage, kopiert die Anwendungsdateien in den Container, installiert Abhängigkeiten, öffnet einen Port und startet die Anwendung.

### Beispiel 2: Mehrstufiges Build-Dockerfile

```Dockerfile
# Erstes Build-Stage: Bauen der Anwendung
FROM node:14 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Zweites Build-Stage: Erstellen des Produktions-Images
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

```

Dieses Dockerfile zeigt ein mehrstufiges Build. Zuerst wird die Anwendung gebaut und dann das Produktions-Image erstellt. Das Endprodukt enthält nur die für die Ausführung erforderlichen Artefakte, was zu schlankeren und sichereren Images führt.

### Beispiel 3: Verwendung von Umgebungsvariablen

### Beispiel 2: Mehrstufiges Build-Dockerfile

```Dockerfile
FROM nginx:alpine

# Verwenden einer Umgebungsvariable für die Konfiguration
ENV PORT=8080

# Kopieren der Konfigurationsdatei in den Container
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE $PORT
CMD ["nginx", "-g", "daemon off;"]
```

Hier wird eine Umgebungsvariable (PORT) verwendet, um den Port zu konfigurieren, auf dem der NGINX-Server lauscht. Dies ermöglicht eine einfache Anpassung der Konfiguration durch Ändern der Umgebungsvariable.