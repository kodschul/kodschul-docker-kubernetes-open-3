# Lab 3.3 – Übung: Volumes und Persistenz

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — `playground/compose.yml` läuft ab jetzt mit einem Frontend auf Port 8080 und dem Volume `hello-data`; Modul 4 baut darauf auf.

## Vorbereitung

- Keine Hello-Container laufen (`docker compose down` im Ordner `playground`); `playground/.env` aus Lab 3.1 ist vorhanden.
- Starter kopieren (im Ordner `project/`): `cp starters/m03-l03-compose.yml playground/compose.yml`
  Der Starter ist der Stand aus Lab 3.2 ohne Watch und Replikas: ein Frontend aus `hello-frontend:v1` auf Port 8080, Backend mit Healthcheck.
- Arbeitsdatei: `playground/compose.yml`. Befehle im Ordner `project/playground`.

## Aufgaben

1. Starte die Hello-App ohne Änderung mit `docker compose up -d`, lade `http://localhost:8080` dreimal und zähle die Zeilen mit `docker compose exec frontend wc -l /data/access.log`. Führe `docker compose down` und `docker compose up -d` aus, lade die Seite einmal und zähle erneut.
2. Ersetze die beiden `TODO`-Zeilen in `compose.yml`: Named Volume `hello-data` beim Frontend unter `/data` einbinden und auf oberster Ebene anlegen. Wiederhole danach Aufgabe 1 (`down`, `up -d`, dreimal laden, zählen, `down`, `up -d`, einmal laden, zählen).
3. Zeige das Volume mit `docker volume ls` und `docker volume inspect hello_hello-data` an. Öffne in Docker Desktop die Ansicht **Volumes**, wähle `hello_hello-data` und öffne im Reiter **Stored data** die Datei `access.log`.
4. Entferne die Anwendung mit `docker compose down -v`, prüfe mit `docker volume ls` und starte danach wieder mit `docker compose up -d`.

## Checkpoint

- Aufgabe 1: Erst `3 /data/access.log`, nach `down`/`up` nur `1 /data/access.log`.
- Aufgabe 2: Erst `3 /data/access.log`, nach `down`/`up` `4 /data/access.log`; `up -d` meldet `Volume hello_hello-data Created`.
- Aufgabe 3: `inspect` zeigt `"Name": "hello_hello-data"` und `"com.docker.compose.project": "hello"`; Docker Desktop zeigt `access.log` mit vier Zeilen.
- Aufgabe 4: `down -v` meldet `Volume hello_hello-data Removed`; `docker volume ls` listet es nicht mehr; nach `up -d` gibt es ein neues, leeres Volume.

## Abschlusskriterien

- `access.log` übersteht mit Volume ein `down`/`up`, ohne Volume nicht.
- `playground/compose.yml` enthält `hello-data:/data` beim Frontend und `hello-data:` unter `volumes:`; die Hello-App läuft am Ende auf Port 8080.

## Fallback

- `wc` meldet `No such file or directory`: Seite seit dem Start noch nicht geladen; einmal laden und wiederholen.
- Docker Desktop nicht verfügbar (z. B. Docker Engine unter Linux): Inhalt mit `docker compose exec frontend cat /data/access.log` ansehen.
- Datei kaputt: fertigen Stand kopieren (im Ordner `project/`): `cp examples/m03-compose/l03-volumes/compose.yml playground/`
