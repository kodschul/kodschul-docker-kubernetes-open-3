# Lab 5.2 – Lösung: Lokales Cluster und kubectl

Versionen, IPs, Alter und Pod-Endungen weichen im eigenen Cluster ab.

## Aufgabe 1: Versionen

```bash
kubectl version
```

```text
Client Version: v1.37.x
Kustomize Version: v5.x.x
Server Version: v1.37.x
```

Die genaue Version legt Docker Desktop fest (1.36 oder 1.37). Erscheint nur `Client Version` und danach `Unable to connect to the server`, läuft das Cluster noch nicht.

## Aufgabe 2: Node anzeigen

```bash
kubectl get nodes
kubectl get nodes -o wide
```

```text
NAME             STATUS   ROLES           AGE   VERSION
docker-desktop   Ready    control-plane   14h   v1.37.x

NAME             STATUS   ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION     CONTAINER-RUNTIME
docker-desktop   Ready    control-plane   14h   v1.37.x   192.168.65.3   <none>        Docker Desktop   6.x.x-linuxkit     docker://29.x.x
```

- `ROLES control-plane`: Der eine Node trägt die Steuerzentrale und führt zugleich die Container aus.
- `CONTAINER-RUNTIME docker://…`: Im Kubeadm-Cluster von Docker Desktop startet die Docker Engine die Container. Deshalb sind die Hello-Images aus Tag 1 ohne Registry im Cluster nutzbar. In Cloud-Clustern steht hier meist `containerd://2.x`.

## Aufgabe 3: Kontexte

```bash
kubectl config get-contexts
```

```text
CURRENT   NAME             CLUSTER          AUTHINFO         NAMESPACE
*         docker-desktop   docker-desktop   docker-desktop
```

Gibt es weitere Kontexte (z. B. aus der Firma), stehen sie darunter ohne `*`. Die Spalte `NAMESPACE` ist noch leer; Lab 5.3 füllt sie.

## Aufgabe 4: Systemkomponenten

```bash
kubectl get pods -n kube-system
```

```text
NAME                                     READY   STATUS    RESTARTS   AGE
coredns-7db6d8ff4d-k2m9x                 1/1     Running   0          14h
coredns-7db6d8ff4d-wq5hl                 1/1     Running   0          14h
etcd-docker-desktop                      1/1     Running   0          14h
kube-apiserver-docker-desktop            1/1     Running   0          14h
kube-controller-manager-docker-desktop   1/1     Running   0          14h
kube-proxy-7xq2d                         1/1     Running   0          14h
kube-scheduler-docker-desktop            1/1     Running   0          14h
storage-provisioner                      1/1     Running   0          14h
vpnkit-controller                        1/1     Running   0          14h
```

| Pod | Komponente aus Lab 5.1 |
| --- | --- |
| `kube-apiserver-docker-desktop` | API-Server (Control Plane) |
| `etcd-docker-desktop` | etcd (Control Plane) |
| `kube-scheduler-docker-desktop` | Scheduler (Control Plane) |
| `kube-controller-manager-docker-desktop` | Controller-Manager (Control Plane) |
| `kube-proxy-7xq2d` | kube-proxy (Node) |
| `coredns-…` | Namensauflösung, Zusatzdienst |
| `storage-provisioner`, `vpnkit-controller` | Hilfsdienste von Docker Desktop |

Die Control-Plane-Pods tragen den Node-Namen im Namen. Kubelet und Container-Runtime fehlen, weil sie als Programme direkt auf dem Node laufen.

## Aufgabe 5: kubeconfig

```bash
kubectl config view --minify
```

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://kubernetes.docker.internal:6443
  name: docker-desktop
contexts:
- context:
    cluster: docker-desktop
    user: docker-desktop
  name: docker-desktop
current-context: docker-desktop
kind: Config
users:
- name: docker-desktop
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
```

Der API-Server liegt unter `https://kubernetes.docker.internal:6443`; Docker Desktop lässt diesen Namen auf den eigenen Rechner zeigen. `--minify` zeigt nur den aktuellen Kontext, `DATA+OMITTED` blendet die Zertifikate aus. In `~/.kube/config` selbst stehen die echten Schlüssel; deshalb gehört die Datei in kein Repository und in keine E-Mail.
