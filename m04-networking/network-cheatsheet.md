# Cheatsheet: Netzwerke, Fehlersuche und Swarm

Befehle und Syntax aus Modul 4 (Labs 4.1–4.4). Kurs-Shell `bash`; unter Windows Git Bash mit `MSYS_NO_PATHCONV=1`.

## Netzwerke anzeigen und prüfen

| Befehl | Wirkung |
| --- | --- |
| `docker network ls` | alle Netzwerke mit Treiber (`bridge`, `host`, `none`, eigene) |
| `docker network ls --filter name=hello` | nur Netzwerke, deren Name `hello` enthält |
| `docker network inspect hello-net` | Treiber, Subnetz, Gateway, verbundene Container als JSON |
| `docker network inspect hello-net --format '{{range .Containers}}{{println .Name .IPv4Address}}{{end}}'` | nur Container und IPs eines Netzwerks |
| `docker port frontend` | veröffentlichte Ports eines Containers |

## Netzwerke anlegen, verbinden, löschen

| Befehl | Wirkung |
| --- | --- |
| `docker network create hello-net` | Bridge-Netzwerk anlegen (Standardtreiber) |
| `docker run -d --name backend --network hello-net hello-backend:v1` | Container beim Start einem Netzwerk zuordnen; Name = Hostname |
| `docker run -d --name frontend --network hello-net -p 8080:80 -e BACKEND_URL=http://backend hello-frontend:v1` | Netzwerk, veröffentlichter Port und Umgebungsvariable |
| `docker network connect hello-net test` | laufenden Container zusätzlich in ein Netzwerk hängen |
| `docker network disconnect hello-net test` | Container aus einem Netzwerk entfernen |
| `docker network rm hello-net` | Netzwerk löschen (nur ohne verbundene Container) |

## Netzwerkmodi beim Start

| Angabe | Wirkung |
| --- | --- |
| ohne `--network` | Standard-Bridge: eigene IP, keine Namensauflösung zwischen Containern |
| `--network <eigenes-netz>` | eigene IP, andere Container per Name erreichbar (DNS `127.0.0.11`) |
| `--network host` | Netzwerk des Hosts direkt, `-p` wirkungslos; Docker Desktop: Host = Linux-VM |
| `--network none` | nur Loopback, weder Container noch Internet erreichbar |

## Verbindung testen

| Befehl | Wirkung |
| --- | --- |
| `docker exec test wget -qO- -T 3 http://backend/api` | HTTP-Abruf aus einem laufenden Container |
| `docker run --rm --network hello_backend-net busybox:1.37 wget -qO- -T 3 http://backend/api` | HTTP-Abruf aus einem Wegwerf-Container im Netzwerk |
| `docker compose exec frontend wget -qO- -T 3 http://backend/api` | HTTP-Abruf aus einem Compose-Dienst |
| `docker compose exec frontend env` | Umgebungsvariablen im Container, z. B. `BACKEND_URL` |
| `docker exec test cat /etc/resolv.conf` | DNS-Server im Container (`127.0.0.11`) |

| `wget`-Meldung | Bedeutung |
| --- | --- |
| `bad address 'backend'` | Name unbekannt: kein gemeinsames Netzwerk, Ziel beendet, Tippfehler |
| `can't connect to remote host: Connection refused` | Name bekannt, auf dem Port lauscht nichts |
| `download timed out` | keine Antwort innerhalb von `-T` Sekunden |

## Netzwerke in Compose

```yaml
services:
  backend:
    networks: [backend-net]              # kein ports: -> nur intern erreichbar
  frontend:
    ports: ["8080:80"]                   # einziger Weg von außen
    networks: [frontend-net, backend-net]

networks:                                # Compose legt hello_frontend-net und hello_backend-net an
  frontend-net:
  backend-net:
```

Ohne `networks:` hängen alle Dienste in `<projekt>_default`.

## Fehlersuche

| Schritt | Befehl | Zeigt |
| --- | --- | --- |
| 1 | `docker compose ps -a` | auch beendete Container mit Exit-Code |
| 2 | `docker compose logs frontend` | letzte Ausgaben, auch nach dem Absturz |
| 3 | `docker inspect -f '{{.State.ExitCode}} {{.State.OOMKilled}}' <container>` | Exit-Code und ob die Speichergrenze zuschlug |
| 4 | `docker compose exec frontend sh` | Shell im laufenden Container (Alpine: `sh`, nicht `bash`) |
| – | `docker run --rm <image> ls /app` | Dateien im Image, wenn der Container nicht startet |
| – | `docker compose up -d --build` | nach Korrektur am Dockerfile neu bauen und starten |

| Exit-Code | Bedeutung |
| --- | --- |
| `0` | regulär beendet |
| `1` | Fehler im Programm |
| `2` | falscher Aufruf, z. B. Startdatei fehlt |
| `127` | Befehl nicht gefunden |
| `137` | hart beendet: Speichergrenze (`OOMKilled: true`) oder `docker kill` |

## Ressourcengrenzen

| Befehl / Angabe | Wirkung |
| --- | --- |
| `docker run --memory 128m --cpus 0.5 …` | höchstens 128 MB Speicher und ein halber CPU-Kern |
| `docker stats` | Liveanzeige CPU, Speicher mit Grenze (`Strg+C` beendet) |
| `docker stats --no-stream` | einmal messen |
| `docker stats --no-stream --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}'` | nur ausgewählte Spalten |

```yaml
    deploy:
      resources:
        limits:
          memory: 128M                   # darüber: Exited (137)
          cpus: "0.5"                    # darüber: gebremst
```

## Docker Swarm (Demo Lab 4.4)

| Befehl | Wirkung |
| --- | --- |
| `docker swarm init` | Rechner wird Manager eines Swarm mit einem Node |
| `docker node ls` | Nodes mit Rolle |
| `docker stack deploy -c stack.yml hello` | Compose-Datei als Stack `hello` starten oder aktualisieren |
| `docker stack services hello` | Services des Stacks mit Replikas |
| `docker service ls` | alle Services |
| `docker service ps hello_frontend` | Tasks eines Services mit Zustand und Verlauf |
| `docker service scale hello_frontend=5` | gewünschte Anzahl Tasks ändern |
| `docker service update --image hello-frontend:v2 hello_frontend` | Rolling Update |
| `docker service rollback hello_frontend` | vorige Service-Definition wiederherstellen |
| `docker stack rm hello` | Stack mit allen Services entfernen |
| `docker swarm leave --force` | Swarm-Modus beenden |

## Treiber

| Treiber | Einsatz |
| --- | --- |
| `bridge` | Container auf einem Host, Standard |
| `host` | kein eigenes Netz, direkt am Host |
| `none` | kein Netzwerk |
| `overlay` | über mehrere Hosts (Swarm) |
