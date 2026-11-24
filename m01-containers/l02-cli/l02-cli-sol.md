# Lab 1.2 – Lösung: Container über die CLI steuern

## Aufgabe 1: Image laden und Shell im Container

```bash
docker pull nginx:1.29-alpine
docker images
docker run -it --rm alpine:3.22 sh
```

```text
1.29-alpine: Pulling from library/nginx
…
Status: Downloaded newer image for nginx:1.29-alpine
docker.io/library/nginx:1.29-alpine
```

```text
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.22          49340b346798       13.4MB         4.22MB
hello-world:latest   1e4c05b897a7       22.6kB         10.3kB
nginx:1.29-alpine    5616878291a2       92.7MB         26.7MB
…
```

Wurden die Kurs-Images vorab mit `pull-images.sh` geladen, meldet `pull` stattdessen `Image is up to date for nginx:1.29-alpine`. Die Liste kann weitere Images enthalten; IDs und Größen weichen je nach Rechner ab.

```text
/ # cat /etc/os-release
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.22.8
PRETTY_NAME="Alpine Linux v3.22"
…
/ # exit
```

`-it` verbindet Tastatur und Terminal mit der Shell `sh`; `exit` beendet den Hauptprozess und damit den Container, `--rm` löscht ihn danach.

## Aufgabe 2: Webserver starten

```bash
docker run -d --name webserver -p 8080:80 nginx:1.29-alpine
docker ps
```

```text
548f52175c20253eb3f3aa5f780169e9f7d1982caeb693ae413ae477a609c7ab
```

```text
CONTAINER ID   IMAGE               COMMAND                  CREATED        STATUS                  PORTS                                     NAMES
548f52175c20   nginx:1.29-alpine   "/docker-entrypoint.…"   1 second ago   Up Less than a second   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   webserver
```

`-d` gibt nur die lange Container-ID aus; der Webserver läuft im Hintergrund weiter. Der Browser zeigt die nginx-Startseite „Welcome to nginx!".

## Aufgabe 3: Port-Konflikt

```bash
docker run -d --name webserver2 -p 8080:80 nginx:1.29-alpine
```

```text
5a477dd8eaaeaef38c33c216195585768d57dd2955fe68ad93577749c2fe8a9a
docker: Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint webserver2 (21b8c7fc…): Bind for 0.0.0.0:8080 failed: port is already allocated
```

Port 8080 des Rechners gehört schon `webserver`. Docker hat `webserver2` trotzdem angelegt (Status `Created`), deshalb ist der Name belegt und der Container muss vor dem neuen Versuch weg:

```bash
docker rm webserver2
docker run -d --name webserver2 -p 8081:80 nginx:1.29-alpine
```

Beide Container nutzen im Inneren Port 80; nur die Ports des Rechners müssen verschieden sein. `http://localhost:8081` zeigt dieselbe Startseite.

## Aufgabe 4: stop und kill

```bash
docker stop webserver2
docker kill webserver
docker ps
docker ps -a
```

```text
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS                                PORTS     NAMES
74d13fedcdaf   nginx:1.29-alpine   "/docker-entrypoint.…"   2 seconds ago   Exited (0) Less than a second ago               webserver2
548f52175c20   nginx:1.29-alpine   "/docker-entrypoint.…"   4 seconds ago   Exited (137) Less than a second ago             webserver
```

- `docker ps` zeigt nur die Kopfzeile: Kein Container läuft mehr.
- `webserver2` endet mit `Exited (0)`: `docker stop` schickt `SIGTERM`, nginx fährt sauber herunter.
- `webserver` endet mit `Exited (137)`: `docker kill` bricht mit `SIGKILL` sofort ab (128 + 9).
- Beendete Container behalten Namen und Inhalt, belegen aber keine Ports mehr.

## Aufgabe 5: Neu starten und aufräumen

```bash
docker start webserver
docker rm -f webserver webserver2
docker ps -a
```

```text
webserver
webserver
webserver2
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
…
```

`docker start` übernimmt die Einstellungen vom ersten `run` (Port 8080), die Seite lädt wieder. `rm -f` stoppt den laufenden `webserver` und löscht beide. Beendete `hello-world`-Container aus Lab 1.1 dürfen in der Liste stehen; das Image `nginx:1.29-alpine` bleibt erhalten.
