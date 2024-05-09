## Docker: Erstellen und Verwalten von Docker-Netzwerken

Docker ermöglicht das Erstellen und Verwalten von Docker-Netzwerken, die es Containern ermöglichen, miteinander zu kommunizieren. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zur Erstellung und Verwaltung von Docker-Netzwerken:

### Beispiel 1: Erstellen eines Docker-Netzwerks

```bash
docker network create my_network
```

Dieser Befehl erstellt ein neues Docker-Netzwerk mit dem Namen "my_network". Standardmäßig handelt es sich um ein Bridge-Netzwerk.

### Beispiel 2: Anzeigen von Docker-Netzwerken

```bash
docker network ls
```

Dieser Befehl listet alle vorhandenen Docker-Netzwerke auf dem Hostsystem auf, einschließlich ihrer Namen, IDs und Treiber.

### Beispiel 3: Verbinden von Containern mit einem Netzwerk

```bash
docker run -d --name container1 --network my_network nginx
docker run -d --name container2 --network my_network nginx
```

Diese Befehle starten zwei Container (container1 und container2) und verbinden sie mit dem zuvor erstellten Netzwerk "my_network".

### Beispiel 4: Anzeigen von Netzwerkdetails

```bash
docker network inspect my_network
```

Dieser Befehl zeigt detaillierte Informationen über das Netzwerk "my_network" an, einschließlich der zugehörigen Container und Konfigurationen.

### Beispiel 5: Löschen eines Docker-Netzwerks

```bash
docker network rm my_network
```

Dieser Befehl löscht das Docker-Netzwerk mit dem Namen "my_network".