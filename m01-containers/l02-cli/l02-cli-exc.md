# Lab 1.2 – Übung: Container über die CLI steuern

**Dauer:** ca. 20 Minuten
**Ändert die Hello-App-Projektbasis?** Nein — die Übung nutzt nginx- und Alpine-Container und räumt am Ende auf.

## Vorbereitung

- Docker Desktop läuft (`Engine running`), Terminal mit `bash` ist offen.
- Ports 8080 und 8081 sind frei: `docker ps` listet keinen Container mit diesen Ports.
- Starter und Arbeitsdatei: keine, alle Schritte sind Befehle.

## Aufgaben

1. Lade das Image `nginx:1.29-alpine` mit `docker pull` und prüfe es mit `docker images`. Starte danach mit `docker run -it --rm alpine:3.22 sh` eine Shell, zeige darin `cat /etc/os-release` an und verlasse sie mit `exit`.
2. Starte aus `nginx:1.29-alpine` im Hintergrund den Container `webserver` mit Port 8080 des Rechners auf Port 80 im Container. Öffne `http://localhost:8080` im Browser und zeige den Container mit `docker ps` an.
3. Starte einen zweiten nginx-Container `webserver2`, ebenfalls mit `-p 8080:80`. Lies die Fehlermeldung, lösche `webserver2` und starte ihn mit Port 8081 neu. Öffne `http://localhost:8081`.
4. Beende `webserver2` mit `docker stop` und `webserver` mit `docker kill`. Vergleiche die Ausgabe von `docker ps` und `docker ps -a`.
5. Starte `webserver` mit `docker start` wieder und lade `http://localhost:8080` neu. Lösche danach beide Container mit `docker rm -f` und prüfe mit `docker ps -a`, dass sie weg sind.

## Checkpoint

- Aufgabe 1: `docker images` listet `nginx:1.29-alpine`; die Shell zeigt `PRETTY_NAME="Alpine Linux v3.22"`; nach `exit` fehlt der Alpine-Container in `docker ps -a`.
- Aufgabe 2: Der Browser zeigt „Welcome to nginx!"; `docker ps` zeigt `webserver` mit `0.0.0.0:8080->80/tcp`.
- Aufgabe 3: Der erste Versuch meldet `port is already allocated`; danach laufen beide Container, auf 8080 und 8081.
- Aufgabe 4: `docker ps` ist leer; `docker ps -a` zeigt `webserver2` mit `Exited (0)` und `webserver` mit `Exited (137)`.
- Aufgabe 5: Die Seite unter 8080 lädt wieder; zum Schluss fehlen beide Container in `docker ps -a`.

## Abschlusskriterien

- Ein nginx-Container war im Browser erreichbar; beide Container sind gelöscht.
- Der Unterschied ist sichtbar: Zwei Container können nicht denselben Port des Rechners nutzen, `stop` und `kill` enden mit verschiedenen Exit-Codes.

## Fallback

- Port 8080 belegt (anderes Programm): einen freien Port wie 8090 wählen und im Browser entsprechend aufrufen.
- `the input device is not a TTY` (Git Bash): `winpty docker run -it --rm alpine:3.22 sh` oder das Terminal in VS Code nutzen.
- `toomanyrequests` beim Download: `docker login` ausführen und Befehl wiederholen.
