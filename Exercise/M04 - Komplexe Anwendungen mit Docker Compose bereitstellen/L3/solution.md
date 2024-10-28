# Übung: Datenvolumes und Persistenz in deinem Rezeptbuch-Projekt

**Kontext**: In dieser Übung wirst du lernen, wie du Datenvolumes verwendest, um sicherzustellen, dass die Rezeptdaten auch nach dem Neustart oder Löschen des Containers erhalten bleiben. Außerdem wirst du Best Practices für den Umgang mit Volumes in Docker Compose anwenden.

---

### Aufgaben:

#### Schritt 1: Volume für die Datenbank hinzufügen
1. Öffne die Datei `docker-compose.yml` im Hauptverzeichnis (`recipe-book`).
2. Definiere ein Volume für die MongoDB-Datenbank, damit die Rezeptdaten auch nach dem Neustart des Containers bestehen bleiben.
   - Füge im `volumes`-Abschnitt der `docker-compose.yml` Datei folgendes hinzu:
     ```yaml
     volumes:
       recipe-data:
     ```

#### Schritt 2: Volume zur MongoDB-Konfiguration hinzufügen
1. Füge das erstellte Volume in der `docker-compose.yml` Datei zum `recipe-database` Dienst hinzu, sodass die Datenbank die Daten in diesem Volume speichert.
   - Beispiel-Konfiguration:
     ```yaml
     services:
       recipe-database:
         image: mongo
         volumes:
           - recipe-data:/data/db
     ```
2. Diese Konfiguration stellt sicher, dass alle Daten, die die MongoDB-Datenbank speichert, im Volume `recipe-data` gesichert werden.

#### Schritt 3: Docker Compose Datei – finale Konfiguration
1. Stelle sicher, dass deine `docker-compose.yml` Datei sowohl die `recipe-app` als auch `recipe-database` Dienste definiert und dass das Volume für die Datenbank korrekt eingebunden ist.
   - Vollständiges Beispiel:
     ```yaml
     version: '3.8'
     services:
       recipe-app:
         build: ./app
         ports:
           - "3000:3000"
         depends_on:
           - recipe-database

       recipe-database:
         image: mongo
         volumes:
           - recipe-data:/data/db

     volumes:
       recipe-data:
     ```

#### Schritt 4: Anwendung neu starten und Datenpersistenz testen
1. **Stoppe** die laufenden Container und entferne sie, falls nötig, mit folgendem Befehl:
    ```bash
    docker-compose down
    ```
2. **Starte** die Anwendung erneut mit `docker-compose up -d`, um sicherzustellen, dass das Volume korrekt eingebunden ist.
3. **Teste die Persistenz**:
   - Füge ein Rezept hinzu, indem du eine `POST`-Anfrage an `http://localhost:3000/recipes` sendest (siehe vorherige Übung).
   - Stoppe anschließend alle Container und starte sie erneut mit `docker-compose up -d`.
   - Überprüfe, ob das hinzugefügte Rezept weiterhin in der Datenbank vorhanden ist, indem du eine `GET`-Anfrage an `http://localhost:3000/recipes` sendest.

#### Schritt 5: Cleanup – Volumes verwalten
1. **Überprüfe alle Volumes** auf deinem System, um ungenutzte Volumes zu identifizieren und zu entfernen:
   ```bash
   docker volume ls
   ```