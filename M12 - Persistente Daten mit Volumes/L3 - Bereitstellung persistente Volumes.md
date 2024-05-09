# Kubernetes: Bereitstellung von persistenten Volumes für Anwendungen

In Kubernetes können persistente Volumes (PVs) und persistente Volume-Ansprüche (PVCs) verwendet werden, um Daten über den Lebenszyklus von Pods und Containern hinweg zu speichern. Dies ermöglicht es Anwendungen, Daten auch nach dem Neustart oder der Wiedererstellung von Containern beizubehalten. Im Folgenden werden grundlegende Konzepte und Beispiele für die Bereitstellung von persistenten Volumes für Anwendungen in Kubernetes erläutert:

## Persistente Volumes (PVs) erstellen

Ein persistenter Volume repräsentiert einen von Kubernetes verwalteten Speicherbereich, der von Pods verwendet werden kann. PVs werden unabhängig von den Pods erstellt und können von mehreren Pods gleichzeitig genutzt werden. Hier ist ein Beispiel für die Definition eines PVs in Kubernetes:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: standard
  hostPath:
    path: /mnt/data
```

Dieses YAML-Manifest definiert ein persistentes Volume mit einer Kapazität von 1 GB, das auf einem Host-Pfad (/mnt/data) basiert. Die accessModes geben an, wie das Volume von den Pods verwendet werden kann, und die persistentVolumeReclaimPolicy bestimmt, was mit dem Volume geschieht, wenn es nicht mehr benötigt wird.

## Persistente Volume-Ansprüche (PVCs) verwenden
Ein persistenter Volume-Anspruch (PVC) ist eine Anforderung für Speicherplatz von einem PV. Pods können PVCs verwenden, um auf die darin angeforderten PVs zuzugreifen. Hier ist ein Beispiel für die Definition eines PVCs in Kubernetes:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard
```

Dieses YAML-Manifest definiert einen persistenten Volume-Anspruch für einen Speicherplatz von 1 GB. Der storageClassName entspricht dem des PVs, auf das der Anspruch abzielt.

## Anwendung von PVCs in Pods
Nachdem ein PV und ein PVC erstellt wurden, können sie von Pods verwendet werden, indem der PVC im Pod-Spec angegeben wird. Hier ist ein Beispiel für die Verwendung eines PVCs in einem Pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  volumes:
    - name: my-volume
      persistentVolumeClaim:
        claimName: my-pvc
  containers:
    - name: my-container
      image: nginx
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: my-volume
```

In diesem Beispiel wird ein Pod definiert, der auf das PVC my-pvc zugreift und den darin angeforderten Speicherplatz bereitstellt. Der PVC wird als Volume mit dem Namen my-volume im Pod eingehängt, und die Container im Pod können auf den darin enthaltenen Speicherplatz zugreifen.