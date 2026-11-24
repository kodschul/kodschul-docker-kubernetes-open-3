# Dockerfile-Cheatsheet (Modul 2)

Dockerfile-Anweisungen, Build-, Image-, Registry- und Scan-Befehle aus Modul 2. Container-Befehle aus Modul 1: [Docker-CLI-Cheatsheet](../m01-containers/docker-cli-cheatsheet.md). Alle Befehle für `bash`; Platzhalter in spitzen Klammern ersetzen.

## Dockerfile-Anweisungen

| Anweisung | Wirkung |
| --- | --- |
| `FROM python:3.14-alpine` | Basisimage festlegen; erste Anweisung, fester Tag statt `latest` |
| `WORKDIR /app` | Arbeitsordner für folgende Anweisungen und den Container; legt ihn bei Bedarf an |
| `COPY requirements.txt .` | Datei aus dem Build-Kontext ins Arbeitsverzeichnis kopieren |
| `RUN pip install --no-cache-dir -r requirements.txt` | Befehl beim Bauen ausführen; Ergebnis wird eine Schicht |
| `ARG APP_VERSION=v1` | Build-Argument mit Standardwert; existiert nur beim Bauen |
| `ENV APP_VERSION=${APP_VERSION}` | Umgebungsvariable ins Image schreiben; gilt im Container, mit `-e` überschreibbar |
| `EXPOSE 80` | dokumentiert den Port der Anwendung; veröffentlicht ihn nicht |
| `USER 10001` | folgende Schritte und den Container als dieser Benutzer ausführen (Standard: root) |
| `CMD ["python", "app.py"]` | Standardbefehl beim Start; ein Befehl bei `docker run` ersetzt ihn |
| `ENTRYPOINT ["python"]` | festes Startprogramm; Argumente bei `docker run` werden angehängt |
| `# Kommentar` | Kommentarzeile |

## Reihenfolge für guten Cache

| Regel | Beispiel |
| --- | --- |
| Seltenes oben, Häufiges unten | `COPY requirements.txt .` → `RUN pip install …` → `COPY app.py .` |
| keinen Zwischenspeicher ins Image | `pip install --no-cache-dir`, `apk add --no-cache` |
| ab dem ersten geänderten Schritt baut Docker alles darunter neu | Änderung an `app.py` baut nur `COPY app.py .` neu |

## .dockerignore

| Eintrag | Wirkung |
| --- | --- |
| `__pycache__/`, `*.pyc` | Python-Caches nicht in den Build-Kontext übernehmen |
| `.venv/` | lokale virtuelle Umgebung ausschließen |
| `.env` | Geheimnisse ausschließen |
| `Dockerfile`, `.dockerignore` | Bauanleitung selbst nicht ins Image kopieren |

## Images bauen und starten

| Befehl | Wirkung |
| --- | --- |
| `docker build -t <name>:<tag> .` | Image aus dem `Dockerfile` im aktuellen Ordner bauen |
| `docker build -t hello-frontend:v2 --build-arg APP_VERSION=v2 --build-arg APP_COLOR=lightgreen .` | Werte für `ARG` übergeben |
| `docker build -f <pfad>/Dockerfile -t <name>:<tag> <kontext>` | Dockerfile an einem anderen Ort verwenden |
| `docker build --pull -t <name>:<tag> .` | Basisimage neu laden (Sicherheitsupdates übernehmen) |
| `bash build-images.sh` | im Ordner `project/`: alle drei Hello-Images neu bauen |
| `docker run -d --name hello-frontend -p 8080:80 hello-frontend:v2` | Hello-Frontend im Hintergrund auf Port 8080 |
| `docker run -d -p 8080:80 -e APP_COLOR=orange hello-frontend:v1` | Umgebungsvariable beim Start überschreiben |
| `docker run --rm hello-frontend:v2 env` | `CMD` ersetzen: Umgebungsvariablen des Images anzeigen |

## Images und Schichten anzeigen

| Befehl | Wirkung |
| --- | --- |
| `docker images` | lokale Images mit `DISK USAGE` und `CONTENT SIZE` |
| `docker images --filter "reference=hello-*"` | nur Images, deren Name passt |
| `docker history <image>` | Bauschritte und Größe jeder Schicht |
| `docker history --no-trunc <image>` | Bauschritte ungekürzt |
| `docker rmi <image>` | Image-Namen entfernen; der letzte Name löscht das Image |

## Registry und Tags

| Befehl | Wirkung |
| --- | --- |
| `docker run -d --name registry -p 5001:5000 registry:3` | lokale Registry auf Port 5001 starten |
| `docker tag <image> 127.0.0.1:5001/<name>:<tag>` | zweiten Namen mit Registry-Adresse vergeben |
| `docker push 127.0.0.1:5001/<name>:<tag>` | Image in die Registry hochladen |
| `docker pull 127.0.0.1:5001/<name>:<tag>` | Image aus der Registry laden |
| `http://localhost:5001/v2/_catalog` | Liste der Repositories (Browser) |
| `http://localhost:5001/v2/<name>/tags/list` | Tags eines Repositories (Browser) |
| `docker login --username <docker-id>` | bei Docker Hub anmelden; Zugangstoken statt Passwort |
| `docker push <docker-id>/<name>:<tag>` | Image nach Docker Hub hochladen |

| Tag-Regel | Beispiel |
| --- | --- |
| Name = Registry/Repository:Tag | `127.0.0.1:5001/hello-frontend:v1`; ohne Registry gilt `docker.io` |
| semantische Version `MAJOR.MINOR.PATCH` | Fehlerkorrektur `1.0.1`, neue Funktion `1.1.0`, Bruch `2.0.0` |
| fester Tag statt `latest`, vergebene Version nie überschreiben | `nginx:1.29-alpine` statt `nginx` |
| Digest für unveränderliche Auswahl | `nginx:1.29-alpine@sha256:…` |

## Images scannen

| Befehl | Wirkung |
| --- | --- |
| `docker scout quickview <image>` | Kurzfassung der Lücken je Schweregrad (Docker-Konto nötig) |
| `docker scout cves --only-severity critical,high <image>` | kritische und hohe Lücken je Paket |
| `docker scout recommendations <image>` | Vorschläge für ein besseres Basisimage |
| `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v trivy-cache:/root/.cache/ aquasec/trivy:0.76.2 image -q <image>` | Scan mit Trivy, ohne Konto |
