# Lab 8.1 – Lösung: ReplicaSets und Skalierung

Alle Befehle laufen im Ordner `project/`. Pod-Namen, IPs und Zeiten weichen im eigenen Cluster ab.

## Aufgabe 1: ReplicaSet statt Einzel-Pod

```bash
kubectl delete pod frontend
rm playground/k8s/*frontend-pod.yaml
cp starters/m08-l01-frontend-replicaset.yaml playground/k8s/30-frontend-replicaset.yaml
```

Ergänzte Zeilen in `playground/k8s/30-frontend-replicaset.yaml`:

```yaml
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-frontend
      tier: frontend
```

```bash
kubectl apply -f playground/k8s/30-frontend-replicaset.yaml
kubectl get rs
kubectl get pods -l app=hello-frontend -o wide
```

```text
pod "frontend" deleted
replicaset.apps/hello-frontend created
NAME             DESIRED   CURRENT   READY   AGE
hello-frontend   3         3         3       6s
NAME                   READY   STATUS    RESTARTS   AGE   IP          NODE             NOMINATED NODE   READINESS GATES
hello-frontend-7mh4d   1/1     Running   0          6s    10.1.0.31   docker-desktop   <none>           <none>
hello-frontend-p9wzl   1/1     Running   0          6s    10.1.0.32   docker-desktop   <none>           <none>
hello-frontend-x2kqp   1/1     Running   0          6s    10.1.0.30   docker-desktop   <none>           <none>
```

Ohne das Löschen hätte das ReplicaSet den Pod `frontend` (gleiche Labels, kein Besitzer) übernommen und nur zwei neue Pods angelegt. Ohne `rm` würde ein späteres `kubectl apply -f playground/k8s/` den Einzel-Pod zurückholen.

## Aufgabe 2: Self-Healing

```bash
kubectl get pods -l app=hello-frontend -w     # zweites Terminal
kubectl delete pod hello-frontend-x2kqp       # erstes Terminal, eigenen Namen einsetzen
kubectl describe pod hello-frontend-c5r8n     # Name des neuen Pods
```

Watch-Terminal:

```text
NAME                   READY   STATUS              RESTARTS   AGE
hello-frontend-7mh4d   1/1     Running             0          3m
hello-frontend-p9wzl   1/1     Running             0          3m
hello-frontend-x2kqp   1/1     Running             0          3m
hello-frontend-x2kqp   1/1     Terminating         0          3m
hello-frontend-c5r8n   0/1     Pending             0          0s
hello-frontend-c5r8n   0/1     ContainerCreating   0          0s
hello-frontend-c5r8n   1/1     Running             0          1s
```

Ausschnitt aus `describe`:

```text
Name:             hello-frontend-c5r8n
Namespace:        hello
Labels:           app=hello-frontend
                  tier=frontend
                  version=v1
Status:           Running
IP:               10.1.0.33
Controlled By:    ReplicaSet/hello-frontend
```

Der Ersatz hat einen neuen Namen und eine neue IP; der Service `frontend` nimmt ihn automatisch auf, weil er nach Labels auswählt.

## Aufgabe 3: auf fünf skalieren

```bash
kubectl scale rs hello-frontend --replicas=5
for i in $(seq 1 10); do curl -s http://localhost:30080/ | grep -o 'Frontend:</b> [^<]*'; done
```

```text
replicaset.apps/hello-frontend scaled
Frontend:</b> hello-frontend-p9wzl (10.1.0.32)
Frontend:</b> hello-frontend-k4tzb (10.1.0.36)
Frontend:</b> hello-frontend-7mh4d (10.1.0.31)
Frontend:</b> hello-frontend-q7vxd (10.1.0.37)
Frontend:</b> hello-frontend-p9wzl (10.1.0.32)
Frontend:</b> hello-frontend-c5r8n (10.1.0.33)
Frontend:</b> hello-frontend-k4tzb (10.1.0.36)
Frontend:</b> hello-frontend-7mh4d (10.1.0.31)
Frontend:</b> hello-frontend-c5r8n (10.1.0.33)
Frontend:</b> hello-frontend-q7vxd (10.1.0.37)
```

Der Service verteilt jede neue Verbindung zufällig auf die fünf Pods; die Reihenfolge ist deshalb in jedem Lauf anders. Im Browser wechselt der Name ebenso, weil die Hello-App jede Verbindung nach der Antwort schließt.

## Aufgabe 4: Datei erneut anwenden

```bash
kubectl get rs
kubectl apply -f playground/k8s/30-frontend-replicaset.yaml
kubectl get rs
```

```text
NAME             DESIRED   CURRENT   READY   AGE
hello-frontend   5         5         5       8m
replicaset.apps/hello-frontend configured
NAME             DESIRED   CURRENT   READY   AGE
hello-frontend   3         3         3       8m
```

Die Datei sagt `replicas: 3`; `apply` setzt das Soll zurück, und das ReplicaSet löscht zwei Pods. Wer dauerhaft fünf Pods will, ändert die Datei.
