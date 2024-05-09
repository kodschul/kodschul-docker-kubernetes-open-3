## Docker: Persistente Daten mit Volumes

In Docker können Volumes verwendet werden, um Daten persistent zwischen Containern und Hostsystemen zu speichern. Dies ist besonders nützlich, um Datenbanken, Konfigurationsdateien und andere persistente Daten zu speichern, die über die Lebensdauer eines Containers hinaus bestehen bleiben sollen. Im Folgenden sind einige grundlegende Konzepte und Beispiele zur Verwendung von Volumes in Docker:

### Beispiel 1: Verwendung von Volumes in einem Container

```bash
docker run -d
--name my_container
-v /host/path:/container/path
my_image
```

In diesem Beispiel wird ein Docker-Container mit dem Namen "my_container" ausgeführt. Der Parameter `-v` wird verwendet, um ein Volume zu erstellen und es mit einem Pfad auf dem Hostsystem (`/host/path`) zu verknüpfen und einem Pfad im Container (`/container/path`). Alle Daten, die in diesem Verzeichnis im Container gespeichert werden, werden auf dem Hostsystem persistiert.

### Beispiel 2: Verwendung von benannten Volumes

```bash
docker volume create my_volume
docker run -d
--name my_container
-v my_volume:/container/path
my_image
```

In diesem Beispiel wird ein benanntes Volume mit dem Namen "my_volume" erstellt. Dann wird ein Docker-Container ausgeführt und das benannte Volume mit einem Pfad im Container verknüpft. Benannte Volumes bieten eine einfachere Möglichkeit, Volumes zu verwalten und sind portabler, da sie nicht an einen bestimmten Pfad auf dem Hostsystem gebunden sind.

### Beispiel 3: Verwendung von Volumes in einem Docker-Compose-Datei

```yaml
version: '3'
services:
  my_service:
    image: my_image
    volumes:
      - my_volume:/container/path

volumes:
  my_volume:
```

In diesem Beispiel wird eine Docker-Compose-Datei verwendet, um einen Service mit einem Volume zu definieren. Das Volume my_volume wird auf den Pfad im Container gemappt. Docker-Compose erleichtert die Verwaltung mehrerer Container und Volumes in einer Anwendung.