# Docker-CLI-Cheatsheet (Modul 1)

Alle Befehle für `bash` (Windows: Git Bash). Platzhalter in spitzen Klammern ersetzen.

## Installation prüfen

| Befehl | Wirkung |
| --- | --- |
| `docker run hello-world` | Testcontainer starten; gibt `Hello from Docker!` aus |
| `docker version` | Versionen von Client und Server (Docker Engine) |
| `docker --help` / `docker <befehl> --help` | alle Befehle bzw. Optionen eines Befehls |

## Images

| Befehl | Wirkung |
| --- | --- |
| `docker pull nginx:1.29-alpine` | Image aus der Registry laden, ohne Container zu starten |
| `docker images` | lokale Images mit Tag und Größe |

## Container starten

| Befehl | Wirkung |
| --- | --- |
| `docker run <image>` | Container erstellen und starten; lädt das Image bei Bedarf |
| `docker run -d --name webserver -p 8080:80 nginx:1.29-alpine` | im Hintergrund (`-d`), mit Namen, Port 8080 des Rechners auf Port 80 im Container |
| `docker run -it --rm alpine:3.22 sh` | interaktive Shell; `exit` beendet den Container, `--rm` löscht ihn |
| `docker run -d -p 8080:80 -v ./site:/usr/share/nginx/html nginx:1.29-alpine` | Ordner `site` des Rechners im Container einbinden (Bind Mount) |

## Container anzeigen und steuern

| Befehl | Wirkung |
| --- | --- |
| `docker ps` | laufende Container |
| `docker ps -a` | alle Container, auch beendete (mit Exit-Code) |
| `docker stop <name>` | sauber beenden (`SIGTERM`, nach 10 s `SIGKILL`), Exit-Code meist 0 |
| `docker kill <name>` | sofort beenden (`SIGKILL`), Exit-Code 137 |
| `docker start <name>` | beendeten Container mit allen Einstellungen wieder starten |
| `docker rm <name>` | beendeten Container löschen (Image bleibt) |
| `docker rm -f <name>` | auch laufenden Container stoppen und löschen |

## In Container hineinschauen

| Befehl | Wirkung |
| --- | --- |
| `docker logs <name>` | bisherige Ausgaben des Hauptprozesses |
| `docker logs --tail 3 <name>` | nur die letzten 3 Zeilen |
| `docker logs -f <name>` | live mitlesen (`Strg+C` beendet nur das Mitlesen) |
| `docker exec <name> ls /usr/share/nginx/html` | einen Befehl im laufenden Container ausführen |
| `docker exec -it <name> sh` | interaktive Shell im laufenden Container |
| `docker inspect <name>` | alle Einstellungen als JSON |
| `docker inspect --format '{{.State.Status}}' <name>` | ein einzelnes Feld ausgeben |
| `docker inspect --format '{{json .Mounts}}' <name>` | eingebundene Ordner anzeigen |

## Dateien

| Befehl | Wirkung |
| --- | --- |
| `docker cp <name>:/pfad/datei .` | Datei aus dem Container in den aktuellen Ordner kopieren |
| `docker cp datei <name>:/pfad/` | Datei vom Rechner in den Container kopieren |
| `-v <ordner-auf-dem-rechner>:<pfad-im-container>` | Option für `docker run`: Ordner einbinden; relative Pfade mit `./` |

## Windows mit Git Bash

| Befehl | Wirkung |
| --- | --- |
| `export MSYS_NO_PATHCONV=1` | Umwandlung von Linux-Pfaden wie `/usr/share/…` abschalten |
| `winpty docker run -it …` | interaktive Befehle im Git-Bash-Fenster; im VS-Code-Terminal nicht nötig |
