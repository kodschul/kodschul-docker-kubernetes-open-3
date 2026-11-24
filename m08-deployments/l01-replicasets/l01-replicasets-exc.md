# Lab 8.1 – Übung: ReplicaSets und Skalierung

**Dauer:** ca. 10 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — das Frontend läuft als ReplicaSet `hello-frontend` statt als Einzel-Pod; Lab 8.2 ersetzt es durch ein Deployment.

## Vorbereitung

- Zwei Terminals (bash) im Ordner `project/` öffnen.
- Starter: [`project/starters/m08-l01-frontend-replicaset.yaml`](../../project/starters/m08-l01-frontend-replicaset.yaml)
- Arbeitsdatei: `project/playground/k8s/30-frontend-replicaset.yaml` (neu)
- Prüfen: `kubectl get pods,svc` zeigt die Pods `backend`, `backend-2`, `frontend` und die Services `backend` und `frontend` (NodePort `30080`).
- Stand aus Modul 7 wiederherstellen (falls nötig): `kubectl apply -f examples/m08-deployments/l01-replicasets/` stellt direkt den Endstand dieses Labs her.

## Aufgaben

1. Lösche den Einzel-Pod mit `kubectl delete pod frontend` und seine Manifest-Datei mit `rm playground/k8s/*frontend-pod.yaml`. Kopiere den Starter nach `playground/k8s/30-frontend-replicaset.yaml`, ergänze die beiden TODOs (`replicas`, `selector`) und wende die Datei an. Zeige das Ergebnis mit `kubectl get rs` und `kubectl get pods -l app=hello-frontend -o wide`.
2. Starte im zweiten Terminal `kubectl get pods -l app=hello-frontend -w`. Lösche im ersten Terminal einen der drei Frontend-Pods per Name und beobachte den Ersatz. Zeige mit `kubectl describe pod <neuer Pod>`, wer ihn verwaltet (`Controlled By`).
3. Skaliere mit `kubectl scale rs hello-frontend --replicas=5`. Rufe die Seite zehnmal über den NodePort ab: `for i in $(seq 1 10); do curl -s http://localhost:30080/ | grep -o 'Frontend:</b> [^<]*'; done`. Lade zusätzlich `http://localhost:30080` im Browser mehrmals neu.
4. Wende die Datei erneut an (`kubectl apply -f playground/k8s/30-frontend-replicaset.yaml`) und vergleiche `kubectl get rs` vor und nach dem `apply`. Beende danach das Watch im zweiten Terminal mit **Strg+C**.

## Checkpoint

- Aufgabe 1: `kubectl get rs` zeigt `hello-frontend` mit `DESIRED 3`, `CURRENT 3`, `READY 3`; die drei Pods heißen `hello-frontend-<5 Zeichen>` und haben eigene IPs.
- Aufgabe 2: Das Watch-Terminal zeigt `Terminating` beim gelöschten und `Pending` → `ContainerCreating` → `Running` bei einem neuen Pod; `Controlled By: ReplicaSet/hello-frontend`.
- Aufgabe 3: Die Schleife zeigt mehrere verschiedene Pod-Namen und IPs; die Seite antwortet jedes Mal mit „Hello-App v1" und einer Backend-Antwort.
- Aufgabe 4: Nach `scale` stehen `5 5 5`, nach dem `apply` wieder `3 3 3`.

## Abschlusskriterien

- `playground/k8s/` enthält `30-frontend-replicaset.yaml`, aber keine Datei für den Einzel-Pod `frontend` mehr.
- Im Namespace `hello` laufen die Pods `backend`, `backend-2` und drei Pods `hello-frontend-…`; `http://localhost:30080` zeigt die Hello-Seite.

## Fallback

- Der Starter lässt sich nicht anwenden: fertige Datei [`project/examples/m08-deployments/l01-replicasets/30-frontend-replicaset.yaml`](../../project/examples/m08-deployments/l01-replicasets/30-frontend-replicaset.yaml) nach `playground/k8s/` kopieren.
- Ganzer Stand: `kubectl apply -f examples/m08-deployments/l01-replicasets/` (danach `kubectl delete pod frontend`, falls der Einzel-Pod noch läuft).
