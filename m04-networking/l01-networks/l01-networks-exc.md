# Lab 4.1 – Übung: Docker-Netzwerke

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Nein — die Hello-App läuft mit den Images aus Lab 2.2 einmal ohne Compose; `playground/compose.yml` bleibt unverändert. Die Befehlsfolge liegt als `examples/m04-networking/l01-networks/hello-net.sh` bei.

## Vorbereitung

- Compose-Fassung stoppen (Port 8080 wird frei): im Ordner `project/playground` `docker compose down`.
- Keine Reste aus einem früheren Versuch: `docker rm -f frontend backend test` und `docker network rm hello-net` (Meldungen „No such …" sind in Ordnung).
- Terminal mit `bash`, beliebiger Ordner. Windows (Git Bash): `MSYS_NO_PATHCONV=1` ist gesetzt ([Setup](../../00-setup-and-installation.md#kurs-shell-bash)).

## Aufgaben

1. Zeige alle Netzwerke mit `docker network ls` an. Lege das Netzwerk `hello-net` mit `docker network create hello-net` an und prüfe mit `docker network inspect hello-net`, dass noch kein Container darin ist.
2. Starte das Backend `backend` mit `hello-backend:v1` im Netzwerk `hello-net` ohne Port und das Frontend `frontend` mit `hello-frontend:v1` im selben Netzwerk mit `-p 8080:80` und `-e BACKEND_URL=http://backend`. Öffne `http://localhost:8080` und danach `http://localhost:8081/api`.
3. Starte einen dritten Container ohne Netzwerkangabe: `docker run -d --name test busybox:1.37 sleep 3600`. Rufe aus ihm heraus das Backend per Namen auf: `docker exec test wget -qO- -T 3 http://backend/api`.
4. Hänge `test` mit `docker network connect hello-net test` in das Netzwerk und wiederhole den Aufruf aus Aufgabe 3. Zeige danach mit `docker network inspect hello-net --format '{{range .Containers}}{{println .Name .IPv4Address}}{{end}}'` alle Container im Netzwerk an.
5. Räume auf: `docker rm -f frontend backend test` und `docker network rm hello-net`; starte danach im Ordner `playground` die Compose-Fassung wieder mit `docker compose up -d`.

## Checkpoint

- Aufgabe 1: `inspect` zeigt `"Driver": "bridge"`, ein Subnetz unter `IPAM` und `"Containers": {}`.
- Aufgabe 2: Die Hello-Seite zeigt eine Backend-Antwort; `http://localhost:8081/api` ist nicht erreichbar.
- Aufgabe 3: `wget: bad address 'backend'`.
- Aufgabe 4: Der Aufruf liefert JSON mit `pod`, `ip`, `time` und `version`; `inspect` listet `frontend`, `backend` und `test` mit IPs aus demselben Subnetz.
- Aufgabe 5: `docker network ls` listet `hello-net` nicht mehr; die Hello-App läuft wieder über Compose auf Port 8080.

## Abschlusskriterien

- Die Hello-App lief ohne Compose mit einer Backend-Antwort; nur das Frontend war von außen erreichbar.
- Beobachtet: Der Name `backend` funktioniert nur für Container im Netzwerk `hello-net`.

## Fallback

- `toomanyrequests` beim Laden von `busybox:1.37`: `docker login` ([Setup](../../00-setup-and-installation.md#docker-hub-limit-und-docker-login)) oder für Aufgabe 3 ein vorhandenes Image nutzen: `docker run -d --name test hello-backend:v1` (bringt `wget` mit).
- Befehle aus Aufgabe 2 vertippt: `bash examples/m04-networking/l01-networks/hello-net.sh` im Ordner `project/` startet Netzwerk, Backend und Frontend; `bash examples/m04-networking/l01-networks/hello-net.sh down` räumt auf.
