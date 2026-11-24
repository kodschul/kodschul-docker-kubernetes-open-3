# Lab 2.3 – Übung: Tags und Registry

**Dauer:** ca. 12 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — `hello-frontend:v1` aus Lab 2.2 liegt zusätzlich in der lokalen Registry; die lokalen Images `hello-*` bleiben unverändert.

## Vorbereitung

- Docker Desktop läuft, Terminal mit `bash` ist offen.
- `hello-frontend:v1` aus Lab 2.2 existiert (`docker images hello-frontend`); sonst im Ordner `project/` `bash build-images.sh`.
- Ports 5001 und 8080 sind frei (`docker ps`).
- Starter und Arbeitsdatei: keine, alle Schritte sind Befehle.

## Aufgaben

1. Starte die lokale Registry als Container `registry` aus `registry:3` mit Port 5001 des Rechners auf Port 5000 im Container.
2. Tagge `hello-frontend:v1` als `127.0.0.1:5001/hello-frontend:v1`, pushe es und vergleiche die IDs beider Namen in `docker images`.
3. Öffne im Browser `http://localhost:5001/v2/_catalog` und `http://localhost:5001/v2/hello-frontend/tags/list`.
4. Entferne den lokalen Namen mit `docker rmi 127.0.0.1:5001/hello-frontend:v1`. Starte danach den Container `hello-registry` mit `-p 8080:80` aus `127.0.0.1:5001/hello-frontend:v1` und öffne `http://localhost:8080`.
5. Räume auf: Entferne die Container `hello-registry` und `registry` mit `docker rm -f`.

## Checkpoint

- Aufgabe 2: `docker push` endet mit `v1: digest: sha256:… size: …`; `hello-frontend:v1` und `127.0.0.1:5001/hello-frontend:v1` haben dieselbe ID.
- Aufgabe 3: Der Katalog zeigt `{"repositories":["hello-frontend"]}`, die Tag-Liste `{"name":"hello-frontend","tags":["v1"]}`.
- Aufgabe 4: `docker run` meldet `Unable to find image '127.0.0.1:5001/hello-frontend:v1' locally` und `Pulling from hello-frontend`; der Browser zeigt die hellblaue Seite „Hello-App v1".
- Aufgabe 5: `docker ps -a` listet weder `registry` noch `hello-registry`; `hello-frontend:v1` ist weiter in `docker images`.

## Abschlusskriterien

- `hello-frontend:v1` lag in der eigenen Registry und ist von dort gestartet.
- Der vollständige Name `Registry/Repository:Tag` ist in Katalog, Tag-Liste und `docker images` wiedergefunden.

## Erweiterung

Lade das Image nach Docker Hub: Erzeuge auf `app.docker.com` ein Zugangstoken mit **Read & Write**, führe `docker login --username <docker-id>` aus (Token statt Passwort), tagge `hello-frontend:v1` als `<docker-id>/hello-frontend:1.0.0` und pushe es. Das Repository erscheint auf `hub.docker.com` unter dem eigenen Konto; es ist öffentlich, solange die Standard-Sichtbarkeit des Kontos nicht auf privat steht. Danach in den Repository-Einstellungen löschen oder auf privat stellen.

## Fallback

- Port 5001 belegt: anderen Port wählen (z. B. `-p 5002:5000`), dann überall `127.0.0.1:5002`.
- Alle Schritte in einem Durchlauf: `bash examples/m02-images/l03-registry/registry.sh` im Ordner `project/`.
- `toomanyrequests` beim Laden von `registry:3`: `docker login` ausführen und Befehl wiederholen.
