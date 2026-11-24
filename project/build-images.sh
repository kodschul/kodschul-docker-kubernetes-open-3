#!/usr/bin/env bash
# Baut die drei Hello-Images aus den Beispielständen von Lab 2.2 neu.
# Nutzen: wenn Images fehlen (neuer Rechner, "Reset Kubernetes Cluster", docker system prune).
# Aufruf aus dem Ordner project/:  bash build-images.sh
set -euo pipefail
cd "$(dirname "$0")"

APP=playground                          # Quellcode der App (app.py, requirements.txt)
DF=examples/m02-images/l02-dockerfile   # Dockerfiles aus Lab 2.2

docker build -t hello-backend:v1  -f $DF/backend/Dockerfile  $APP/backend
docker build -t hello-frontend:v1 -f $DF/frontend/Dockerfile $APP/frontend
docker build -t hello-frontend:v2 -f $DF/frontend/Dockerfile \
  --build-arg APP_VERSION=v2 --build-arg APP_COLOR=lightgreen $APP/frontend

docker images --filter "reference=hello-*"
