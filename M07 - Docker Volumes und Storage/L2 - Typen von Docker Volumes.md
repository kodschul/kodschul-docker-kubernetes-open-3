# Docker: Typen von Docker Volumes

Docker Volumes sind eine Möglichkeit, Daten persistent zu speichern und zwischen Containern zu teilen. Es gibt verschiedene Arten von Docker Volumes, darunter Bind Mounts, Named Volumes und tmpfs-Volumes. Im Folgenden werden diese Typen näher erläutert:

## 1. Bind Mounts

Ein Bind Mount ist eine Methode, um einen bestimmten Datei- oder Verzeichnispfad auf dem Hostsystem direkt mit einem Pfad im Container zu verbinden. Mit Bind Mounts können Daten zwischen dem Host und dem Container einfach geteilt werden.

Beispiel für die Verwendung eines Bind Mounts:

```bash
docker run -v /host/path:/container/path my_image
```

## 2. Named Volumes
Named Volumes sind benannte Speicherorte, die Docker zur Verwaltung persistenter Daten verwendet. Sie sind unabhängig von einem bestimmten Container und können einfach erstellt, gelöscht und weiterverwendet werden.

Beispiel für die Verwendung eines Named Volumes:

```bash
docker volume create my_volume
docker run -v my_volume:/container/path my_image
```

## 3. tmpfs-Volumes
Ein tmpfs-Volume speichert Daten im Arbeitsspeicher des Hostsystems anstatt auf der Festplatte. Dies ist nützlich für temporäre Daten oder Daten, die nicht dauerhaft gespeichert werden müssen.

Beispiel für die Verwendung eines tmpfs-Volumes:

```bash
docker run --mount type=tmpfs,destination=/container/path my_image
```
