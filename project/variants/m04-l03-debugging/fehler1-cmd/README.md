# Fehlerbild 1

Hello-App: Frontend wird aus `playground/frontend` gebaut (mit dem `Dockerfile` dieses Ordners), Backend aus `hello-backend:v1`.

```bash
docker compose up -d --build
```

| Erwartet | Beobachtet |
| --- | --- |
| `http://localhost:8091` zeigt „Hello-App v1" mit einer Backend-Antwort. | Der Browser meldet, dass die Seite nicht erreichbar ist. |

Finde die Ursache, behebe sie in den Dateien dieses Ordners und starte erneut. Räume danach mit `docker compose down` auf.
