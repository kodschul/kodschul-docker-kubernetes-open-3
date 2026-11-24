# Cheatsheet: Docker Compose

Befehle und Syntax aus Modul 3 (Labs 3.1–3.3). Alle `docker compose`-Befehle wirken auf die Compose-Datei im aktuellen Ordner (`project/playground`).

## Projekt starten und stoppen

| Befehl | Wirkung |
| --- | --- |
| `docker compose up -d` | Dienste im Hintergrund starten; fehlende Images bauen, Änderungen an der Datei übernehmen |
| `docker compose up -d --build` | Images vor dem Start neu bauen (nach Code-Änderungen) |
| `docker compose up -d --scale frontend=5` | Anzahl der Container eines Dienstes für diesen Aufruf festlegen |
| `docker compose down` | Container und Projektnetzwerk entfernen; Volumes und Images bleiben |
| `docker compose down -v` | zusätzlich die Named Volumes des Projekts löschen |
| `docker compose -f test.yml up -d` | andere Compose-Datei nutzen; `-f` steht vor dem Unterbefehl |

## Status, Logs und Konfiguration

| Befehl | Wirkung |
| --- | --- |
| `docker compose ps` | laufende Container des Projekts mit Status (`healthy`) und Ports |
| `docker compose ps -a` | auch beendete und wartende (`Created`) Container |
| `docker compose logs` | Ausgaben aller Dienste |
| `docker compose logs -f backend` | Ausgaben eines Dienstes live mitlesen (`Strg+C` beendet das Mitlesen) |
| `docker compose port --index 2 frontend 80` | Rechner-Port der zweiten Kopie für Container-Port 80 |
| `docker compose exec frontend wc -l /data/access.log` | Befehl im laufenden Dienst-Container ausführen |
| `docker compose config` | Compose-Datei mit eingesetzten Werten aus `.env` anzeigen |
| `docker compose version` | Compose-Version (`docker-compose` mit Bindestrich ist v1 und veraltet) |
| `docker inspect --format '{{json .State.Health}}' hello-backend-1` | Ergebnis der letzten Healthchecks |

## Entwicklungsmodus

| Befehl | Wirkung |
| --- | --- |
| `docker compose watch` | Dienste starten und Dateien nach `develop.watch` beobachten; `Strg+C` beendet das Beobachten |
| `docker compose up --watch` | dasselbe, zusätzlich mit den Ausgaben der Anwendung |

## Volumes

| Befehl | Wirkung |
| --- | --- |
| `docker volume create test-data` | Named Volume anlegen |
| `docker volume ls` | alle Volumes auflisten |
| `docker volume inspect hello_hello-data` | Details: Treiber, `Mountpoint`, Compose-Projekt |
| `docker volume rm test-data` | Volume löschen (kein Container darf es nutzen) |
| `docker volume prune` | alle ungenutzten Volumes löschen (Vorsicht) |
| `docker run -v test-data:/data …` | Named Volume einbinden |
| `docker run -v ./site:/usr/share/nginx/html …` | Bind Mount: Ordner des Rechners einbinden |

## Compose-Datei der Hello-App

```yaml
name: hello                                # Projektname (sonst Ordnername)

services:
  backend:
    image: hello-backend:v1                # fertiges Image
    ports:
      - "8081:80"                          # Rechner-Port:Container-Port
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://127.0.0.1/healthz"]
      interval: 5s
      timeout: 2s
      retries: 3
      start_period: 5s

  frontend:
    image: hello-frontend:v1               # Name des Images (mit build: Name des gebauten Images)
    # build: ./frontend                    # Image aus Ordner mit Dockerfile bauen
    ports:
      - "${FRONTEND_PORT:-8080}:80"        # Wert aus .env, sonst 8080; "80" = zufälliger Rechner-Port
    environment:
      BACKEND_URL: http://backend          # Dienstname = Hostname im Projektnetzwerk
      APP_COLOR: ${APP_COLOR:-lightblue}
    # env_file: [frontend.env]             # Umgebungsvariablen aus Datei
    depends_on:
      backend:
        condition: service_healthy         # service_started | service_healthy | service_completed_successfully
    volumes:
      - hello-data:/data                   # Named Volume; ./ordner:/pfad wäre ein Bind Mount
    # deploy:
    #   replicas: 3                        # mehrere Kopien (nur mit Port "80")
    # develop:
    #   watch:
    #     - path: ./frontend/app.py
    #       action: rebuild                # rebuild | sync (mit target:) | sync+restart

volumes:
  hello-data:                              # Named Volumes auf oberster Ebene anlegen
```

## Werte und Variablen

| Stelle | Gelesen von | Zeitpunkt |
| --- | --- | --- |
| `.env` + `${VAR}` / `${VAR:-standard}` | Compose | beim Einlesen der Compose-Datei |
| `environment:` / `env_file:` | Container | beim Start |
| `ARG` im Dockerfile, `--build-arg` (Lab 2.2) | Build | beim Bauen |

## Namen, die Compose vergibt

| Objekt | Schema | Beispiel |
| --- | --- | --- |
| Container | `<projekt>-<dienst>-<nr>` | `hello-frontend-1` |
| Netzwerk | `<projekt>_default` | `hello_default` |
| Named Volume | `<projekt>_<volume>` | `hello_hello-data` |
| gebautes Image ohne `image:` | `<projekt>-<dienst>` | `hello-frontend` |
| Hostname eines Dienstes im Projektnetzwerk | `<dienst>` | `http://backend` |

Dateinamen, die Compose ohne `-f` findet: `compose.yaml`, `compose.yml`, `docker-compose.yaml`, `docker-compose.yml`. Das Feld `version:` ist veraltet und wird ignoriert.
