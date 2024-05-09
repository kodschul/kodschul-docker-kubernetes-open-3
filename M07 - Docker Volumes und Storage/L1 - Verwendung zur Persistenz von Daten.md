## Docker: Verwendung von Docker Volumes zur Persistenz von Daten

Docker Volumes ermöglichen es, Daten zwischen einem Docker-Container und dem Host-Betriebssystem zu persistieren. Dies ist besonders nützlich, um Daten auch dann zu behalten, wenn ein Container entfernt oder neu gestartet wird. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zur Verwendung von Docker Volumes:

### Beispiel 1: Verwendung von Named Volumes

```bash
# Erstelle einen Named Volume
docker volume create mydata

# Starte einen Container und verbinde den Named Volume
docker run -d --name mycontainer -v mydata:/path/in/container myimage
```

In diesem Beispiel wird ein Named Volume mit dem Namen mydata erstellt. Beim Starten eines Containers wird dieser Volume mit dem Verzeichnis /path/in/container im Container verbunden.

### Beispiel 2: Verwendung von Bind Mounts

```bash
# Starte einen Container und verbinde ein Verzeichnis auf dem Host mit einem Verzeichnis im Container
docker run -d --name mycontainer -v /host/path:/container/path myimage
```

Hier wird ein Bind Mount verwendet, um ein Verzeichnis auf dem Host-Betriebssystem (/host/path) mit einem Verzeichnis im Container (/container/path) zu verbinden.

### Beispiel 3: Verwendung von Docker Compose mit Volumes

```yaml
version: '3'
services:
  app:
    image: myimage
    volumes:
      - mydata:/path/in/container

volumes:
  mydata:
```

In diesem Docker-Compose-Beispiel wird ein Service definiert, der das Image myimage verwendet und einen Volume (mydata) mit dem Verzeichnis /path/in/container im Container verbindet.