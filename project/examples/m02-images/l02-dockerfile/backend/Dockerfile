# Basisimage: Python 3.14 auf Alpine Linux (klein, aktuell unterstützt)
FROM python:3.14-alpine

# Arbeitsordner im Image; alle folgenden Pfade beziehen sich darauf
WORKDIR /app

# Erst nur die Abhängigkeiten kopieren und installieren: diese Schicht bleibt im Cache,
# solange sich requirements.txt nicht ändert
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Danach den Code kopieren (ändert sich oft)
COPY app.py .

# Standardwerte, beim Start überschreibbar (docker run -e, Compose, Kubernetes)
ENV APP_VERSION=v1 \
    PORT=80

# Dokumentiert den Port, auf dem die App lauscht
EXPOSE 80

# Startbefehl des Containers
CMD ["python", "app.py"]
