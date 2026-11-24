# Best Practices

## Images

| Regel | Warum |
| --- | --- |
| feste Tags (`python:3.14-alpine`, `v2`) | `latest` ändert sich unbemerkt |
| schlanke Basisimages | weniger Speicher, weniger Lücken |
| erst `requirements.txt`, dann Code kopieren | Build-Cache bleibt nutzbar |
| `.dockerignore` pflegen | keine Geheimnisse, kleinerer Build |
| Images regelmäßig scannen und neu bauen | alte Basis = bekannte Lücken |

## Compose und Netzwerke

| Regel | Warum |
| --- | --- |
| Konfiguration über Umgebungsvariablen | ein Image für alle Umgebungen |
| Healthcheck + `depends_on: service_healthy` | Start erst, wenn das Backend antwortet |
| Daten in Named Volumes | überleben `down` und neue Versionen |
| nur das Frontend veröffentlicht Ports | Backend bleibt intern |
| Ressourcengrenzen setzen | ein Dienst blockiert nicht den Server |

## Kubernetes

| Regel | Warum |
| --- | --- |
| deklarativ mit `kubectl apply -f` | Zustand steht in Dateien, nachvollziehbar |
| Deployments statt einzelner Pods | Ersatz und Rollouts automatisch |
| Services statt Pod-IPs | Pod-IPs wechseln bei jedem Neustart |
| Labels `app`, `tier`, `version` | Auswahl und Filter eindeutig |
| Readiness- und Liveness-Probe | Anfragen nur an gesunde Pods |
| Requests und Limits setzen | Planung, Schutz, Voraussetzung für HPA |
| Konfiguration in ConfigMaps, Passwörter in Secrets | kein Neubau für andere Werte |
| Secrets nie in Git | Base64 ist keine Verschlüsselung |
| dauerhafte Daten auf PVCs | Pods sind flüchtig |
| fertige Software per Helm, eigene Apps als Chart | eine Installation, Versionen, Rollback |
| Dashboard-Admin-Token nur im Übungscluster | volle Rechte auf alles |
