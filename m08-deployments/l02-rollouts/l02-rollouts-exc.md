# Lab 8.2 – Übung: Deployments: Rollout und Rollback

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — Backend und Frontend laufen als Deployments `hello-backend` (2 Pods) und `hello-frontend` (3 Pods, `v2`); Lab 8.3 baut darauf auf.

## Vorbereitung

- Zwei Terminals (bash) im Ordner `project/` öffnen.
- Starter: [`project/starters/m08-l02-backend-deployment.yaml`](../../project/starters/m08-l02-backend-deployment.yaml) (fertig vorbereitet), [`project/starters/m08-l02-frontend-deployment.yaml`](../../project/starters/m08-l02-frontend-deployment.yaml) (mit TODOs)
- Arbeitsdateien: `project/playground/k8s/10-backend-deployment.yaml`, `project/playground/k8s/30-frontend-deployment.yaml` (beide neu)
- Images `hello-frontend:v1` und `hello-frontend:v2` sind lokal vorhanden (`docker images hello-frontend`); `hello-frontend:v3` gibt es absichtlich nicht.
- Stand aus Lab 8.1 wiederherstellen (falls nötig): `kubectl apply -f examples/m08-deployments/l01-replicasets/`

## Aufgaben

1. Räume die Objekte aus Modul 7 und Lab 8.1 ab: `kubectl delete rs hello-frontend` und `kubectl delete pod backend backend-2`. Lösche auch die Dateien: `rm playground/k8s/*-pod.yaml playground/k8s/30-frontend-replicaset.yaml`.
2. Kopiere den Backend-Starter nach `playground/k8s/10-backend-deployment.yaml` und den Frontend-Starter nach `playground/k8s/30-frontend-deployment.yaml`. Ergänze im Frontend die drei TODOs (`kind`, `change-cause` „Start mit v1", Strategie) und wende den ganzen Ordner mit `kubectl apply -f playground/k8s/` an. Zeige `kubectl get deploy,rs,pods` und öffne `http://localhost:30080`.
3. Starte im zweiten Terminal `kubectl get pods -l app=hello-frontend -w`. Ändere in `30-frontend-deployment.yaml` Image und Label `version` auf `v2` und `change-cause` auf „Update auf v2", wende die Datei an und verfolge den Rollout mit `kubectl rollout status deployment/hello-frontend`. Lade währenddessen die Seite mehrmals neu und zeige danach `kubectl get rs -l app=hello-frontend`.
4. Rolle per Befehl ein kaputtes `v3` aus: `kubectl set image deployment/hello-frontend frontend=hello-frontend:v3`, direkt danach `kubectl annotate deployment/hello-frontend kubernetes.io/change-cause="Update auf v3" --overwrite`. Prüfe mit `kubectl rollout status deployment/hello-frontend --timeout=30s` und `kubectl get pods -l app=hello-frontend`, was passiert, und lade die Seite neu.
5. Rolle mit `kubectl rollout undo deployment/hello-frontend` zurück und zeige `kubectl rollout history deployment/hello-frontend`. Wende danach `playground/k8s/30-frontend-deployment.yaml` erneut an und prüfe mit `rollout history`, dass keine neue Revision entsteht.

## Checkpoint

- Aufgabe 2: `kubectl get deploy` zeigt `hello-backend 2/2` und `hello-frontend 3/3`; Pod-Namen folgen dem Muster `hello-frontend-<hash>-<5 Zeichen>`; die Seite ist hellblau, „Hello-App v1", mit Backend-Antwort.
- Aufgabe 3: Im Watch-Terminal ist immer erst ein neuer Pod `Running`, bevor ein alter `Terminating` wird; die Seite zeigt kurz abwechselnd `v1` und `v2`, danach nur noch hellgrün „Hello-App v2"; das alte ReplicaSet steht auf `DESIRED 0`.
- Aufgabe 4: Ein neuer Pod hat `ErrImageNeverPull`, drei `v2`-Pods laufen weiter, die Seite bleibt grün.
- Aufgabe 5: `rollout history` zeigt die Revisionen `1`, `3`, `4` mit „Start mit v1", „Update auf v3", „Update auf v2"; das erneute `apply` ändert daran nichts.

## Abschlusskriterien

- `playground/k8s/` enthält die beiden Deployment-Dateien und die Service-Dateien aus Modul 7, aber keine Pod- oder ReplicaSet-Dateien mehr.
- `30-frontend-deployment.yaml` enthält `image: hello-frontend:v2`, `version: v2`, `change-cause` „Update auf v2" und die Strategie `RollingUpdate` mit `maxSurge: 1`, `maxUnavailable: 0`.
- `kubectl get pods` zeigt nur Pods mit Namen `hello-backend-…` und `hello-frontend-…`, alle `1/1 Running`.

## Fallback

- Fertige Dateien: [`project/examples/m08-deployments/l02-rollouts/`](../../project/examples/m08-deployments/l02-rollouts/); nach Aufgabe 1 mit `kubectl apply -f examples/m08-deployments/l02-rollouts/` anwenden (die Historie hat dann nur eine Revision mit `v2`).
