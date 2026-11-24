#!/usr/bin/env bash
# Lab 4.1 – Hello-App ohne Compose im eigenen Netzwerk hello-net (fertiger Stand als Befehlsfolge)
# Aufruf in einem beliebigen Ordner:  bash hello-net.sh        Aufräumen:  bash hello-net.sh down
# Vorher die Compose-Fassung stoppen (Port 8080): im Ordner playground  docker compose down
set -euo pipefail

if [[ "${1:-}" == "down" ]]; then
  docker rm -f frontend backend test 2>/dev/null || true
  docker network rm hello-net 2>/dev/null || true
  exit 0
fi

docker network create hello-net                                   # benutzerdefiniertes Bridge-Netzwerk

docker run -d --name backend --network hello-net hello-backend:v1  # kein -p: nur im Netzwerk erreichbar

docker run -d --name frontend --network hello-net -p 8080:80 \
  -e BACKEND_URL=http://backend \
  hello-frontend:v1                                                # einziger veröffentlichter Port

docker network inspect hello-net \
  --format '{{range .Containers}}{{.Name}} {{.IPv4Address}}{{"\n"}}{{end}}'
echo "Hello-App: http://localhost:8080"
