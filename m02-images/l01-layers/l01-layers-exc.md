# Lab 2.1 – Übung: Images und Layer

**Dauer:** ca. 8 Minuten
**Ändert die Hello-App-Projektbasis?** Nein — die Übung lädt nur Basisimages, die Lab 2.2 braucht.

## Vorbereitung

- Docker Desktop läuft, Terminal mit `bash` ist offen.
- Starter und Arbeitsdatei: keine, alle Schritte sind Befehle.

## Aufgaben

1. Lade die Basisimages `ubuntu:24.04`, `alpine:3.22` und `python:3.14-alpine` mit `docker pull`.
2. Vergleiche ihre Größen mit `docker images --filter reference=ubuntu:24.04 --filter reference=alpine:3.22 --filter reference=python:3.14-alpine` (Spalten `DISK USAGE` und `CONTENT SIZE`).
3. Lies mit `docker history python:3.14-alpine` die Bauschritte des Python-Images. Suche die unterste Schicht (Basis), die größte Schicht und einen Schritt mit `0B`.

## Checkpoint

- Aufgabe 1: Jeder Pull endet mit `Status: Downloaded newer image for …` oder, wenn die Images vorab geladen wurden, mit `Image is up to date for …`.
- Aufgabe 2: Die Liste zeigt drei Zeilen; `alpine:3.22` ist das kleinste Image, `ubuntu:24.04` das größte.
- Aufgabe 3: Die unterste Zeile beginnt mit `ADD alpine-minirootfs-…`, die größte Schicht ist ein `RUN … apk add …` mit über 40 MB.

## Abschlusskriterien

- Die Größen der drei Basisimages sind verglichen.
- Basis, größte Schicht und ein Schritt ohne Dateiänderung sind in `docker history` gefunden.

## Fallback

- `toomanyrequests` beim Pull: `docker login` ausführen und Befehl wiederholen.
- Kein Netz: Werte aus den Screenshots der Theorie lesen.
