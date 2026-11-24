# Lab 1.3 – Übung: In Container hineinschauen

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Nein — die Übung legt nur den Ordner `playground/site/` mit einer Testseite an.

## Vorbereitung

- Docker Desktop läuft, Terminal mit `bash` ist offen. Windows: `-it`-Befehle im Terminal von VS Code ausführen oder `winpty` voranstellen; vor Befehlen mit Linux-Pfaden `export MSYS_NO_PATHCONV=1`.
- Arbeitsordner: `project/playground/` der Kursdateien; Arbeitsdatei: `playground/site/index.html` (entsteht in Aufgabe 4).
- Port 8080 ist frei (`docker ps`); Container aus Lab 1.2 sind gelöscht.

## Aufgaben

1. Starte den Container `webserver` mit `docker run -d --name webserver -p 8080:80 nginx:1.29-alpine`, lade `http://localhost:8080` zweimal im Browser und rufe einmal `http://localhost:8080/nix` auf. Lies danach mit `docker logs --tail 3 webserver` die letzten Anfragen.
2. Öffne mit `docker exec -it webserver sh` eine Shell im Container und ersetze die Startseite mit `echo '<h1>Hallo aus dem Container</h1>' > /usr/share/nginx/html/index.html`. Verlasse die Shell mit `exit` und lade die Seite neu.
3. Lösche den Container mit `docker rm -f webserver`, starte ihn mit demselben Befehl wie in Aufgabe 1 neu und lade die Seite.
4. Wechsle nach `project/playground/` und lege die Testseite an: `mkdir -p site` und `echo '<h1>Seite vom eigenen Rechner</h1>' > site/index.html`. Lösche `webserver` und starte ihn neu mit dem zusätzlichen Bind Mount `-v ./site:/usr/share/nginx/html`. Ändere danach `site/index.html` im Editor (z. B. VS Code) in `<h1>Seite vom eigenen Rechner, Version 2</h1>`, speichere und lade die Seite neu.
5. Zeige mit `docker inspect --format '{{json .Mounts}}' webserver` den eingebundenen Ordner an und räume mit `docker rm -f webserver` auf.

## Checkpoint

- Aufgabe 1: `docker logs` zeigt Zeilen mit `"GET / HTTP/1.1" 200` und `"GET /nix HTTP/1.1" 404`.
- Aufgabe 2: Der Browser zeigt „Hallo aus dem Container".
- Aufgabe 3: Der Browser zeigt wieder „Welcome to nginx!"; die Änderung aus Aufgabe 2 ist weg.
- Aufgabe 4: Der Browser zeigt erst „Seite vom eigenen Rechner", nach dem Speichern „Seite vom eigenen Rechner, Version 2", ohne Neustart des Containers.
- Aufgabe 5: Die Ausgabe enthält `"Type":"bind"`, den vollständigen Pfad zu `playground/site` und `"Destination":"/usr/share/nginx/html"`.

## Abschlusskriterien

- Der Unterschied ist erlebt: Eine Änderung im Container verschwindet mit `docker rm`, eine Datei im eingebundenen Ordner bleibt auf dem Rechner und ist sofort im Container sichtbar.
- `docker ps -a` listet keinen Container `webserver` mehr; `playground/site/index.html` existiert.

## Fallback

- Browser zeigt `403 Forbidden` nach Aufgabe 4: Befehl nicht in `project/playground/` gestartet, `./site` ist dort leer; mit `pwd` und `ls site` prüfen.
- `-v ./site:…` wird nicht akzeptiert (ältere Docker-Version): absoluten Pfad nutzen, `-v "$(pwd)/site":/usr/share/nginx/html`.
- `the input device is not a TTY`: Aufgabe 2 ohne Shell in einem Schritt ausführen: `docker exec webserver sh -c "echo '<h1>Hallo aus dem Container</h1>' > /usr/share/nginx/html/index.html"`.
