#!/usr/bin/env bash
# Lab 2.3: lokale Registry starten, hello-frontend:v1 hineinschieben und von dort starten.
# Aufruf aus dem Ordner project/:   bash examples/m02-images/l03-registry/registry.sh
# Aufräumen danach:                  docker rm -f hello-registry registry
# Andere Ports, falls belegt:        REG_PORT=5002 WEB_PORT=8090 bash examples/m02-images/l03-registry/registry.sh
set -euo pipefail

REG_PORT="${REG_PORT:-5001}"                 # Port der Registry auf dem Rechner (im Container: 5000)
WEB_PORT="${WEB_PORT:-8080}"                 # Port der Hello-Seite auf dem Rechner
REG="127.0.0.1:${REG_PORT}"
IMAGE="${REG}/hello-frontend:v1"

# 1. Registry starten (alte Container gleichen Namens vorher entfernen)
docker rm -f registry hello-registry >/dev/null 2>&1 || true
docker run -d --name registry -p "${REG_PORT}:5000" registry:3
sleep 2                                      # Registry braucht einen Moment bis zur ersten Antwort

# 2. Zweiten Namen mit Registry-Adresse vergeben und hochladen
docker tag hello-frontend:v1 "${IMAGE}"
docker push "${IMAGE}"

# 3. Katalog und Tag-Liste abfragen
curl -s "http://localhost:${REG_PORT}/v2/_catalog"; echo
curl -s "http://localhost:${REG_PORT}/v2/hello-frontend/tags/list"; echo

# 4. Lokalen Namen entfernen und aus der Registry starten (docker run zieht das Image)
docker rmi "${IMAGE}"
docker run -d --name hello-registry -p "${WEB_PORT}:80" "${IMAGE}"
echo "Hello-Seite aus der Registry: http://localhost:${WEB_PORT}"
