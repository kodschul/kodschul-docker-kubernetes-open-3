## Docker: Kommunikation zwischen Containern über Docker-Netzwerke

Docker ermöglicht die einfache Bereitstellung und Verwaltung von Containern, und Docker-Netzwerke bieten eine Möglichkeit für Container, miteinander zu kommunizieren. Im Folgenden sind einige grundlegende Konzepte und Beispiele zur Kommunikation zwischen Containern über Docker-Netzwerke:

### Beispiel 1: Erstellen eines Docker-Netzwerks

```bash
docker network create my_network
```

Mit diesem Befehl wird ein Docker-Netzwerk mit dem Namen my_network erstellt. Container können diesem Netzwerk hinzugefügt werden, um miteinander zu kommunizieren.

### Beispiel 2: Starten von Containern im Docker-Netzwerk

```bash
docker run -d --name container1 --network my_network my_image1
docker run -d --name container2 --network my_network my_image2
```

Hier werden zwei Container (container1 und container2) gestartet und dem zuvor erstellten Docker-Netzwerk my_network hinzugefügt. Die Container verwenden jeweils unterschiedliche Images (my_image1 und my_image2).

### Beispiel 3: Kommunikation zwischen Containern im Docker-Netzwerk

```bash
docker exec container1 ping container2
```

Mit diesem Befehl kann der Container container1 den Container container2 im Docker-Netzwerk my_network erreichen. Dies ermöglicht die Kommunikation zwischen den Containern über das Netzwerk.

### Beispiel 4: Verwendung von Docker-Compose für die Netzwerkkonfiguration

```yaml
version: '3'
services:
  service1:
    image: my_image1
    networks:
      - my_network
  service2:
    image: my_image2
    networks:
      - my_network
networks:
  my_network:
```

In dieser Docker-Compose-Datei wird definiert, wie Container miteinander kommunizieren können. Beide Dienste (service1 und service2) sind Teil des Netzwerks my_network, was es ihnen ermöglicht, miteinander zu interagieren.