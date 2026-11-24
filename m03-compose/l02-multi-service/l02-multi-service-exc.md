# Lab 3.2 – Übung: Healthcheck, Watch und Replikas

**Dauer:** ca. 20 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — `playground/compose.yml` bekommt Healthcheck, Watch und drei Frontends; Lab 3.3 startet mit einem eigenen Starter wieder mit einem Frontend.

## Vorbereitung

- Stand aus Lab 3.1: `playground/.env` mit `FRONTEND_PORT=8080` und `APP_COLOR=lightyellow`; keine Hello-Container laufen (`docker compose down` im Ordner `playground`). Fehlt `.env`, im Ordner `project/`: `cp examples/m03-compose/l01-compose-basics/.env playground/`
- `playground/frontend/Dockerfile` aus Lab 2.2 ist vorhanden (`ls playground/frontend`). Fehlt es, im Ordner `project/`: `cp examples/m02-images/l02-dockerfile/frontend/Dockerfile playground/frontend/`
- Starter kopieren (im Ordner `project/`): `cp starters/m03-l02-compose.yml playground/compose.yml`
- Arbeitsdateien: `playground/compose.yml` und `playground/frontend/app.py` (nur in Aufgabe 2, danach wieder im Ausgangszustand). Befehle im Ordner `project/playground`; zwei Terminalfenster sind praktisch (eines für `watch`).

## Aufgaben

1. Ersetze in `compose.yml` die beiden `TODO`-Zeilen für den Healthcheck des Backends und die Bedingung `service_healthy` beim Frontend. Starte mit `docker compose up -d` und lies die Startmeldungen. Rufe `docker compose ps` im zweiten Terminal einmal auf, solange `up -d` noch wartet, und einmal danach.
2. Ersetze das letzte `TODO` durch `develop.watch` mit `rebuild` für `./frontend/app.py` und starte im zweiten Terminal `docker compose watch`. Ändere in `frontend/app.py` die Zeile `<h1>Hello-App {APP_VERSION}</h1>` in `<h1>Hallo Docker {APP_VERSION}</h1>`, speichere, warte auf die Meldungen im Watch-Terminal und lade `http://localhost:8080` neu.
3. Mache die Änderung in `frontend/app.py` rückgängig, warte auf den nächsten Neubau, prüfe die Seite und beende Watch mit `Strg+C`.
4. Ändere beim Frontend den Port in `"80"` und ergänze `deploy:` mit `replicas: 3`. Führe `docker compose up -d` aus, zeige die Container mit `docker compose ps` und hole mit `docker compose port --index 1 frontend 80` und `--index 2` zwei Ports. Öffne beide Adressen im Browser und vergleiche die Frontend-Zeile.
5. Entferne alles mit `docker compose down`.

## Checkpoint

- Aufgabe 1: `up -d` meldet beim Backend `Waiting` und `Healthy`, erst danach `Started` beim Frontend; `ps` zeigt erst `(health: starting)` und nur das Backend, später `(healthy)` und beide Dienste.
- Aufgabe 2: Das Watch-Terminal meldet `Rebuilding service(s) ["frontend"]` und `Recreated`; die Seite zeigt „Hallo Docker v1".
- Aufgabe 3: Die Seite zeigt wieder „Hello-App v1".
- Aufgabe 4: `ps` listet `hello-frontend-1` bis `hello-frontend-3` mit verschiedenen Rechner-Ports und `hello-backend-1 … (healthy)`; beide Seiten zeigen verschiedene Container-IDs und IPs.

## Abschlusskriterien

- `playground/compose.yml` startet das Frontend erst nach einem `healthy` Backend, baut bei Änderungen an `app.py` selbst neu und startet drei Frontends ohne Port-Konflikt.
- `playground/frontend/app.py` ist wieder im Ausgangszustand; am Ende läuft kein Hello-Container.

## Fallback

- Watch startet nicht: Änderung speichern und `docker compose up -d --build` von Hand ausführen; die Wirkung ist dieselbe.
- Backend wird `unhealthy`: Prüfbefehl mit `docker inspect --format '{{json .State.Health}}' hello-backend-1` lesen und mit der Theorie vergleichen.
- Datei kaputt: fertigen Stand kopieren (im Ordner `project/`): `cp examples/m03-compose/l02-multi-service/compose.yml playground/`
