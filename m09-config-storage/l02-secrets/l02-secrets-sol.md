# Lab 9.2 – Lösung: Secrets

Alle Befehle im Ordner `project/`. `uebung-2026` ist ein Übungswert; Pod-Namen und Zeiten weichen ab.

## Aufgabe 1: Secret per Befehl anlegen

```bash
kubectl create secret generic hello-secret --from-literal=admin-password=uebung-2026
kubectl get secret hello-secret
kubectl describe secret hello-secret
```

```text
secret/hello-secret created

NAME           TYPE     DATA   AGE
hello-secret   Opaque   1      3s

Name:         hello-secret
Namespace:    hello
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
admin-password:  11 bytes
```

`describe` verrät nur die Länge: `uebung-2026` hat 11 Zeichen.

## Aufgabe 2: Base64 zurückwandeln

```bash
kubectl get secret hello-secret -o yaml
```

```yaml
apiVersion: v1
data:
  admin-password: dWVidW5nLTIwMjY=
kind: Secret
metadata:
  creationTimestamp: "2026-11-24T15:21:07Z"
  name: hello-secret
  namespace: hello
  resourceVersion: "48213"
  uid: 6f0c1d2e-8a4b-4c3d-9e7f-1a2b3c4d5e6f
type: Opaque
```

```bash
kubectl get secret hello-secret -o jsonpath='{.data.admin-password}' | base64 -d
```

```text
uebung-2026
```

Ein Befehl genügt, um aus dem gespeicherten Wert wieder Klartext zu machen. Deshalb müssen Leserechte auf Secrets eng begrenzt werden.

## Aufgabe 3: Secret als Datei ins Frontend

```bash
cp starters/m09-l02-frontend-deployment.yaml playground/k8s/30-frontend-deployment.yaml
```

Ergänzter Ausschnitt:

```yaml
          volumeMounts:
            - name: admin-secret
              mountPath: /etc/hello-secret
              readOnly: true
      volumes:
        - name: admin-secret
          secret:
            secretName: hello-secret
```

```bash
kubectl apply -f playground/k8s/30-frontend-deployment.yaml
kubectl rollout status deployment/hello-frontend
```

```text
deployment.apps/hello-frontend configured
Waiting for deployment "hello-frontend" rollout to finish: 1 out of 3 new replicas have been updated...
…
deployment "hello-frontend" successfully rolled out
```

Die Hello-Seite zeigt:

```text
Hello-App v2
Frontend: hello-frontend-5f7d9c8b4d-k2v8n (10.1.0.52)
Backend: hello-backend-5d7c9f6b8b-4xk2p (10.1.0.24) um 15:24:10
Admin: Passwort gesetzt
```

`mountPath` ist der Ordner aus der Standard-Einstellung `SECRET_FILE=/etc/hello-secret/admin-password` der App; der Schlüssel `admin-password` liefert den Dateinamen.

Vollständige Datei: [`examples/m09-config-storage/l02-secrets/30-frontend-deployment.yaml`](../../project/examples/m09-config-storage/l02-secrets/30-frontend-deployment.yaml)

## Aufgabe 4: Datei im Pod ansehen

```bash
kubectl exec deploy/hello-frontend -- ls /etc/hello-secret/
kubectl exec deploy/hello-frontend -- cat /etc/hello-secret/admin-password
kubectl exec deploy/hello-frontend -- env | grep -i password
```

```text
admin-password

uebung-2026
```

Der dritte Befehl gibt nichts aus: Das Passwort liegt nur in der Datei und taucht weder in `env` noch in `kubectl describe pod` auf. Wer `kubectl exec` in diesen Pod darf, liest es trotzdem; auch dieses Recht ist deshalb zu begrenzen.

Fertiger Stand: [`examples/m09-config-storage/l02-secrets/`](../../project/examples/m09-config-storage/l02-secrets/)
