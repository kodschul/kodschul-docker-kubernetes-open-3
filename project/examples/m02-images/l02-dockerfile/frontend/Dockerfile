# Basisimage: Python 3.14 auf Alpine Linux (klein, aktuell unterstützt)
FROM python:3.14-alpine

# Build-Argumente: nur beim Bauen gültig, mit Standardwert
#   docker build --build-arg APP_VERSION=v2 --build-arg APP_COLOR=lightgreen ...
ARG APP_VERSION=v1
ARG APP_COLOR=lightblue

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Build-Argumente als Umgebungsvariablen ins Image übernehmen;
# beim Start weiter überschreibbar (docker run -e, Compose, Kubernetes)
ENV APP_VERSION=${APP_VERSION} \
    APP_COLOR=${APP_COLOR} \
    PORT=80

EXPOSE 80

CMD ["python", "app.py"]
