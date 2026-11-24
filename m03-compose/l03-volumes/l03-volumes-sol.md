# Lab 3.3 – Lösung: Volumes und Persistenz

Fertiger Stand: `project/examples/m03-compose/l03-volumes/compose.yml`. Alle Befehle im Ordner `project/playground`. Getestet am 24.11.2026 mit Docker 29.9.3 und Compose 5.7.0; IDs und Zeiten weichen ab.

## Aufgabe 1: ohne Volume

```bash
docker compose up -d
# http://localhost:8080 dreimal laden
docker compose exec frontend wc -l /data/access.log
```

```text
3 /data/access.log
```

```bash
docker compose exec frontend cat /data/access.log
```

```text
2026-11-23T23:12:18 f0e249bad4ca 172.19.0.3 v1
2026-11-23T23:12:18 f0e249bad4ca 172.19.0.3 v1
2026-11-23T23:12:18 f0e249bad4ca 172.19.0.3 v1
```

Jede Zeile: Zeitpunkt, Container-ID, IP und Version des Frontends, das die Seite ausgeliefert hat.

```bash
docker compose down
docker compose up -d
# Seite einmal laden
docker compose exec frontend wc -l /data/access.log
```

```text
1 /data/access.log
```

Die drei alten Zeilen lagen in der beschreibbaren Schicht des alten Containers und sind mit ihm gelöscht.

## Aufgabe 2: mit Named Volume

```yaml
  frontend:
    image: hello-frontend:v1
    ports:
      - "${FRONTEND_PORT:-8080}:80"
    environment:
      BACKEND_URL: http://backend
      APP_COLOR: ${APP_COLOR:-lightblue}
    depends_on:
      backend:
        condition: service_healthy
    volumes:
      - hello-data:/data                  # Named Volume im Container unter /data

volumes:
  hello-data:                             # ganz links, auf derselben Ebene wie services:
```

```bash
docker compose down
docker compose up -d
```

```text
[+] up 4/4
 ✔ Volume hello_hello-data    Created
 ✔ Network hello_default      Created
 ✔ Container hello-backend-1  Healthy
 ✔ Container hello-frontend-1 Started
```

Nach dreimal Laden `3 /data/access.log`, dann:

```bash
docker compose down
```

```text
[+] down 3/3
 ✔ Container hello-frontend-1 Removed
 ✔ Container hello-backend-1  Removed
 ✔ Network hello_default      Removed
```

Das Volume steht nicht in der Liste: `down` lässt es stehen.

```bash
docker compose up -d
# Seite einmal laden
docker compose exec frontend wc -l /data/access.log
docker compose exec frontend cat /data/access.log
```

```text
4 /data/access.log
2026-11-23T23:12:49 61542caf2016 172.19.0.3 v1
2026-11-23T23:12:49 61542caf2016 172.19.0.3 v1
2026-11-23T23:12:49 61542caf2016 172.19.0.3 v1
2026-11-23T23:13:04 0680445af084 172.19.0.3 v1
```

Die vierte Zeile stammt von einem anderen Container (`0680445af084`), die Datei ist dieselbe. Den Ablauf zeigt auch das Bild in der Theorie.

## Aufgabe 3: Volume ansehen

```bash
docker volume ls
```

```text
DRIVER    VOLUME NAME
local     hello_hello-data
```

```bash
docker volume inspect hello_hello-data
```

```text
[
    {
        "CreatedAt": "2026-11-23T23:12:42Z",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.config-hash": "96c3fbc31b19…",
            "com.docker.compose.project": "hello",
            "com.docker.compose.version": "5.7.0",
            "com.docker.compose.volume": "hello-data"
        },
        "Mountpoint": "/var/lib/docker/volumes/hello_hello-data/_data",
        "Name": "hello_hello-data",
        "Options": null,
        "Scope": "local"
    }
]
```

In Docker Desktop: **Volumes** → `hello_hello-data` → **Stored data** listet `access.log`; ein Klick öffnet die vier Zeilen. **Container in-use** zeigt `hello-frontend-1` mit dem Pfad `/data`.

## Aufgabe 4: down -v

```bash
docker compose down -v
```

```text
[+] down 4/4
 ✔ Container hello-frontend-1 Removed
 ✔ Container hello-backend-1  Removed
 ✔ Volume hello_hello-data    Removed
 ✔ Network hello_default      Removed
```

`docker volume ls` listet `hello_hello-data` nicht mehr. `docker compose up -d` legt ein neues, leeres Volume an (`Volume hello_hello-data Created`); die Zählung beginnt wieder bei 1. Die Hello-App läuft danach weiter.
