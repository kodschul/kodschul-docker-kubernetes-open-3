# Lab 2.2 – Starter: Dockerfile für das Hello-Frontend
# Kopieren nach playground/frontend/Dockerfile, dann die "# TODO:"-Zeilen ersetzen.

FROM python:3.14-alpine

# TODO: Build-Argumente APP_VERSION (Standard v1) und APP_COLOR (Standard lightblue) anlegen (ARG)

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# TODO: Umgebungsvariablen aus den Build-Argumenten setzen (ENV):
#       APP_VERSION=${APP_VERSION}, APP_COLOR=${APP_COLOR}, PORT=80

EXPOSE 80

CMD ["python", "app.py"]
