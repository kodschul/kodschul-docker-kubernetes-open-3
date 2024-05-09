## Docker: Konfiguration von Diensten und Netzwerken in Docker Compose-Dateien

Docker Compose ist ein Tool von Docker, das es ermöglicht, mehrere Container als Dienste in einer einzigen Datei zu definieren und zu verwalten. Diese Datei, oft als "docker-compose.yml" bezeichnet, enthält Konfigurationsinformationen für die Dienste sowie die Netzwerk- und Speichervolumenkonfigurationen. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zur Konfiguration von Diensten und Netzwerken in Docker Compose-Dateien:

### Beispiel 1: Definieren eines einfachen Dienstes

```yaml
version: '3'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
```

In diesem Beispiel wird ein einfacher Dienst mit dem Namen "web" definiert. Die Konfiguration gibt an, dass der Container die neueste Version des Nginx-Images verwenden soll und den Port 8080 des Hosts auf den Port 80 des Containers abbilden soll.

### Beispiel 2: Verwendung von Umgebungsvariablen

```yaml
version: '3'

services:
  app:
    image: myapp:latest
    environment:
      - DB_HOST=db
      - DB_PORT=5432
    depends_on:
      - db

  db:
    image: postgres:latest
```

Hier wird ein Anwendungscontainer (app) definiert, der auf eine PostgreSQL-Datenbank (db) zugreift. Die Umgebungsvariablen DB_HOST und DB_PORT werden verwendet, um die Verbindungsinformationen anzugeben. Der Anwendungscontainer ist auch von der Verfügbarkeit des Datenbankcontainers abhängig (depends_on).

### Beispiel 3: Konfiguration eines eigenen Netzwerks

```yaml
version: '3'

services:
  app:
    image: myapp:latest
    networks:
      - mynetwork

  db:
    image: postgres:latest
    networks:
      - mynetwork

networks:
  mynetwork:
    driver: bridge
```

Hier wird ein benutzerdefiniertes Netzwerk mit dem Namen "mynetwork" definiert, das von beiden Containern (app und db) verwendet wird. Die Kommunikation zwischen den Containern erfolgt über dieses Netzwerk, das als Bridge-Netzwerk konfiguriert ist.