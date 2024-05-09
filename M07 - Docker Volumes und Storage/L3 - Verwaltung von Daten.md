# Docker: Verwaltung von Daten in Docker Containern

Docker ermöglicht die einfache Bereitstellung und Ausführung von Anwendungen in Containern. Bei der Arbeit mit Containern ist die Verwaltung von Daten ein wichtiger Aspekt. Im Folgenden sind einige grundlegende Konzepte und bewährte Methoden zur Verwaltung von Daten in Docker Containern aufgeführt:

## 1. Verwendung von Volumes

Ein Volume ist ein persistenter Datenspeicher, der von einem oder mehreren Containern verwendet werden kann. Docker Volumes bieten eine effiziente Möglichkeit, Daten zwischen Host und Container sowie zwischen Containern auszutauschen. Einige häufige Verwendungszwecke von Volumes sind:

- Persistenz von Datenbanken
- Speichern von Konfigurationsdateien
- Bereitstellen von Logdateien

Um ein Volume zu erstellen und mit einem Container zu verknüpfen, können Sie den folgenden Befehl verwenden:

```bash
docker run -v <volume-name>:<container-path> image-name
```

## 2. Verwendung von Bind Mounts
Bind Mounts ermöglichen es, ein Verzeichnis auf dem Host direkt mit einem Verzeichnis im Container zu verknüpfen. Dies ermöglicht eine einfache Datenfreigabe und -manipulation zwischen dem Host und dem Container. Einige häufige Anwendungsfälle für Bind Mounts sind:

Entwicklungsumgebungen
Live-Code-Aktualisierung
Datenbank-Backups
Die Verwendung von Bind Mounts erfolgt durch Angabe des Host-Pfads und des Container-Pfads beim Ausführen des Containers:

```bash
docker run -v /host/path:/container/path image-name
```

## 3. Verwendung von Named Volumes
Named Volumes sind benannte persistente Speicher, die von Docker verwaltet werden. Sie bieten eine einfachere Verwaltung von Volumes im Vergleich zu anonymen Volumes. Benannte Volumes sind ideal für:

Datenbanken
Anwendungen mit mehreren Containern
Wiederherstellbare Testumgebungen
Named Volumes können mit dem folgenden Befehl erstellt und verwendet werden:

```bash
docker volume create <volume-name>
docker run -v <volume-name>:/container/path image-name
```

## 4. Daten in Docker Images speichern
Manchmal ist es sinnvoll, Daten direkt in einem Docker Image zu speichern, z. B. wenn die Daten integraler Bestandteil der Anwendung sind. Dies kann durch Hinzufügen der Daten während des Build-Vorgangs des Images erfolgen:

```Dockerfile
FROM base-image

COPY data /container/path
```

## 5. Docker Compose verwenden
Docker Compose ist ein Tool zum Definieren und Ausführen von Multi-Container Docker-Anwendungen. Es bietet eine einfache Möglichkeit, Container miteinander zu verknüpfen und die Datenverwaltung zu koordinieren. Durch die Verwendung von Docker Compose können Sie bequem Volumes, Bind Mounts und Named Volumes für Ihre Anwendung definieren.

Ein Beispiel für die Verwendung von Docker Compose:

```yaml
version: '3'
services:
  db:
    image: postgres
    volumes:
      - db-data:/var/lib/postgresql/data
  app:
    image: my-app
    volumes:
      - ./app:/app
volumes:
  db-data:
```

Diese Docker Compose-Datei definiert zwei Dienste (db und app) sowie ein benanntes Volume (db-data) für die Datenbank.