# kubectl – Cheatsheet (Modul 5)

Alle Befehle in der Kurs-Shell (bash), Dateipfade relativ zum Ordner `project/`.

## Cluster und Version

| Befehl | Wirkung |
| --- | --- |
| `kubectl version` | Version von `kubectl` (Client) und Cluster (Server) |
| `kubectl get nodes` | Nodes mit Status (`Ready`), Rolle und Version |
| `kubectl get nodes -o wide` | zusätzlich IP, Betriebssystem, Kernel, Container-Runtime |
| `kubectl get pods -n kube-system` | Systemkomponenten (API-Server, etcd, Scheduler, Controller-Manager, kube-proxy, CoreDNS) |

## kubeconfig und Kontext

| Befehl | Wirkung |
| --- | --- |
| `kubectl config get-contexts` | alle Kontexte; `*` = aktueller, Spalte `NAMESPACE` = Standard-Namespace |
| `kubectl config current-context` | Name des aktuellen Kontexts |
| `kubectl config use-context docker-desktop` | Kontext wechseln |
| `kubectl config view --minify` | kubeconfig des aktuellen Kontexts, Zertifikate ausgeblendet |
| `kubectl config set-context --current --namespace=hello` | Standard-Namespace im aktuellen Kontext setzen |
| `kubectl config view --minify \| grep namespace:` | gesetzten Standard-Namespace prüfen |

## Lokales Cluster (Docker Desktop)

| Aktion | Wirkung |
| --- | --- |
| **Kubernetes** > **Create cluster** > **Kubeadm** | Ein-Node-Cluster `docker-desktop` anlegen |
| **Kubernetes** > **Reset cluster** | Cluster leeren und neu erstellen; alle Objekte gehen verloren |

## Ressourcentypen

| Befehl | Wirkung |
| --- | --- |
| `kubectl api-resources` | alle Ressourcentypen mit Kurzname, API-Version, Namespace-Bezug, `KIND` |
| `kubectl explain namespace` | Doku eines Ressourcentyps |
| `kubectl explain namespace.status.phase` | Doku eines Felds, mit Punkten in die Tiefe |

| Typ | Kurzname | `apiVersion` | gehört zu Namespace |
| --- | --- | --- | --- |
| `namespaces` | `ns` | `v1` | nein |
| `nodes` | `no` | `v1` | nein |
| `pods` | `po` | `v1` | ja |
| `services` | `svc` | `v1` | ja |
| `deployments` | `deploy` | `apps/v1` | ja |

## Manifeste

| Befehl | Wirkung |
| --- | --- |
| `kubectl create namespace hello --dry-run=client -o yaml` | Manifest als Vorlage ausgeben, nichts anlegen |
| `kubectl create namespace hello --dry-run=client -o yaml > playground/k8s/00-namespace.yaml` | Vorlage als Datei speichern |
| `kubectl apply -f playground/k8s/00-namespace.yaml` | Datei anwenden: anlegen (`created`) oder angleichen (`configured`, `unchanged`) |
| `kubectl apply -f playground/k8s/` | alle Dateien eines Ordners anwenden, alphabetisch |
| `kubectl delete -f playground/k8s/00-namespace.yaml` | beschriebene Objekte löschen |
| `kubectl get namespace hello -o yaml` | gespeichertes Objekt mit `spec` und `status` |

## Namespaces

| Befehl | Wirkung |
| --- | --- |
| `kubectl get namespaces` (`kubectl get ns`) | alle Namespaces |
| `kubectl get pods -n kube-system` | Befehl in einem bestimmten Namespace |
| `kubectl get pods -A` | Befehl über alle Namespaces |
| `kubectl delete namespace <name>` | Namespace samt Inhalt löschen |

## Projektstand

| Befehl | Wirkung |
| --- | --- |
| `kubectl apply -f examples/m05-kubernetes-basics/l03-resources/` | Namespace `hello` anlegen (Stand nach Lab 5.3) |
| `kubectl config set-context --current --namespace=hello` | danach `hello` als Standard setzen |
