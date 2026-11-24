# Lab 3.1 – Lösung: Compose-Grundlagen

Fertiger Stand: `project/examples/m03-compose/l01-compose-basics/` (`compose.yml`, `.env`). Alle Befehle im Ordner `project/playground`. Getestet am 24.11.2026 mit Docker 29.9.3 und Compose 5.7.0; IDs, IPs und Uhrzeiten weichen ab.

## Aufgabe 1: compose.yml vervollständigen

```yaml
name: hello

services:
  backend:
    image: hello-backend:v1
    ports:
      - "8081:80"

  frontend:
    image: hello-frontend:v1              # Image aus Lab 2.2
    ports:
      - "8080:80"                         # wie -p 8080:80
    environment:
      BACKEND_URL: http://backend         # Dienstname = Hostname im Projektnetzwerk
```

`environment` gibt es auch als Liste: `- BACKEND_URL=http://backend`. Beide Schreibweisen wirken gleich.

## Aufgabe 2: Starten und prüfen

```bash
docker compose up -d
```

```text
[+] up 3/3
 ✔ Network hello_default      Created
 ✔ Container hello-backend-1  Started
 ✔ Container hello-frontend-1 Started
```

```bash
docker compose ps
```

```text
NAME               IMAGE               COMMAND           SERVICE    CREATED         STATUS         PORTS
hello-backend-1    hello-backend:v1    "python app.py"   backend    4 seconds ago   Up 3 seconds   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp
hello-frontend-1   hello-frontend:v1   "python app.py"   frontend   4 seconds ago   Up 3 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
```

`http://localhost:8080` zeigt die hellblaue Seite „Hello-App v1" mit z. B. `Backend: 2eea43f12196 (172.19.0.3) um 23:08:44`. `http://localhost:8081/api` liefert:

```json
{"ip":"172.19.0.3","pod":"2eea43f12196","time":"23:08:44","version":"v1"}
```

`pod` ist hier die Container-ID (der Hostname des Containers); der Feldname stammt aus Tag 2, an dem dieselbe App in Kubernetes-Pods läuft.

```bash
docker compose logs backend
```

```text
backend-1  | Hello-Backend v1 auf Port 80
backend-1  |  * Serving Flask app 'app'
backend-1  |  * Debug mode: off
backend-1  | WARNING: This is a development server. Do not use it in a production deployment. …
backend-1  |  * Running on all addresses (0.0.0.0)
backend-1  |  * Running on http://127.0.0.1:80
backend-1  |  * Running on http://172.19.0.3:80
backend-1  | Press CTRL+C to quit
backend-1  | 172.19.0.2 - - [23/Nov/2026 23:08:44] "GET / HTTP/1.1" 200 -
backend-1  | 192.168.65.1 - - [23/Nov/2026 23:08:44] "GET /api HTTP/1.1" 200 -
```

- `172.19.0.2` ist das Frontend: Jeder Seitenaufruf im Browser löst eine Anfrage an das Backend aus.
- `192.168.65.1` ist der Browser auf dem eigenen Rechner (Docker Desktop leitet über diese Adresse weiter).
- Die Warnung zum Entwicklungsserver von Flask ist für den Kurs unwichtig. Container rechnen in UTC; Datum und Uhrzeit im Log können deshalb von der Uhr des eigenen Rechners abweichen.

## Aufgabe 3: Werte aus .env

```bash
# playground/.env
FRONTEND_PORT=8080
APP_COLOR=lightyellow
```

```yaml
  frontend:
    image: hello-frontend:v1
    ports:
      - "${FRONTEND_PORT}:80"
    environment:
      BACKEND_URL: http://backend
      APP_COLOR: ${APP_COLOR}
```

```bash
docker compose config
```

```text
name: hello
services:
  backend:
    image: hello-backend:v1
    networks:
      default: null
    ports:
      - mode: ingress
        target: 80
        published: "8081"
        protocol: tcp
  frontend:
    environment:
      APP_COLOR: lightyellow              ← aus .env eingesetzt
      BACKEND_URL: http://backend
    image: hello-frontend:v1
    networks:
      default: null
    ports:
      - mode: ingress
        target: 80
        published: "8080"                 ← aus .env eingesetzt
        protocol: tcp
networks:
  default:
    name: hello_default                   ← von Compose ergänzt
```

`config` schreibt jede Angabe in der ausführlichen Form; `networks: default` hat Compose selbst ergänzt. Nach `docker compose up -d` ist die Seite hellgelb (siehe Bild in der Theorie).

## Aufgabe 4: Port und Farbe ändern

```bash
# playground/.env
FRONTEND_PORT=8090
APP_COLOR=orange
```

```bash
docker compose up -d
```

```text
[+] up 2/2
 ✔ Container hello-backend-1  Running
 ✔ Container hello-frontend-1 Started
```

Compose vergleicht die Datei mit den laufenden Containern: Nur beim Frontend haben sich Port und Umgebung geändert, deshalb wird nur `hello-frontend-1` neu erstellt (`Recreate` während des Laufs). `http://localhost:8090` zeigt die orange Seite, `http://localhost:8080` antwortet nicht mehr. Nach dem Zurücksetzen auf `8080` und `lightyellow` und einem weiteren `up -d` gilt wieder der Stand aus Aufgabe 3.

## Aufgabe 5: Aufräumen

```bash
docker compose down
```

```text
[+] down 3/3
 ✔ Container hello-frontend-1 Removed
 ✔ Container hello-backend-1  Removed
 ✔ Network hello_default      Removed
```

```bash
docker compose ps
docker images "hello-*"
```

```text
NAME      IMAGE     COMMAND   SERVICE   CREATED   STATUS    PORTS

IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-backend:v1     f561aedadd5e       99.6MB         23.7MB
hello-frontend:v1    957ba4a393dd        105MB         24.8MB
hello-frontend:v2    f7362db60898        105MB         24.8MB
hello-world:latest   1e4c05b897a7       22.6kB         10.3kB
```

`down` entfernt Container und Netzwerk, die Images bleiben. Der Filter `hello-*` trifft auch `hello-world` aus Lab 1.1.
