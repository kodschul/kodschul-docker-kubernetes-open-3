# Lab 2.1 – Lösung: Images und Layer

## Aufgabe 1: Basisimages laden

```bash
docker pull ubuntu:24.04
docker pull alpine:3.22
docker pull python:3.14-alpine
```

```text
3.14-alpine: Pulling from library/python
Digest: sha256:5862d971d1f0ae26b258cefa4e893556b1d3aba81bd2ff30888704ad378bab67
Status: Image is up to date for python:3.14-alpine
docker.io/library/python:3.14-alpine
```

Ohne Vorab-Download listet der Pull jede Schicht mit `Pull complete`; Schichten, die schon auf dem Rechner liegen, erscheinen als `Already exists`.

## Aufgabe 2: Größen vergleichen

```bash
docker images --filter reference=ubuntu:24.04 --filter reference=alpine:3.22 --filter reference=python:3.14-alpine
```

```text
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.22          49340b346798       13.4MB         4.22MB
python:3.14-alpine   5862d971d1f0       77.7MB         18.9MB
ubuntu:24.04         562111b88caa        141MB         30.9MB
```

| Image | `CONTENT SIZE` (Download) | Grund |
| --- | --- | --- |
| `alpine:3.22` | ca. 4 MB | nur Kernprogramme, Shell `sh`, Paketmanager `apk` |
| `python:3.14-alpine` | ca. 19 MB | Alpine plus Python |
| `ubuntu:24.04` | ca. 31 MB | vollständiges Ubuntu mit `bash` und `apt` |

Werte für einen Mac mit Apple-Chip (`linux/arm64`); auf Intel- und AMD-Rechnern (`linux/amd64`) weichen sie leicht ab. `DISK USAGE` ist größer, weil die Schichten entpackt auf der Festplatte liegen.

## Aufgabe 3: Bauschritte lesen

```bash
docker history python:3.14-alpine
```

```text
IMAGE          CREATED       CREATED BY                                      SIZE      COMMENT
5862d971d1f0   2 weeks ago   CMD ["python3"]                                 0B        buildkit.dockerfile.v0
<missing>      2 weeks ago   RUN /bin/sh -c set -eux;  for src in idle3 p…   16.4kB    buildkit.dockerfile.v0
<missing>      2 weeks ago   RUN /bin/sh -c set -eux;   apk add --no-cach…   46.6MB    buildkit.dockerfile.v0
<missing>      2 weeks ago   ENV PYTHON_SHA256=de414a57119abef52784d8993e…   0B        buildkit.dockerfile.v0
<missing>      2 weeks ago   ENV PYTHON_VERSION=3.14.10                      0B        buildkit.dockerfile.v0
<missing>      2 weeks ago   RUN /bin/sh -c set -eux;  apk add --no-cache…   2.91MB    buildkit.dockerfile.v0
<missing>      2 weeks ago   ENV LANG=C.UTF-8                                0B        buildkit.dockerfile.v0
<missing>      2 weeks ago   ENV PATH=/usr/local/bin:/usr/local/sbin:/usr…   0B        buildkit.dockerfile.v0
<missing>      2 weeks ago   CMD ["/bin/sh"]                                 0B        buildkit.dockerfile.v0
<missing>      2 weeks ago   ADD alpine-minirootfs-3.24.4-aarch64.tar.gz …   9.31MB    buildkit.dockerfile.v0
```

| Gesucht | Zeile | Bedeutung |
| --- | --- | --- |
| unterste Schicht (Basis) | `ADD alpine-minirootfs-3.24.4-aarch64.tar.gz …` (9.31MB) | das komplette Alpine-Dateisystem |
| größte Schicht | `RUN … apk add --no-cach…` (46.6MB) | Python wird gebaut und installiert |
| Schritt mit `0B` | z. B. `ENV PYTHON_VERSION=3.14.10` oder `CMD ["python3"]` | setzt nur eine Einstellung, keine Dateien |

- Die untersten zwei Zeilen stammen aus dem Bauplan von Alpine, alles darüber aus dem des Python-Images. `<missing>` heißt nur, dass diese Schritte anderswo gebaut wurden.
- `python:3.14-alpine` baut auf Alpine 3.24 auf, nicht auf `alpine:3.22` aus Aufgabe 1; deshalb teilen sich diese beiden Images keine Schicht. Images mit derselben Basis teilen sich ihre Schichten, z. B. die beiden Hello-Images aus Lab 2.2.
