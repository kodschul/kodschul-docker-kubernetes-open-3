## Docker: Interaktion mit Containern: Ausführen von Befehlen, Kopieren von Dateien

Docker bietet verschiedene Möglichkeiten, mit Containern zu interagieren, einschließlich dem Ausführen von Befehlen innerhalb eines Containers und dem Kopieren von Dateien zwischen Host und Container. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zur Interaktion mit Docker-Containern:

### Beispiel 1: Ausführen von Befehlen in einem Container

```bash
# Syntax: docker exec <Optionen> <Container> <Befehl>

# Beispiel: Ausführen des Befehls "ls" im Container "my_container"
docker exec my_container ls
```

In diesem Beispiel wird der Befehl docker exec verwendet, um den Befehl ls innerhalb des Containers my_container auszuführen. Dies ermöglicht das Ausführen von Befehlen in laufenden Containern.

### Beispiel 2: Kopieren von Dateien zwischen Host und Container

```bash
# Syntax: docker cp <Quelle> <Ziel>

# Beispiel: Kopieren der Datei "example.txt" vom Host in den Container "my_container"
docker cp example.txt my_container:/path/in/container
```

Hier wird der Befehl docker cp verwendet, um die Datei example.txt vom Host in den Container my_container zu kopieren. Dies ermöglicht den einfachen Austausch von Dateien zwischen Host und Container.

### Beispiel 3: Kopieren von Dateien aus einem Container auf den Host

```bash
# Syntax: docker cp <Container>:<Quelle> <Ziel>

# Beispiel: Kopieren der Datei "example.txt" aus dem Container "my_container" auf den Host
docker cp my_container:/path/in/container/example.txt /host/path
```
Dieses Beispiel zeigt, wie man Dateien aus einem Docker-Container auf den Host kopiert, indem man den Pfad innerhalb des Containers und den Zielpfad auf dem Host angibt.