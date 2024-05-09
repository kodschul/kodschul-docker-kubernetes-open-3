# Docker: Verwalten von Containern: Starten, Stoppen, Löschen

Docker ist eine beliebte Plattform zur Erstellung, Bereitstellung und Verwaltung von Containern. Das Verwalten von Containern umfasst verschiedene Aufgaben wie das Starten, Stoppen und Löschen. Im Folgenden werden grundlegende Konzepte und Befehle zum Verwalten von Containern in Docker erläutert:

## Container starten

Um einen Docker-Container zu starten, verwenden Sie den Befehl `docker run` gefolgt vom Namen des Images.

```bash
docker run image_name
```

Wenn das Image nicht lokal verfügbar ist, wird Docker versuchen, es aus dem Docker Hub herunterzuladen.

## Container stoppen
Um einen laufenden Docker-Container zu stoppen, verwenden Sie den Befehl docker stop gefolgt von der Container-ID oder dem Namen des Containers.

```bash
docker stop container_id_or_name
```

Dies beendet den Container, lässt ihn jedoch intakt.

## Container löschen
Um einen Docker-Container zu löschen, verwenden Sie den Befehl docker rm gefolgt von der Container-ID oder dem Namen des Containers.

```bash
docker rm container_id_or_name
```

Beachten Sie, dass der Container gestoppt sein muss, bevor er gelöscht werden kann.

## Weitere Befehle
docker ps: Zeigt alle laufenden Container an.
docker ps -a: Zeigt alle Container an, einschließlich gestoppter.
docker start container_id_or_name: Startet einen gestoppten Container erneut.
docker restart container_id_or_name: Stoppt und startet einen Container neu.
docker pause container_id_or_name: Pausiert einen laufenden Container.
docker unpause container_id_or_name: Setzt die Ausführung eines pausierten Containers fort.

Diese Befehle sind grundlegend für die Verwaltung von Docker-Containern. Sie ermöglichen es, Container zu starten, zu stoppen, zu löschen und ihren Status zu überwachen. Mit Docker können Entwickler und Systemadministratoren effizient und zuverlässig Container-Anwendungen bereitstellen und betreiben.