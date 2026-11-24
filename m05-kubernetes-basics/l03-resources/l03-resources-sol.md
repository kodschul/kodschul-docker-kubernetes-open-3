# Lab 5.3 – Lösung: Ressourcen und Manifeste

Alle Befehle laufen im Ordner `project/`. Zeitstempel, IDs und Alter weichen im eigenen Cluster ab.

## Aufgabe 1: Ressourcentypen lesen

```bash
kubectl api-resources
```

```text
NAME          SHORTNAMES   APIVERSION   NAMESPACED   KIND
…
namespaces    ns           v1           false        Namespace
nodes         no           v1           false        Node
…
pods          po           v1           true         Pod
…
services      svc          v1           true         Service
…
```

| Typ | Kurzname | `APIVERSION` | gehört zu Namespace |
| --- | --- | --- | --- |
| `namespaces` | `ns` | `v1` | nein (`false`), Namespaces gelten clusterweit |
| `pods` | `po` | `v1` | ja (`true`) |
| `services` | `svc` | `v1` | ja (`true`) |

Ohne Filter listet der Befehl rund 60 Typen; mit `kubectl api-resources | grep -E "^(namespaces|pods|services) "` nur diese drei.

```bash
kubectl explain namespace
```

```text
KIND:       Namespace
VERSION:    v1

DESCRIPTION:
    Namespace provides a scope for Names. Use of multiple namespaces is
    optional.

FIELDS:
  apiVersion	<string>
  …
  kind	<string>
  …
  metadata	<ObjectMeta>
  …
  spec	<NamespaceSpec>
  …
  status	<NamespaceStatus>
  …
```

Die Felder auf oberster Ebene sind dieselben wie in jedem Manifest: `apiVersion`, `kind`, `metadata`, `spec`, `status`.

## Aufgabe 2: Manifest per Dry-Run erzeugen

```bash
mkdir -p playground/k8s
kubectl create namespace hello --dry-run=client -o yaml > playground/k8s/00-namespace.yaml
```

Inhalt vor dem Aufräumen:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: hello
spec: {}
status: {}
```

Je nach `kubectl`-Version steht unter `metadata` zusätzlich `creationTimestamp: null`; die Zeile darf gelöscht werden. Nach dem Aufräumen:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: hello
```

`--dry-run=client` hat nichts im Cluster angelegt; `kubectl get namespace hello` meldet an dieser Stelle noch `NotFound`. Der Inhalt entspricht [`examples/m05-kubernetes-basics/l03-resources/00-namespace.yaml`](../../project/examples/m05-kubernetes-basics/l03-resources/00-namespace.yaml).

## Aufgabe 3: Anwenden, zweimal

```bash
kubectl apply -f playground/k8s/00-namespace.yaml
kubectl get namespaces
kubectl apply -f playground/k8s/00-namespace.yaml
```

```text
namespace/hello created
NAME              STATUS   AGE
default           Active   14h
hello             Active   3s
kube-node-lease   Active   14h
kube-public       Active   14h
kube-system       Active   14h
namespace/hello unchanged
```

Das zweite `apply` meldet `unchanged`: Der gewünschte Zustand ist bereits erreicht. `kubectl create namespace hello` würde an dieser Stelle mit `AlreadyExists` abbrechen.

## Aufgabe 4: Standard-Namespace setzen

```bash
kubectl config set-context --current --namespace=hello
kubectl config get-contexts
kubectl get pods
```

```text
Context "docker-desktop" modified.
CURRENT   NAME             CLUSTER          AUTHINFO         NAMESPACE
*         docker-desktop   docker-desktop   docker-desktop   hello
No resources found in hello namespace.
```

Die Einstellung steht in `~/.kube/config` und bleibt nach einem Neustart erhalten.

## Aufgabe 5: Gespeichertes Objekt lesen

```bash
kubectl get namespace hello -o yaml
```

```yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: "2026-11-24T09:41:07Z"
  labels:
    kubernetes.io/metadata.name: hello
  name: hello
  resourceVersion: "4711"
  uid: 6f1c2a7e-…
spec:
  finalizers:
  - kubernetes
status:
  phase: Active
```

- `spec.finalizers` hat Kubernetes ergänzt: Beim Löschen wird erst der Inhalt des Namespace entfernt.
- `status.phase: Active` ist der tatsächliche Zustand, geschrieben von Kubernetes; in der eigenen Datei steht kein `status`.
- `creationTimestamp`, `labels`, `resourceVersion` und `uid` sind beim Speichern dazugekommen.
