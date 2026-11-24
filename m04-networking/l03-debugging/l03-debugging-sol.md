# Lab 4.3 – Lösung: Fehlersuche und Ressourcengrenzen

Fertiger Stand: `project/examples/m04-networking/l03-debugging/compose.yml`; Fehlerbilder in `project/variants/m04-l03-debugging/`. Getestet am 24.11.2026 mit Docker 29.9.3 und Compose 5.7.0; IDs und Zeiten weichen ab.

## Aufgabe 1: Fehlerbild 1, Startbefehl

```bash
cd playground/debugging/fehler1-cmd
docker compose up -d --build
docker compose ps -a
```

```text
NAME                     STATUS
fehler1-cmd-backend-1    Up 3 seconds
fehler1-cmd-frontend-1   Exited (2) 3 seconds ago
```

(Spalten gekürzt auf `NAME` und `STATUS`, wie mit `--format 'table {{.Name}}\t{{.Status}}'`.)

```bash
docker compose logs frontend
```

```text
frontend-1  | python: can't open file '/app/main.py': [Errno 2] No such file or directory
```

- Das `Dockerfile` dieses Ordners startet `CMD ["python", "main.py"]`; die App heißt `app.py`. Exit-Code `2` heißt bei Python: Startdatei nicht gefunden.
- `docker run --rm fehler1-cmd-frontend ls /app` listet `app.py` und `requirements.txt`, kein `main.py`.
- Korrektur in der letzten Zeile von `fehler1-cmd/Dockerfile`:

```dockerfile
CMD ["python", "app.py"]
```

```bash
docker compose up -d --build
```

`http://localhost:8091` zeigt „Hello-App v1" mit z. B. `Backend: b47d352abc70 (172.19.0.2) um 23:14:37`. Ohne `--build` startet Compose wieder das alte Image mit dem falschen `CMD`.

## Aufgabe 2: Fehlerbild 2, Netzwerk

```bash
cd ../fehler2-netzwerk
docker compose up -d
```

Die Seite auf Port 8092 lädt und zeigt `Backend nicht erreichbar (http://backend): ConnectionError` (siehe Bild in der Theorie). Beide Container laufen (`ps -a`: zweimal `Up`).

```bash
docker compose exec frontend wget -qO- -T 3 http://backend/api
```

```text
wget: bad address 'backend'
```

```bash
docker network inspect fehler2-netzwerk_frontend-net --format '{{range .Containers}}{{println .Name .IPv4Address}}{{end}}'
docker network inspect fehler2-netzwerk_backend-net --format '{{range .Containers}}{{println .Name .IPv4Address}}{{end}}'
```

```text
fehler2-netzwerk-frontend-1 172.19.0.2/16

fehler2-netzwerk-backend-1 172.20.0.2/16
```

- Das Frontend hängt nur in `frontend-net`, das Backend nur in `backend-net`: kein gemeinsames Netzwerk, der Name `backend` ist für das Frontend unbekannt.
- Korrektur: Frontend zusätzlich in `backend-net` (Muster aus Lab 4.2):

```yaml
  frontend:
    image: hello-frontend:v1
    ports:
      - "8092:80"
    networks:
      - frontend-net
      - backend-net                       # neu
```

Nach `docker compose up -d` zeigt die Seite `Backend: 6f9547bfeaa4 (172.20.0.2) um 23:15:01`. Gleichwertig, aber gegen das Muster: das Backend zusätzlich in `frontend-net` hängen.

## Aufgabe 3: Fehlerbild 3, Speicher

```bash
cd ../fehler3-speicher
docker compose up -d
docker compose ps -a
docker compose logs backend
docker inspect -f 'status={{.State.Status}} exit={{.State.ExitCode}} oom={{.State.OOMKilled}} limit={{.HostConfig.Memory}}' fehler3-speicher-backend-1
```

```text
NAME                          STATUS
fehler3-speicher-backend-1    Exited (137) 2 seconds ago
fehler3-speicher-frontend-1   Up 4 seconds

status=exited exit=137 oom=true limit=8388608
```

`logs backend` gibt nichts aus: Der Prozess wurde beendet, bevor er etwas schreiben konnte.

- Die Grenze `memory: 8M` (8388608 Bytes) ist zu klein; Python mit Flask braucht rund 25 MiB. Der OOM-Killer beendet den Prozess, Exit-Code `137`, `OOMKilled: true`.
- Korrektur: Grenze erhöhen:

```yaml
    deploy:
      resources:
        limits:
          memory: 128M
          cpus: "0.5"
```

```bash
docker compose up -d
docker stats --no-stream
```

```text
NAME                          CPU %     MEM USAGE / LIMIT     MEM %
fehler3-speicher-backend-1    0.02%     25.41MiB / 128MiB     19.85%
fehler3-speicher-frontend-1   0.04%     30.36MiB / 7.748GiB   0.38%
```

(Ausgabe mit `--format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}'` auf vier Spalten gekürzt.) Das Frontend hat in diesem Fehlerbild keine Grenze: Sein Limit ist der ganze Speicher der Docker-VM. Die Seite auf Port 8093 zeigt `Backend: 6ea529188bf2 (172.19.0.2) um 23:15:22`.

## Aufgabe 4: Grenzen für die Hello-App

```yaml
  backend:
    # … image, networks, healthcheck wie in Lab 4.2
    deploy:
      resources:
        limits:
          memory: 128M
          cpus: "0.5"

  frontend:
    # … image, ports, networks, environment, depends_on, volumes wie in Lab 4.2
    deploy:
      resources:
        limits:
          memory: 128M
          cpus: "0.5"
```

`deploy` steht auf derselben Einrückung wie `image`. Vollständige Datei: `examples/m04-networking/l03-debugging/compose.yml`.

```bash
cd ../..                     # zurück nach playground
docker compose up -d
docker stats --no-stream --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}'
```

```text
NAME               CPU %     MEM USAGE / LIMIT   MEM %
hello-frontend-1   0.02%     30.31MiB / 128MiB   23.68%
hello-backend-1    3.18%     25.3MiB / 128MiB    19.77%
```

128 MiB lassen beiden Diensten etwa das Vierfache ihres Bedarfs. Läuft das Fehlerbild 3 noch, erscheint es ebenfalls in der Liste.

## Aufgabe 5: Aufräumen

```bash
cd debugging/fehler1-cmd && docker compose down && cd ..
cd fehler2-netzwerk && docker compose down && cd ..
cd fehler3-speicher && docker compose down && cd ../..
docker ps -a --filter name=fehler
```

```text
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

| Fehlerbild | Gruppe | Befehl, der die Ursache zeigte |
| --- | --- | --- |
| 1 `fehler1-cmd` | Start | `docker compose ps -a` (Exited 2) + `docker compose logs frontend` |
| 2 `fehler2-netzwerk` | Netzwerk | `docker compose exec frontend wget …` + `docker network inspect` |
| 3 `fehler3-speicher` | Ressourcen | `docker compose ps -a` (Exited 137) + `docker inspect … OOMKilled` |
