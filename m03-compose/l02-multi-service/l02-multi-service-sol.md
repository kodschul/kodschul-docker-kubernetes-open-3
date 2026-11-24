# Lab 3.2 – Lösung: Healthcheck, Watch und Replikas

Fertiger Stand: `project/examples/m03-compose/l02-multi-service/compose.yml`. Alle Befehle im Ordner `project/playground`. Getestet am 24.11.2026 mit Docker 29.9.3 und Compose 5.7.0; IDs, Zeiten und Ports weichen ab.

## Aufgabe 1: Healthcheck und depends_on

```yaml
  backend:
    image: hello-backend:v1
    ports:
      - "8081:80"
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://127.0.0.1/healthz"]
      interval: 5s
      timeout: 2s
      retries: 3
      start_period: 5s

  frontend:
    # … image, build, ports, environment wie im Starter
    depends_on:
      backend:
        condition: service_healthy
```

```bash
docker compose up -d
```

```text
…                                 (Ausgabe des Builds)
[+] up 4/4
 ✔ Image hello-frontend:dev   Built
 ✔ Network hello_default      Created
 ✔ Container hello-backend-1  Healthy
 ✔ Container hello-frontend-1 Started
```

`hello-frontend:dev` gibt es noch nicht, deshalb baut `up` es zuerst aus `playground/frontend/Dockerfile`. Während des Wartens steht beim Backend `Waiting`, nach der ersten erfolgreichen Prüfung `Healthy`; erst dann startet das Frontend.

`docker compose ps`, solange `up -d` wartet:

```text
NAME              IMAGE              COMMAND           SERVICE   CREATED         STATUS                           PORTS
hello-backend-1   hello-backend:v1   "python app.py"   backend   2 seconds ago   Up 1 second (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp
```

Nach dem Ende von `up -d`:

```text
NAME               IMAGE                COMMAND           SERVICE    CREATED          STATUS                    PORTS
hello-backend-1    hello-backend:v1     "python app.py"   backend    10 seconds ago   Up 10 seconds (healthy)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp
hello-frontend-1   hello-frontend:dev   "python app.py"   frontend   10 seconds ago   Up 4 seconds              0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
```

Das Frontend lief im Test rund 6 Sekunden nach dem Backend an (`Up 4 seconds` gegenüber `Up 10 seconds`): so lange dauerte es bis zum ersten erfolgreichen Healthcheck. Die letzten Prüfungen:

```bash
docker inspect --format '{{json .State.Health}}' hello-backend-1
```

```text
{"Status":"healthy","FailingStreak":0,"Log":[{"Start":"2026-11-23T23:09:14.74Z","End":"2026-11-23T23:09:14.90Z","ExitCode":0,"Output":"ok"}, …]}
```

`ExitCode: 0` und `Output: ok` sind die Antwort von `/healthz`.

## Aufgabe 2: Compose Watch

```yaml
  frontend:
    # …
    depends_on:
      backend:
        condition: service_healthy
    develop:
      watch:
        - path: ./frontend/app.py
          action: rebuild
```

```bash
docker compose watch
```

Änderung in `frontend/app.py`:

```python
  <h1>Hallo Docker {APP_VERSION}</h1>
```

Das Watch-Terminal meldet nach dem Speichern (gekürzt):

```text
Watch enabled
Rebuilding service(s) ["frontend"] after changes were detected...
 Image hello-frontend:dev Building
 Image hello-frontend:dev Built
service(s) ["frontend"] successfully built
 Container hello-frontend-1 Recreate
 Container hello-frontend-1 Recreated
 Container hello-frontend-1 Started
```

`http://localhost:8080` zeigt „Hallo Docker v1" mit einer neuen Frontend-ID (neuer Container). Der Neubau dauerte im Test rund 5 Sekunden, weil nur die letzte Schicht (`COPY app.py`) neu entsteht; die Schicht mit `pip install` kommt aus dem Cache (Lab 2.2).

## Aufgabe 3: Änderung rückgängig machen

Nach dem Zurückändern auf `<h1>Hello-App {APP_VERSION}</h1>` baut Watch erneut; die Seite zeigt wieder „Hello-App v1". `Strg+C` beendet das Beobachten, die Container laufen weiter. `hello-frontend:v1` aus Lab 2.2 blieb in der ganzen Zeit unverändert, weil Watch nur `hello-frontend:dev` baut.

## Aufgabe 4: drei Frontends

```yaml
  frontend:
    image: hello-frontend:dev
    build: ./frontend
    ports:
      - "80"                              # nur Container-Port
    deploy:
      replicas: 3
    # … environment, depends_on, develop wie bisher
```

```bash
docker compose up -d
docker compose ps
```

```text
NAME               IMAGE                COMMAND           SERVICE    CREATED         STATUS                   PORTS
hello-backend-1    hello-backend:v1     "python app.py"   backend    7 seconds ago   Up 7 seconds (healthy)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp
hello-frontend-1   hello-frontend:dev   "python app.py"   frontend   7 seconds ago   Up 1 second              0.0.0.0:54662->80/tcp, [::]:54662->80/tcp
hello-frontend-2   hello-frontend:dev   "python app.py"   frontend   7 seconds ago   Up 1 second              0.0.0.0:54663->80/tcp, [::]:54663->80/tcp
hello-frontend-3   hello-frontend:dev   "python app.py"   frontend   7 seconds ago   Up Less than a second    0.0.0.0:54664->80/tcp, [::]:54664->80/tcp
```

```bash
docker compose port --index 1 frontend 80
docker compose port --index 2 frontend 80
```

```text
0.0.0.0:54662
0.0.0.0:54663
```

| Adresse | Frontend-Zeile | Backend-Zeile |
| --- | --- | --- |
| `http://localhost:54662` | `542bba828f2b (172.19.0.3)` | `a62352f2e0e1 (172.19.0.2)` |
| `http://localhost:54663` | `a7019a77a7e9 (172.19.0.4)` | `a62352f2e0e1 (172.19.0.2)` |

Jede Kopie ist ein eigener Container mit eigener ID und IP; alle fragen dasselbe Backend. Die Port-Nummern vergibt Docker zufällig; sie weichen auf jedem Rechner ab. `http://localhost:8080` antwortet in diesem Stand nicht mehr.

## Aufgabe 5: Aufräumen

```bash
docker compose down
```

```text
[+] down 5/5
 ✔ Container hello-frontend-2 Removed
 ✔ Container hello-frontend-1 Removed
 ✔ Container hello-frontend-3 Removed
 ✔ Container hello-backend-1  Removed
 ✔ Network hello_default      Removed
```
