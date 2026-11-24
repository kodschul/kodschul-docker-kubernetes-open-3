# Lab 9.3 – Lösung: Volumes und PersistentVolumes

Alle Befehle im Ordner `project/`. Namen, Zeiten und IPs weichen ab; die Uhrzeiten im Log sind UTC.

## Aufgabe 1: StorageClass und PVC

```bash
kubectl get storageclass
cp starters/m09-l03-pvc.yaml playground/k8s/07-pvc.yaml
```

```yaml
# playground/k8s/07-pvc.yaml, ergänzte Stellen
spec:
  storageClassName: hostpath
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
```

```bash
kubectl apply -f playground/k8s/07-pvc.yaml
kubectl get pvc,pv
```

```text
NAME                 PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
hostpath (default)   docker.io/hostpath   Delete          Immediate           false                  3d

persistentvolumeclaim/hello-data created

NAME                               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/hello-data   Bound    pvc-3f1c2a7e-9b1d-4c55-8e0a-6d2f1b7c9a10   100Mi      RWO            hostpath       <unset>                 4s

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM              STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
persistentvolume/pvc-3f1c2a7e-9b1d-4c55-8e0a-6d2f1b7c9a10   100Mi      RWO            Delete           Bound    hello/hello-data   hostpath       <unset>                          4s
```

Das PV hat niemand von Hand angelegt: Der Provisioner der StorageClass `hostpath` hat es für den Claim erzeugt (dynamische Bereitstellung). Wichtig sind `STATUS Bound`, `RECLAIM POLICY` und `CLAIM`; die übrigen Spalten können ignoriert werden.

## Aufgabe 2: Frontend auf den PVC umstellen

```bash
cp starters/m09-l03-frontend-deployment.yaml playground/k8s/30-frontend-deployment.yaml
```

```yaml
# ergänzte Stellen
spec:
  replicas: 1
  ...
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: hello-data
```

```bash
kubectl apply -f playground/k8s/30-frontend-deployment.yaml
kubectl rollout status deployment/hello-frontend
for i in 1 2 3; do curl -s -o /dev/null http://localhost:30080/; done
kubectl exec deploy/hello-frontend -- cat /data/access.log
```

```text
deployment.apps/hello-frontend configured
deployment "hello-frontend" successfully rolled out
2026-11-24T15:30:03 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2
2026-11-24T15:30:03 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2
2026-11-24T15:30:04 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2
```

Jede Zeile: Zeitpunkt, Pod-Name, Pod-IP, Version. Vollständige Datei: [`examples/m09-config-storage/l03-volumes/30-frontend-deployment.yaml`](../../project/examples/m09-config-storage/l03-volumes/30-frontend-deployment.yaml)

## Aufgabe 3: Pod löschen, Log bleibt

```bash
kubectl delete pod -l app=hello-frontend
kubectl get pods -l app=hello-frontend
kubectl exec deploy/hello-frontend -- cat /data/access.log
curl -s -o /dev/null http://localhost:30080/
kubectl exec deploy/hello-frontend -- cat /data/access.log
```

```text
pod "hello-frontend-6d9f7c8b5-q7x2m" deleted

NAME                             READY   STATUS    RESTARTS   AGE
hello-frontend-6d9f7c8b5-w4hvn   1/1     Running   0          31s

2026-11-24T15:30:03 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2
2026-11-24T15:30:03 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2
2026-11-24T15:30:04 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2

2026-11-24T15:30:03 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2
2026-11-24T15:30:03 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2
2026-11-24T15:30:04 hello-frontend-6d9f7c8b5-q7x2m 10.1.0.87 v2
2026-11-24T15:31:12 hello-frontend-6d9f7c8b5-w4hvn 10.1.0.88 v2
```

Der Ersatz-Pod hängt dasselbe PV ein und schreibt in dieselbe Datei weiter. `kubectl delete pod` dauert rund 30 Sekunden: Python als Hauptprozess reagiert nicht auf das Stopp-Signal, Kubernetes wartet die Frist ab und beendet den Container dann hart.

## Aufgabe 4: Statisches PV binden

```bash
cp starters/m09-l03-static-pv.yaml playground/k8s/08-static-pv.yaml
```

```yaml
# ergänzte Stelle im Claim hello-pv-claim
spec:
  storageClassName: ""
  volumeName: hello-pv
```

```bash
kubectl apply -f playground/k8s/08-static-pv.yaml
kubectl get pv,pvc
```

```text
persistentvolume/hello-pv created
persistentvolumeclaim/hello-pv-claim created

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
persistentvolume/hello-pv                                   100Mi      RWO            Retain           Bound    hello/hello-pv-claim                  <unset>                          5s
persistentvolume/pvc-3f1c2a7e-9b1d-4c55-8e0a-6d2f1b7c9a10   100Mi      RWO            Delete           Bound    hello/hello-data       hostpath       <unset>                          6m

NAME                                   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/hello-data       Bound    pvc-3f1c2a7e-9b1d-4c55-8e0a-6d2f1b7c9a10   100Mi      RWO            hostpath       <unset>                 6m
persistentvolumeclaim/hello-pv-claim   Bound    hello-pv                                   100Mi      RWO                           <unset>                 5s
```

Zwei Wege zum selben Ergebnis: `hello-data` bekam sein PV automatisch von der StorageClass, `hello-pv-claim` bindet das von Hand angelegte `hello-pv`. Die leere Spalte `STORAGECLASS` zeigt, dass hier keine StorageClass beteiligt ist. Ohne `storageClassName: ""` hätte Kubernetes die Default-StorageClass `hostpath` eingetragen; der Claim wäre `Pending` geblieben (`storageClassName does not match`), weil `hello-pv` keine Klasse hat. Kein Pod nutzt `hello-pv-claim`; ein Deployment würde ihn genauso über `claimName` einbinden wie `hello-data`.

Fertiger Stand: [`examples/m09-config-storage/l03-volumes/`](../../project/examples/m09-config-storage/l03-volumes/)
