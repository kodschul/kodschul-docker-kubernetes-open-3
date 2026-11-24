# Lab 1.1 – Übung: Warum Container?

**Dauer:** ca. 5 Minuten
**Ändert die Hello-App-Projektbasis?** Nein — die Übung prüft nur die Docker-Installation.

## Vorbereitung

- Docker Desktop ist installiert ([Setup](../../00-setup-and-installation.md)).
- Ein Terminal mit `bash` ist offen (macOS/Linux: Terminal, Windows: Git Bash).
- Starter und Arbeitsdatei: keine, alle Schritte sind Befehle.

## Aufgaben

1. Starte Docker Desktop und warte, bis die Statusleiste unten links `Engine running` zeigt.
2. Starte im Terminal den ersten Container mit `docker run hello-world`.
3. Führe `docker run hello-world` ein zweites Mal aus und vergleiche die ersten Zeilen mit dem ersten Lauf.
4. Zeige mit `docker version` Client und Server an und lies bei beiden `Version` und `OS/Arch` ab.

## Checkpoint

- Die Ausgabe enthält `Hello from Docker!` und `This message shows that your installation appears to be working correctly.`
- Beim ersten Lauf stehen davor `Unable to find image 'hello-world:latest' locally` und `Pull complete`; beim zweiten Lauf fehlen diese Zeilen.
- `docker version` zeigt zwei Abschnitte: `Client` mit dem eigenen Betriebssystem (`darwin`, `windows` oder `linux`) und `Server` mit `linux`.

## Abschlusskriterien

- `docker run hello-world` läuft ohne Fehlermeldung.
- Client- und Server-Version sind abgelesen.

## Fallback

- `Cannot connect to the Docker daemon`: Docker Desktop läuft noch nicht; Statusleiste abwarten und Befehl wiederholen.
- `toomanyrequests` beim Download: `docker login` ausführen und Befehl wiederholen.
- Ohne funktionierende Installation: Ausgabe im Screenshot der Theorie lesen; Installation in der Pause mit dem [Setup](../../00-setup-and-installation.md) nachholen.
