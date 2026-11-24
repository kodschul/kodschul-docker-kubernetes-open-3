# FAQ

## Braucht es Docker, wenn Kubernetes genutzt wird?

- Zum Bauen der Images ja (oder ein anderes OCI-Werkzeug wie Podman).
- Im Cluster selbst läuft meist containerd, nicht Docker.

## Docker Compose, Swarm oder Kubernetes?

- Compose: ein Rechner, Entwicklung und kleine Installationen.
- Swarm: einfache Orchestrierung, wenig Aufwand.
- Kubernetes: Standard für viele Server, Teams und Cloud.

## Warum sieht das Frontend sein Backend nicht?

- Im Container zeigt `localhost` auf den Container selbst.
- Compose/Kubernetes: Backend über den Namen `backend` erreichen.
- Details: [Lab 3.1](../m03-compose/l01-compose-basics/l01-compose-basics-thx.md), [Lab 7.2](../m07-pods-services/l02-clusterip/l02-clusterip-thx.md)

## Wo sind meine Daten nach `docker compose down` oder Pod-Löschung?

- Ohne Volume: weg.
- Mit Named Volume bzw. PVC: bleiben erhalten.
- Details: [Lab 3.3](../m03-compose/l03-volumes/l03-volumes-thx.md), [Lab 9.3](../m09-config-storage/l03-volumes/l03-volumes-thx.md)

## Pod hängt in `ErrImageNeverPull` – was tun?

- Image fehlt lokal: `bash build-images.sh` im Ordner `project/`.
- Cluster-Typ in Docker Desktop muss **Kubeadm** sein.

## Ist ein Secret verschlüsselt?

- Nein, nur Base64-kodiert.
- Schutz über Zugriffsrechte und Verschlüsselung in etcd.

## Warum wird der HPA nicht kleiner?

- Abbau wartet standardmäßig etwa 5 Minuten.
- Ohne metrics-server zeigt der HPA `<unknown>`.

## Das Kubernetes Dashboard ist archiviert – trotzdem nutzen?

- Für das Übungscluster ja; Nachfolger ist Headlamp.
- Admin-Token nie in echten Clustern verwenden.

## Ingress oder Gateway API?

- Ingress ist stabil, aber eingefroren; ingress-nginx ist eingestellt.
- Neue Projekte: Gateway API.

## Wie geht es nach dem Kurs weiter?

- Gateway API, RBAC, Pod Security, Monitoring.
- Zertifizierungen CKAD und CKA.
