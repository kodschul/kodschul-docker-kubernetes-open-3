# Lab 2.2 – Übung: Eigene Images mit Dockerfile

**Dauer:** ca. 25 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — die Hello-App bekommt ihre Dockerfiles; die Images `hello-backend:v1`, `hello-frontend:v1` und `hello-frontend:v2` nutzen alle folgenden Labs, auch Tag 2.

## Vorbereitung

- Docker Desktop läuft, Terminal mit `bash` im Ordner `project/` der Kursdateien.
- Starter: `project/starters/m02-l02-backend.Dockerfile` und `project/starters/m02-l02-frontend.Dockerfile`. In den Arbeitsbereich kopieren:

  ```bash
  cp starters/m02-l02-backend.Dockerfile playground/backend/Dockerfile
  cp starters/m02-l02-frontend.Dockerfile playground/frontend/Dockerfile
  ```

- Arbeitsdateien: `playground/backend/Dockerfile` und `playground/frontend/Dockerfile`; jede `# TODO:`-Zeile wird durch die passende Anweisung ersetzt.
- Ports 8080 und 8081 sind frei (`docker ps`).

## Aufgaben

1. Ergänze `playground/backend/Dockerfile` nach den TODOs (Basisimage, `requirements.txt` kopieren und installieren, `app.py` kopieren, Startbefehl). Baue im Ordner `playground/backend` das Image `hello-backend:v1`.
2. Ergänze `playground/frontend/Dockerfile` nach den TODOs (zwei `ARG`, die `ENV`-Zeile). Baue im Ordner `playground/frontend` das Image `hello-frontend:v1` ohne Build-Argumente.
3. Baue im selben Ordner `hello-frontend:v2` mit `--build-arg APP_VERSION=v2 --build-arg APP_COLOR=lightgreen` und zeige alle drei Images mit `docker images --filter "reference=hello-*"` an.
4. Starte das Backend als Container `hello-backend` mit `-p 8081:80` und das Frontend `v2` als Container `hello-frontend` mit `-p 8080:80`, beide im Hintergrund. Öffne `http://localhost:8081` und `http://localhost:8080`.
5. Ersetze den Frontend-Container durch `hello-frontend:v1` mit `-e APP_COLOR=orange`, lade die Seite neu und räume danach beide Container mit `docker rm -f` auf.

## Checkpoint

- Aufgabe 1 und 2: Beide Builds enden mit `naming to docker.io/library/hello-…:v1 done`.
- Aufgabe 3: Der Build von `v2` meldet alle Schritte nach `FROM` als `CACHED`; die Liste zeigt `hello-backend:v1`, `hello-frontend:v1` und `hello-frontend:v2`.
- Aufgabe 4: `http://localhost:8081` zeigt JSON mit `"version":"v1"`; `http://localhost:8080` zeigt eine hellgrüne Seite „Hello-App v2" mit „Backend nicht erreichbar (http://localhost:8081): ConnectionError".
- Aufgabe 5: Die Seite zeigt „Hello-App v1" auf orangem Hintergrund; danach listet `docker ps` keinen `hello-`-Container mehr.

## Abschlusskriterien

- Drei Images `hello-*` existieren in `docker images`.
- Der Unterschied ist sichtbar: Version und Farbe kommen beim Bauen per `--build-arg` ins Image, `-e` ändert sie nur für einen Container.
- „Backend nicht erreichbar" ist erwartet; die Verbindung entsteht in Lab 3.1.

## Fallback

- Ein Dockerfile lässt sich nicht bauen: mit `project/examples/m02-images/l02-dockerfile/<dienst>/Dockerfile` vergleichen oder es von dort nach `playground/<dienst>/Dockerfile` kopieren.
- Images fehlen später (anderer Rechner, gelöschte Images): `bash build-images.sh` im Ordner `project/` baut alle drei Hello-Images aus den fertigen Dockerfiles.
- `toomanyrequests` beim Laden von `python:3.14-alpine`: `docker login` ausführen und Build wiederholen.
- Port 8080 belegt: alten Container mit `docker ps` suchen und mit `docker rm -f <name>` entfernen.
