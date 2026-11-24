# Lab 1.3 – Lösung: In Container hineinschauen

## Aufgabe 1: Logs lesen

```bash
docker run -d --name webserver -p 8080:80 nginx:1.29-alpine
docker logs --tail 3 webserver
```

```text
192.168.65.1 - - [23/Nov/2026:23:10:59 +0000] "GET / HTTP/1.1" 200 896 "-" "Mozilla/5.0 …" "-"
192.168.65.1 - - [23/Nov/2026:23:10:59 +0000] "GET /nix HTTP/1.1" 404 153 "-" "Mozilla/5.0 …" "-"
2026/11/23 23:10:59 [error] 24#24: *2 open() "/usr/share/nginx/html/nix" failed (2: No such file or directory), client: 192.168.65.1, server: localhost, request: "GET /nix HTTP/1.1", host: "localhost:8080"
```

- `200`: Seite gefunden; `404`: Seite fehlt, nginx schreibt zusätzlich eine `[error]`-Zeile.
- `192.168.65.1` ist die Adresse, unter der der Rechner in der VM von Docker Desktop erscheint; sie kann abweichen. Ein zweiter Aufruf von `/` kann im Browser als `304` (aus dem Browser-Cache bestätigt) erscheinen.

## Aufgabe 2: Startseite im Container ändern

```bash
docker exec -it webserver sh
```

```text
/ # echo '<h1>Hallo aus dem Container</h1>' > /usr/share/nginx/html/index.html
/ # exit
```

<img src="../../assets/images/m01/nginx-exec-geaendert.png" alt="Browser zeigt die Überschrift Hallo aus dem Container" width="520">

_Quelle: eigener Screenshot, nginx:1.29-alpine nach `docker exec`, 24.11.2026._

nginx liefert die neue Datei sofort aus; ein Neustart ist für Inhalte nicht nötig. `exit` beendet nur die zusätzliche Shell, nginx läuft weiter.

## Aufgabe 3: Container ersetzen

```bash
docker rm -f webserver
docker run -d --name webserver -p 8080:80 nginx:1.29-alpine
```

Der Browser zeigt wieder „Welcome to nginx!". Die geänderte `index.html` lag in der Container-Schicht des alten Containers und ist mit `docker rm` gelöscht. Der neue Container beginnt beim unveränderten Image `nginx:1.29-alpine`.

## Aufgabe 4: Ordner vom Rechner einbinden

```bash
cd project/playground
mkdir -p site
echo '<h1>Seite vom eigenen Rechner</h1>' > site/index.html
docker rm -f webserver
docker run -d --name webserver -p 8080:80 -v ./site:/usr/share/nginx/html nginx:1.29-alpine
```

`site/index.html` nach der Änderung im Editor:

```html
<h1>Seite vom eigenen Rechner, Version 2</h1>
```

<img src="../../assets/images/m01/bind-mount-seite.png" alt="Browser zeigt die Überschrift Seite vom eigenen Rechner, Version 2" width="520">

_Quelle: eigener Screenshot, nginx:1.29-alpine mit Bind Mount, 24.11.2026._

- Der Ordner `site` überdeckt `/usr/share/nginx/html` im Container; nginx sieht nur noch die eigene `index.html`.
- Die Änderung im Editor ist ohne Neustart sichtbar, weil Container und Rechner dieselbe Datei lesen.
- Nach `docker rm -f webserver` bleibt `site/index.html` auf dem Rechner erhalten.

## Aufgabe 5: Mount prüfen und aufräumen

```bash
docker inspect --format '{{json .Mounts}}' webserver
docker rm -f webserver
```

```text
[{"Type":"bind","Source":"/Users/kurs/project/playground/site","Destination":"/usr/share/nginx/html","Mode":"","RW":true,"Propagation":"rprivate"}]
webserver
```

| Feld | Bedeutung |
| --- | --- |
| `Type` | `bind` = Ordner des Rechners |
| `Source` | vollständiger Pfad auf dem Rechner; Docker hat `./site` aufgelöst (Pfad je Rechner verschieden) |
| `Destination` | Mount-Pfad im Container |
| `RW` | `true` = der Container darf auch schreiben |
