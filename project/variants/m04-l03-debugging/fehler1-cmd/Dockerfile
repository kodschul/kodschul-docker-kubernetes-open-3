# Fehlerbild 1 (Lab 4.3): Dockerfile des Hello-Frontends
# Gebaut aus dem Quellcode in playground/frontend (siehe compose.yml)
FROM python:3.14-alpine

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENV APP_VERSION=v1 \
    APP_COLOR=lightblue \
    PORT=80

EXPOSE 80

CMD ["python", "main.py"]
