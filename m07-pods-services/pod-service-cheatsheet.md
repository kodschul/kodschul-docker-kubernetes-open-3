# Pods und Services – Cheatsheet (Modul 7)

Alle Befehle in der Kurs-Shell (bash) im Ordner `project/`, Namespace `hello` als Standard im Kontext (Lab 5.3).

## Pods anlegen und ansehen

| Befehl | Wirkung |
| --- | --- |
| `kubectl apply -f playground/k8s/10-backend-pod.yaml` | Pod aus Datei anlegen |
| `kubectl get pods` | Pods mit `READY`, `STATUS`, `RESTARTS`, Alter |
| `kubectl get pods -o wide` | zusätzlich Pod-IP und Node |
| `kubectl describe pod frontend` | Details: Labels, Image, `env`, Events |
| `kubectl logs backend` | Ausgabe des Containers (`-f` live, Ende mit Strg+C) |
| `kubectl exec frontend -- env` | Befehl im Container ausführen |
| `kubectl delete pod backend` | Pod löschen; er kommt nicht von selbst zurück |
| `kubectl delete pods --all` | alle Pods im Namespace `hello` löschen |

## Pod-Manifest: wichtige Felder

| Feld | Beispiel |
| --- | --- |
| `metadata.labels` | `app: hello-frontend`, `tier: frontend`, `version: v1` |
| `spec.containers[].image` | `hello-frontend:v1` |
| `spec.containers[].imagePullPolicy` | `Never` (nur lokales Image), `IfNotPresent`, `Always` |
| `spec.containers[].ports[].containerPort` | `80` |
| `spec.containers[].env` | `- name: BACKEND_URL` / `value: "http://backend"` |

`env` eines laufenden Pods ist unveränderlich: Pod löschen, Datei ändern, neu anwenden.

## Labels und Selektoren

| Befehl | Wirkung |
| --- | --- |
| `kubectl get pods --show-labels` | alle Labels in einer Spalte |
| `kubectl get pods -L app,version` | je Label eine Spalte |
| `kubectl get pods -l app=hello-backend` | nur passende Pods |
| `kubectl get pods -l tier=frontend,version=v1` | beide Bedingungen (UND) |
| `kubectl get pods -l tier!=frontend` | alle ohne dieses Label |

## Port-Forward

| Befehl | Wirkung |
| --- | --- |
| `kubectl port-forward pod/frontend 8080:80` | `localhost:8080` → Pod-Port 80; Ende mit Strg+C oder wenn der Pod verschwindet |
| `kubectl port-forward service/frontend 8080:80` | über den Service, landet trotzdem bei genau einem Pod |

## Services

| Befehl | Wirkung |
| --- | --- |
| `kubectl apply -f playground/k8s/20-backend-service.yaml` | Service anlegen oder ändern |
| `kubectl get services` (`kubectl get svc`) | Services mit Typ, ClusterIP, `EXTERNAL-IP`, Ports |
| `kubectl describe service backend` | Selector, Ports, Endpoints, Events |
| `kubectl get endpointslices -l kubernetes.io/service-name=backend` | Pod-IPs hinter dem Service; `<unset>` = kein Pod passt |
| `kubectl delete service frontend` | Service löschen (Pods bleiben) |

| Service-Feld | Bedeutung |
| --- | --- |
| `spec.type` | `ClusterIP` (Standard), `NodePort`, `LoadBalancer` |
| `spec.selector` | Labels der Pods, z. B. `app: hello-backend` |
| `ports[].port` | Port des Service (`http://backend:80`) |
| `ports[].targetPort` | Port im Container |
| `ports[].nodePort` | fester Port 30000–32767 auf jedem Node (nur `NodePort`/`LoadBalancer`) |

## DNS im Cluster

| Befehl / Name | Wirkung |
| --- | --- |
| `kubectl exec frontend -- nslookup backend` | Service-Namen auflösen |
| `kubectl exec frontend -- wget -qO- http://backend/api` | Service aus dem Frontend-Container aufrufen |
| `backend` | Name im selben Namespace |
| `backend.hello` | Name aus anderen Namespaces |
| `backend.hello.svc.cluster.local` | vollständiger Name (FQDN) |

## Zugriff von außen (Docker Desktop)

| Adresse | Weg |
| --- | --- |
| `http://localhost:8080` | solange `kubectl port-forward pod/frontend 8080:80` läuft |
| `http://localhost:30080` | Service `frontend` mit `type: NodePort`, `nodePort: 30080` (prüfen) |
| `http://localhost:<port>` | Service mit `type: LoadBalancer`, `EXTERNAL-IP localhost` |
| `http://hello.localhost`, `/api` | Ingress `hello` mit Traefik (Lab 7.4, Demo) |

## Ingress mit Traefik (Lab 7.4)

| Befehl | Wirkung |
| --- | --- |
| `helm repo add traefik https://traefik.github.io/charts` | Repository von Traefik eintragen |
| `helm install traefik traefik/traefik --version 42.4.2 -n traefik --create-namespace` | Traefik als Ingress-Controller (Service `LoadBalancer`, Port 80/443) |
| `kubectl apply -f examples/m07-pods-services/l04-ingress/50-ingress.yaml` | Ingress `hello` anlegen |
| `kubectl get ingress` | Ingress mit Klasse, Hosts, Adresse |
| `kubectl get ingressclass` | verfügbare Ingress-Controller |
| `helm uninstall traefik -n traefik` | Traefik entfernen |

## Projektstand

| Befehl | Stand nach |
| --- | --- |
| `kubectl apply -f examples/m07-pods-services/l01-pods/` | Lab 7.1 (Backend-IP im Frontend ist ein Beispielwert) |
| `kubectl delete pods --all` und `kubectl apply -f examples/m07-pods-services/l02-clusterip/` | Lab 7.2 |
| `kubectl delete pods --all` und `kubectl apply -f examples/m07-pods-services/l03-nodeport/` | Lab 7.3 |
