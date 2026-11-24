# Lab 4.2 – Lösung: Netzwerke in Compose

Fertiger Stand: `project/examples/m04-networking/l02-compose-networks/compose.yml`. Alle Befehle im Ordner `project/playground`. Getestet am 24.11.2026 mit Docker 29.9.3 und Compose 5.7.0; IDs und IPs weichen ab.

## Aufgabe 1: networks in compose.yml

```yaml
name: hello

services:
  backend:
    image: hello-backend:v1
    networks:
      - backend-net                       # nur intern erreichbar, kein ports: mehr
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://127.0.0.1/healthz"]
      interval: 5s
      timeout: 2s
      retries: 3
      start_period: 5s

  frontend:
    image: hello-frontend:v1
    ports:
      - "${FRONTEND_PORT:-8080}:80"
    networks:
      - frontend-net
      - backend-net
    environment:
      BACKEND_URL: http://backend
      APP_COLOR: ${APP_COLOR:-lightblue}
    depends_on:
      backend:
        condition: service_healthy
    volumes:
      - hello-data:/data

networks:
  frontend-net:
  backend-net:

volumes:
  hello-data:
```

```bash
docker compose up -d
```

```text
[+] up 4/4
 ✔ Network hello_backend-net  Created
 ✔ Network hello_frontend-net Created
 ✔ Container hello-backend-1  Healthy
 ✔ Container hello-frontend-1 Started
```

Beide Container werden neu erstellt (`Recreate` während des Laufs), weil sich ihre Netzwerke geändert haben. Das Volume `hello_hello-data` bleibt; `access.log` zählt weiter.

## Aufgabe 2: Erreichbarkeit von außen

- `http://localhost:8080` zeigt „Hello-App v1" mit `Backend: 333ae5a08fae (172.19.0.2) um 23:13:40`.
- `http://localhost:8081/api` meldet im Browser „Die Website ist nicht erreichbar"; `curl -s -m 3 http://localhost:8081/api` endet mit Exit-Code `7` (keine Verbindung). Ohne `ports:` gibt es keinen Weg vom Rechner zum Backend.

## Aufgabe 3: Netzwerke prüfen

```bash
docker network ls --filter name=hello
```

```text
NETWORK ID     NAME                 DRIVER    SCOPE
4c486fd1adee   hello_backend-net    bridge    local
4499643a79d6   hello_default        bridge    local
5dda9a7253e8   hello_frontend-net   bridge    local
```

`hello_default` stammt aus Lab 3.3 und ist jetzt leer: Kein Dienst nennt es mehr. Compose entfernt es beim nächsten `docker compose down`.

```bash
docker network inspect hello_frontend-net --format '{{range .Containers}}{{println .Name .IPv4Address}}{{end}}'
docker network inspect hello_backend-net --format '{{range .Containers}}{{println .Name .IPv4Address}}{{end}}'
```

```text
hello-frontend-1 172.20.0.2/16

hello-frontend-1 172.19.0.3/16
hello-backend-1 172.19.0.2/16
```

Das Frontend hat zwei IPs, je Netzwerk eine. Die Hello-Seite zeigt nur eine davon.

## Aufgabe 4: Wer erreicht das Backend?

```bash
docker run --rm --network hello_frontend-net busybox:1.37 wget -qO- -T 3 http://backend/api
```

```text
wget: bad address 'backend'
```

```bash
docker run --rm --network hello_backend-net busybox:1.37 wget -qO- -T 3 http://backend/api
```

```json
{"ip":"172.19.0.2","pod":"333ae5a08fae","time":"23:13:41","version":"v1"}
```

| Wer | erreicht das Backend? | Grund |
| --- | --- | --- |
| Browser auf dem eigenen Rechner | nein | kein `ports:` beim Backend |
| Container nur in `hello_frontend-net` | nein | kein gemeinsames Netzwerk, der Name `backend` ist dort unbekannt |
| Container in `hello_backend-net` (auch das Frontend) | ja | gemeinsames Netzwerk, DNS löst `backend` auf |

Die Ausgaben aller drei Prüfungen zeigt das Terminal-Bild in der Theorie.
