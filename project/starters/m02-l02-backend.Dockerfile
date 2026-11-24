# Lab 2.2 – Starter: Dockerfile für das Hello-Backend
# Kopieren nach playground/backend/Dockerfile, dann die "# TODO:"-Zeilen ersetzen.

# TODO: Basisimage python:3.14-alpine festlegen (FROM)

WORKDIR /app

# TODO: requirements.txt kopieren (COPY) und mit pip installieren (RUN)

# TODO: app.py kopieren (COPY)

ENV APP_VERSION=v1 \
    PORT=80

EXPOSE 80

# TODO: Startbefehl "python app.py" in JSON-Schreibweise festlegen (CMD)
