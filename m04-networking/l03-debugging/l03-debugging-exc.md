# Lab 4.3 – Übung: Fehlersuche und Ressourcengrenzen

**Dauer:** ca. 13 Minuten (einzeln oder zu zweit)
**Ändert die Hello-App-Projektbasis?** Ja — `playground/compose.yml` bekommt Speicher- und CPU-Grenzen (Endstand von Tag 1). Die Fehlerbilder sind eigene Kopien in `playground/debugging/` mit eigenen Ports (8091–8093).

## Vorbereitung

- Die Hello-App läuft im Stand von Lab 4.2; sie darf weiterlaufen.
- `playground/frontend/` enthält `app.py` und `requirements.txt` (Fehlerbild 1 baut daraus ein Image).
- Fehlerbilder kopieren (im Ordner `project/`): `cp -r variants/m04-l03-debugging playground/debugging`
- Arbeitsordner: `playground/debugging/fehler1-cmd`, `fehler2-netzwerk`, `fehler3-speicher`. Jeder Ordner enthält eine `README.md` mit Startbefehl, erwartetem und beobachtetem Ergebnis; die Ursache steht nicht darin.
- Ziel je Fehlerbild: Die Seite zeigt „Hello-App v1" mit einer Backend-Antwort.

## Aufgaben

1. Wechsle nach `playground/debugging/fehler1-cmd`, starte laut `README.md` und öffne `http://localhost:8091`. Finde die Ursache mit `docker compose ps -a` und `docker compose logs`, behebe sie in einer Datei dieses Ordners und starte mit `docker compose up -d --build` erneut.
2. Wechsle nach `fehler2-netzwerk`, starte und öffne `http://localhost:8092`. Prüfe aus dem Frontend-Container heraus, ob das Backend erreichbar ist, und zeige mit `docker network inspect`, wer in welchem Netzwerk hängt. Behebe den Fehler in `compose.yml` und starte erneut.
3. Wechsle nach `fehler3-speicher`, starte und öffne `http://localhost:8093`. Finde heraus, warum das Backend nicht läuft, belege die Ursache mit `docker inspect` und behebe sie in `compose.yml`. Prüfe nach dem Neustart den Verbrauch mit `docker stats --no-stream`.
4. Kopiere den Starter (im Ordner `project/`): `cp starters/m04-l03-compose.yml playground/compose.yml`. Ersetze die beiden `TODO`-Zeilen durch Grenzen von `128M` Speicher und `"0.5"` CPU für Backend und Frontend, führe im Ordner `playground` `docker compose up -d` aus und prüfe mit `docker stats --no-stream`.
5. Räume auf: Führe in allen drei Fehlerbild-Ordnern `docker compose down` aus und prüfe mit `docker ps -a`, dass keine Container mit `fehler` im Namen übrig sind.

## Checkpoint

- Aufgabe 1: Vor der Korrektur `Exited (2)` beim Frontend; danach `Up` und die Seite auf Port 8091.
- Aufgabe 2: Vor der Korrektur meldet `wget` im Frontend `bad address 'backend'`; danach zeigt die Seite auf Port 8092 eine Backend-Antwort.
- Aufgabe 3: Vor der Korrektur `Exited (137)` beim Backend und `oom=true` bzw. `"OOMKilled": true`; danach `Up` und in `docker stats` eine Grenze über dem Verbrauch.
- Aufgabe 4: `docker stats` zeigt für `hello-frontend-1` und `hello-backend-1` je `… / 128MiB`; die Hello-Seite auf Port 8080 funktioniert.

## Abschlusskriterien

- Alle drei Seiten (8091–8093) zeigten eine Backend-Antwort; für jedes Fehlerbild sind Ursache und der Befehl bekannt, der sie gezeigt hat.
- `playground/compose.yml` enthält `deploy.resources.limits` für beide Dienste; die Hello-App läuft damit.

## Fallback

- Port 8091–8093 belegt: Port in der jeweiligen `compose.yml` ändern (z. B. `"8094:80"`).
- Ein Fehlerbild ist nach mehreren Versuchen durcheinander: Ordner löschen und aus `variants/m04-l03-debugging/` neu kopieren.
- Fehlerbild 1 baut nicht (`failed to read dockerfile`): Befehl nicht im Ordner `playground/debugging/fehler1-cmd` gestartet oder Ordner umbenannt; der Pfad zum Dockerfile ist relativ dazu.
- Grenzen-Datei kaputt: fertigen Stand kopieren (im Ordner `project/`): `cp examples/m04-networking/l03-debugging/compose.yml playground/`
