# Lab 8.3 – Lösung: Zwei Versionen parallel

Alle Befehle laufen im Ordner `project/`. Hash-Werte in Namen, IPs und die Zählungen weichen ab.

## Aufgabe 1: stabile Version zurück auf v1

```bash
kubectl rollout undo deployment/hello-frontend --to-revision=1
kubectl rollout status deployment/hello-frontend
kubectl rollout history deployment/hello-frontend
```

```text
deployment.apps/hello-frontend rolled back
Waiting for deployment "hello-frontend" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "hello-frontend" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "hello-frontend" rollout to finish: 1 old replicas are pending termination...
deployment "hello-frontend" successfully rolled out
deployment.apps/hello-frontend
REVISION  CHANGE-CAUSE
3         Update auf v3
4         Update auf v2
5         Start mit v1
```

Revision 1 kommt als Revision 5 zurück, als Rolling Update ohne Ausfall. Die Datei `30-frontend-deployment.yaml` enthält weiter `v2`; das wird in Aufgabe 5 genutzt.

## Aufgabe 2: Canary starten

```bash
cp starters/m08-l03-frontend-canary.yaml playground/k8s/35-frontend-canary-deployment.yaml
```

Ergänzte Zeilen:

```yaml
  selector:
    matchLabels:
      app: hello-frontend
      version: v2
  template:
    metadata:
      labels:
        app: hello-frontend
        tier: frontend
        version: v2
```

```bash
kubectl apply -f playground/k8s/35-frontend-canary-deployment.yaml
kubectl get pods -l app=hello-frontend -L version
```

```text
deployment.apps/hello-frontend-canary created
NAME                                     READY   STATUS    RESTARTS   AGE   VERSION
hello-frontend-7d9c5b8f6b-b6wqz          1/1     Running   0          2m    v1
hello-frontend-7d9c5b8f6b-gk2pd          1/1     Running   0          2m    v1
hello-frontend-7d9c5b8f6b-w9tnc          1/1     Running   0          2m    v1
hello-frontend-canary-6d8f7b9c5d-zr4mx   1/1     Running   0          6s    v2
```

Der Service `frontend` wurde nicht angefasst; er findet den Canary-Pod über `app: hello-frontend`.

## Aufgabe 3: Verteilung zählen

```bash
for i in $(seq 1 40); do curl -s http://localhost:30080/ | grep -m1 -o 'Hello-App v[0-9]'; done | sort | uniq -c
```

```text
  29 Hello-App v1
  11 Hello-App v2
```

Erwartet sind 30 zu 10 (3 von 4 Pods); kleine Abweichungen sind normal, weil jede Anfrage einzeln zufällig verteilt wird.

## Aufgabe 4: Blue/Green-Schalter

```bash
kubectl patch service frontend -p '{"spec":{"selector":{"version":"v2"}}}'
for i in $(seq 1 40); do curl -s http://localhost:30080/ | grep -m1 -o 'Hello-App v[0-9]'; done | sort | uniq -c
kubectl patch service frontend -p '{"spec":{"selector":{"version":null}}}'
kubectl get service frontend -o jsonpath='{.spec.selector}'
```

```text
service/frontend patched
  40 Hello-App v2
service/frontend patched
{"app":"hello-frontend"}
```

Mit `version: v2` im Selector passen nur noch Pods mit `app=hello-frontend` **und** `version=v2`: der eine Canary-Pod bekommt alle Anfragen. Nach dem Entfernen des Labels stehen wieder alle vier Pods hinter dem Service.

## Aufgabe 5: Umstieg abschließen

```bash
kubectl apply -f playground/k8s/30-frontend-deployment.yaml
kubectl rollout status deployment/hello-frontend
kubectl delete -f playground/k8s/35-frontend-canary-deployment.yaml
rm playground/k8s/35-frontend-canary-deployment.yaml
kubectl get deploy
for i in $(seq 1 40); do curl -s http://localhost:30080/ | grep -m1 -o 'Hello-App v[0-9]'; done | sort | uniq -c
```

```text
deployment.apps/hello-frontend configured
deployment "hello-frontend" successfully rolled out
deployment.apps "hello-frontend-canary" deleted
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
hello-backend    2/2     2            2           20m
hello-frontend   3/3     3            3           20m
  40 Hello-App v2
```

Das Deployment fährt das vorhandene ReplicaSet von `v2` wieder hoch (Revision 6, „Update auf v2"); erst danach wird der Canary gelöscht, so fehlt zu keinem Zeitpunkt ein Pod. `rollout history` zeigt jetzt die Revisionen `3`, `5`, `6`.
