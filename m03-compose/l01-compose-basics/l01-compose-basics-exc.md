# Lab 3.1 – Übung: Compose-Grundlagen

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — `playground/compose.yml` und `playground/.env` entstehen; Lab 3.2 baut darauf auf.

## Vorbereitung

- Docker Desktop läuft; Terminal mit `bash` ([Setup](../../00-setup-and-installation.md#kurs-shell-bash)).
- Die Images aus Lab 2.2 sind vorhanden: `docker images "hello-*"` listet `hello-backend:v1`, `hello-frontend:v1` und `hello-frontend:v2`. Fehlen sie, im Ordner `project/` ausführen: `bash build-images.sh`.
- Ports 8080 und 8081 sind frei: `docker ps` zeigt keine Container aus Lab 2.2 mehr, sonst `docker rm -f <name>`.
- Starter kopieren (im Ordner `project/`): `cp starters/m03-l01-compose.yml playground/compose.yml`
- Arbeitsdateien: `playground/compose.yml` und `playground/.env` (entsteht in Aufgabe 3). Alle `docker compose`-Befehle laufen im Ordner `project/playground`.

## Aufgaben

1. Ersetze in `playground/compose.yml` die drei `TODO`-Zeilen beim Dienst `frontend`: Image `hello-frontend:v1`, Port `8080:80`, Umgebungsvariable `BACKEND_URL` mit dem Wert `http://backend`.
2. Starte die Anwendung mit `docker compose up -d`, zeige die Container mit `docker compose ps` an und öffne `http://localhost:8080` sowie `http://localhost:8081/api`. Lies danach die Ausgaben mit `docker compose logs backend`.
3. Lege `playground/.env` mit den Zeilen `FRONTEND_PORT=8080` und `APP_COLOR=lightyellow` an. Ersetze in `compose.yml` den festen Rechner-Port des Frontends durch `${FRONTEND_PORT}` und ergänze unter `environment` die Variable `APP_COLOR` mit dem Wert `${APP_COLOR}`. Prüfe mit `docker compose config` und übernimm die Änderung mit `docker compose up -d`.
4. Ändere in `.env` den Port auf `8090` und die Farbe auf `orange`, führe `docker compose up -d` aus und öffne `http://localhost:8090`. Setze danach `FRONTEND_PORT=8080` und `APP_COLOR=lightyellow` zurück und führe `docker compose up -d` erneut aus.
5. Entferne alles mit `docker compose down` und prüfe mit `docker compose ps` und `docker images "hello-*"`, was übrig bleibt.

## Checkpoint

- Aufgabe 2: `ps` zeigt `hello-backend-1` und `hello-frontend-1` mit `Up`; die Hello-Seite zeigt unter **Backend** eine Container-ID, eine IP und eine Uhrzeit; `/api` liefert JSON mit `pod`, `ip`, `time` und `version`.
- Aufgabe 3: `config` zeigt `published: "8080"` und `APP_COLOR: lightyellow`; die Seite ist hellgelb.
- Aufgabe 4: Die orange Seite ist nur auf Port 8090 erreichbar; `up -d` erstellt nur `hello-frontend-1` neu, das Backend läuft weiter.
- Aufgabe 5: `ps` ist leer, die drei `hello-*`-Images sind noch da.

## Abschlusskriterien

- `playground/compose.yml` startet Frontend und Backend mit einem Befehl, die Seite zeigt eine Backend-Antwort.
- `playground/.env` enthält `FRONTEND_PORT=8080` und `APP_COLOR=lightyellow`; `docker compose config` zeigt beide Werte eingesetzt.

## Fallback

- Port 8080, 8081 oder 8090 belegt: anderen freien Port in `.env` bzw. `compose.yml` eintragen.
- Datei kaputt: fertigen Stand kopieren (im Ordner `project/`): `cp examples/m03-compose/l01-compose-basics/compose.yml examples/m03-compose/l01-compose-basics/.env playground/`
