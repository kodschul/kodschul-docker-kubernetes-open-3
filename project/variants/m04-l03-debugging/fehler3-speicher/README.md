# Fehlerbild 3

Hello-App aus den fertigen Images `hello-frontend:v1` und `hello-backend:v1`.

```bash
docker compose up -d
```

| Erwartet | Beobachtet |
| --- | --- |
| `http://localhost:8093` zeigt „Hello-App v1" mit einer Backend-Antwort. | Die Seite lädt, unter **Backend** steht „Backend nicht erreichbar". |

Finde die Ursache, behebe sie in `compose.yml` und starte erneut. Räume danach mit `docker compose down` auf.
