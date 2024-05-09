## Docker: Einführung in Docker-Netzwerke

Docker ermöglicht die Erstellung, Bereitstellung und Ausführung von Anwendungen in Containern. Docker-Netzwerke spielen dabei eine wichtige Rolle, indem sie die Kommunikation zwischen Containern ermöglichen. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zur Einführung in Docker-Netzwerke:

### Beispiel 1: Verwendung des Standardnetzwerks

```bash
# Erstellen und Ausführen eines Containers ohne explizite Netzwerkspezifikation
docker run -d --name container1 nginx

# Erstellen und Ausführen eines weiteren Containers im selben Standardnetzwerk
docker run -d --name container2 nginx

# Überprüfen der Netzwerkkonfiguration der Container
docker network inspect bridge
```

In diesem Beispiel werden zwei Container (basierend auf dem Image nginx) im Standardnetzwerk erstellt und ausgeführt. Das Standardnetzwerk wird automatisch erstellt, wenn kein spezifisches Netzwerk angegeben ist.

### Beispiel 2: Erstellung eines benutzerdefinierten Netzwerks

```bash
# Erstellen eines benutzerdefinierten Netzwerks
docker network create mynetwork

# Erstellen und Ausführen eines Containers im benutzerdefinierten Netzwerk
docker run -d --name container3 --network mynetwork nginx

# Überprüfen der Netzwerkkonfiguration des benutzerdefinierten Netzwerks
docker network inspect mynetwork
```

Hier wird ein benutzerdefiniertes Docker-Netzwerk namens mynetwork erstellt und ein Container (basierend auf dem Image nginx) in diesem Netzwerk erstellt und ausgeführt.

### Beispiel 3: Verwendung von Links zwischen Containern

```bash
# Erstellen und Ausführen eines MySQL-Containers
docker run -d --name mysql-db -e MYSQL_ROOT_PASSWORD=my-secret-pw mysql

# Erstellen und Ausführen eines Containers mit einer Anwendung, die auf die MySQL-Datenbank zugreift
docker run -d --name webapp --link mysql-db:mysql my-webapp
```

Hier wird ein Container mit einer MySQL-Datenbank erstellt und ausgeführt. Anschließend wird ein weiterer Container mit einer Anwendung erstellt und ausgeführt, der über den Link mysql-db auf die MySQL-Datenbank zugreift.