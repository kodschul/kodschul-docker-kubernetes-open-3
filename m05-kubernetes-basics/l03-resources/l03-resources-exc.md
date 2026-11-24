# Lab 5.3 – Übung: Ressourcen und Manifeste

**Dauer:** ca. 15 Minuten
**Ändert die Hello-App-Projektbasis?** Ja — es entsteht `playground/k8s/00-namespace.yaml`; der Namespace `hello` ist ab jetzt Standard im Kontext, alle Objekte ab Lab 7.1 liegen darin.

## Vorbereitung

- Terminal im Ordner `project/` öffnen; `kubectl get nodes` zeigt `docker-desktop` als `Ready` (Lab 5.2).
- Starter: keiner; das Manifest entsteht in Aufgabe 2 per Dry-Run.
- Arbeitsdatei: `project/playground/k8s/00-namespace.yaml`
- Vergleich: [`project/examples/m05-kubernetes-basics/l03-resources/00-namespace.yaml`](../../project/examples/m05-kubernetes-basics/l03-resources/00-namespace.yaml)

## Aufgaben

1. Lies die Ausgabe von `kubectl api-resources` und notiere für `namespaces`, `pods` und `services` Kurzname, `APIVERSION` und ob der Typ zu einem Namespace gehört. Rufe danach `kubectl explain namespace` auf.
2. Lege den Ordner `playground/k8s` an und erzeuge das Manifest mit `kubectl create namespace hello --dry-run=client -o yaml > playground/k8s/00-namespace.yaml`. Öffne die Datei in VS Code und entferne die leeren Zeilen `spec: {}` und `status: {}`.
3. Wende die Datei mit `kubectl apply -f playground/k8s/00-namespace.yaml` an, zeige mit `kubectl get namespaces` alle Namespaces an und wende die Datei danach ein zweites Mal an.
4. Setze `hello` mit `kubectl config set-context --current --namespace=hello` als Standard-Namespace und prüfe das Ergebnis mit `kubectl config get-contexts` und `kubectl get pods`.
5. Zeige das gespeicherte Objekt mit `kubectl get namespace hello -o yaml` an und finde `spec` und `status.phase`.

## Checkpoint

- `kubectl api-resources` zeigt `namespaces` mit `ns`, `v1`, `false`; `pods` mit `po`, `v1`, `true`; `services` mit `svc`, `v1`, `true`.
- `playground/k8s/00-namespace.yaml` enthält `apiVersion: v1`, `kind: Namespace` und `metadata.name: hello`.
- Erstes `apply`: `namespace/hello created`; zweites `apply`: `namespace/hello unchanged`.
- `kubectl config get-contexts` zeigt in der Spalte `NAMESPACE` den Wert `hello`; `kubectl get pods` meldet `No resources found in hello namespace.`
- Die YAML-Ausgabe enthält `spec.finalizers` und `status.phase: Active`.

## Abschlusskriterien

- Der Namespace `hello` existiert, ist im Kontext `docker-desktop` als Standard gesetzt und als Datei in `playground/k8s/` beschrieben.

## Fallback

- Stand dieses Labs wiederherstellen (z. B. nach einem Cluster-Reset):

  ```bash
  kubectl apply -f examples/m05-kubernetes-basics/l03-resources/
  kubectl config set-context --current --namespace=hello
  ```
