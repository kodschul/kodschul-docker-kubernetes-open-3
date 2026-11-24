# Lab 4.2 – Übung: Netzwerke in Compose

**Dauer:** ca. 12 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — `playground/compose.yml` bekommt die Netzwerke `frontend-net` und `backend-net`, das Backend verliert seinen Port; Lab 4.3 baut darauf auf.

## Vorbereitung

- Die Hello-App läuft im Stand von Lab 3.3 (`docker compose up -d` im Ordner `playground`); Container aus Lab 4.1 sind entfernt.
- Starter kopieren (im Ordner `project/`): `cp starters/m04-l02-compose.yml playground/compose.yml`
  Der Starter ist der Stand aus Lab 3.3 mit `TODO`-Zeilen für die Netzwerke.
- Arbeitsdatei: `playground/compose.yml`. Befehle im Ordner `project/playground`.

## Aufgaben

1. Ersetze die `TODO`-Zeilen in `compose.yml`: Port-Freigabe des Backends entfernen, Backend nur in `backend-net`, Frontend in `frontend-net` und `backend-net`, beide Netzwerke auf oberster Ebene anlegen. Übernimm die Änderung mit `docker compose up -d`.
2. Öffne `http://localhost:8080` und danach `http://localhost:8081/api`.
3. Zeige die Netzwerke mit `docker network ls --filter name=hello` an und prüfe für `hello_frontend-net` und `hello_backend-net` mit `docker network inspect <netzwerk> --format '{{range .Containers}}{{println .Name .IPv4Address}}{{end}}'`, welche Container darin hängen.
4. Prüfe mit einem Testcontainer, wer das Backend erreicht: `docker run --rm --network hello_frontend-net busybox:1.37 wget -qO- -T 3 http://backend/api` und derselbe Befehl mit `hello_backend-net`.

## Checkpoint

- Aufgabe 1: `up -d` meldet `Network hello_frontend-net Created`, `Network hello_backend-net Created` und erstellt beide Container neu.
- Aufgabe 2: Die Hello-Seite zeigt eine Backend-Antwort; `http://localhost:8081/api` ist nicht erreichbar.
- Aufgabe 3: In `hello_frontend-net` hängt nur `hello-frontend-1`, in `hello_backend-net` hängen `hello-frontend-1` und `hello-backend-1`.
- Aufgabe 4: Aus `hello_frontend-net` meldet `wget` `bad address 'backend'`, aus `hello_backend-net` kommt JSON.

## Abschlusskriterien

- Das Backend ist von außen nicht erreichbar, die Hello-Seite funktioniert.
- `playground/compose.yml` enthält `networks:` beim Backend, beim Frontend und auf oberster Ebene; die Hello-App läuft weiter (Grundlage für Lab 4.3).

## Fallback

- Datei kaputt: fertigen Stand kopieren (im Ordner `project/`): `cp examples/m04-networking/l02-compose-networks/compose.yml playground/`
- `toomanyrequests` beim Laden von `busybox:1.37`: `docker login` ([Setup](../../00-setup-and-installation.md#docker-hub-limit-und-docker-login)) oder `hello-backend:v1` als Testimage: `docker run --rm --network hello_backend-net hello-backend:v1 wget -qO- -T 3 http://backend/api`.
