#!/usr/bin/env bash
# Lädt alle Images, die der Kurs braucht, vorab auf den eigenen Rechner.
# Grund: Docker Hub erlaubt anonym 100 Downloads je 6 Stunden pro IP-Adresse;
# im Schulungsraum teilen sich alle eine Adresse. Vorher "docker login" ausführen hilft zusätzlich.
#
# Aufruf aus dem Ordner project/:
#   bash pull-images.sh          # Tag 1: Docker-Images
#   bash pull-images.sh k8s      # Ende Tag 1, nach dem Aktivieren von Kubernetes: Images der Helm-Charts
set -uo pipefail

DOCKER_IMAGES=(
  hello-world
  alpine:3.22
  ubuntu:24.04
  python:3.14-alpine
  python:3.9-alpine        # Vergleich beim Image-Scan (Lab 2.4)
  nginx:1.29-alpine
  busybox:1.37
  registry:3
)

for img in "${DOCKER_IMAGES[@]}"; do
  echo "==> $img"; docker pull -q "$img" || echo "   Fehler bei $img"
done

if [[ "${1:-}" == "k8s" ]]; then
  # Images aus den Helm-Charts von Tag 2 auslesen (helm template) und laden.
  # Docker Desktop (Cluster-Typ kubeadm) nutzt denselben Image-Speicher wie Docker.
  helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ >/dev/null 2>&1
  helm repo add kubernetes-dashboard https://kubernetes-retired.github.io/dashboard/ >/dev/null 2>&1
  helm repo update >/dev/null
  CHART_IMAGES=$( { helm template ms metrics-server/metrics-server; \
                    helm template kd kubernetes-dashboard/kubernetes-dashboard; } \
                  | grep -E '^\s*image:' | sed -E 's/.*image:\s*"?([^"]+)"?.*/\1/' | sort -u )
  for img in $CHART_IMAGES; do
    echo "==> $img"; docker pull -q "$img" || echo "   Fehler bei $img"
  done
fi

echo "Fertig."
