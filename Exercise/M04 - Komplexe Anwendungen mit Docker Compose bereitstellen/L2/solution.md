# Übung: Erstelle dein eigenes Rezeptbuch mit Docker Compose

**Kontext**: Stell dir vor, du möchtest eine Anwendung erstellen, die dir hilft, deine Lieblingsrezepte zu speichern und sie jederzeit aufzurufen. Diese Anwendung wird ein Frontend für die Eingabe und Anzeige der Rezepte sowie eine Datenbank zum Speichern der Rezeptdaten enthalten. Du wirst Docker Compose verwenden, um die Anwendung als Multi-Container-Projekt lokal laufen zu lassen.

---

### Aufgaben:

#### Schritt 1: Projektverzeichnis und Dateien erstellen
1. Erstelle ein neues Verzeichnis für dein Projekt, z.B. `recipe-book`.
2. Gehe in das Projektverzeichnis und erstelle zwei Unterverzeichnisse:
   - `app` für die Anwendungsdateien.
   - `data` für die Datenbankdaten.

#### Schritt 2: Dockerfile erstellen
1. Erstelle im `app`-Ordner eine Datei namens `Dockerfile`.
2. Füge folgenden Inhalt hinzu, um die Anwendung auf Basis von Node.js zu erstellen:
    ```Dockerfile
    FROM node:16
    WORKDIR /app
    COPY . .
    RUN npm install
    CMD ["npm", "start"]
    ```

#### Schritt 3: Rezeptbuch-Code hinzufügen
1. Erstelle im `app`-Ordner zwei Dateien: `package.json` und `index.js`.
2. Füge in `package.json` den folgenden Code ein, um die Abhängigkeiten festzulegen:
    ```json
    {
      "name": "recipe-book",
      "version": "1.0.0",
      "main": "index.js",
      "scripts": {
        "start": "node index.js"
      },
      "dependencies": {
        "express": "^4.17.1",
        "mongoose": "^5.13.2"
      }
    }
    ```
3. In `index.js` fügst du folgenden Code ein, um einen Server und eine MongoDB-Verbindung für die Rezeptbuch-Anwendung zu erstellen:
    ```javascript
    const express = require('express');
    const mongoose = require('mongoose');
    const app = express();
    app.use(express.json());

    mongoose.connect('mongodb://recipe-database:27017/recipes', {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    const recipeSchema = new mongoose.Schema({ title: String, ingredients: [String], instructions: String });
    const Recipe = mongoose.model('Recipe', recipeSchema);

    app.post('/recipes', async (req, res) => {
      const recipe = new Recipe(req.body);
      await recipe.save();
      res.status(201).send(recipe);
    });

    app.get('/recipes', async (req, res) => {
      const recipes = await Recipe.find();
      res.send(recipes);
    });

    app.listen(3000, () => console.log('Recipe Book App listening on port 3000'));
    ```

#### Schritt 4: Docker Compose Datei erstellen
1. Erstelle im Hauptverzeichnis des Projekts (`recipe-book`) eine Datei namens `docker-compose.yml`.
2. Füge folgende Konfiguration hinzu, um die App und die Datenbank als separate Dienste zu definieren:
    ```yaml
    version: '3'
    services:
      recipe-app:
        build:
          context: ./app
        ports:
          - "3000:3000"
        depends_on:
          - recipe-database

      recipe-database:
        image: mongo:6
        ports:
          - "27017:27017"
    ```

#### Schritt 5: Die Anwendung starten
1. Öffne dein Terminal und navigiere in das `recipe-book` Verzeichnis.
2. Starte die Anwendung mit folgendem Befehl:
    ```bash
    docker-compose up
    ```

3. Prüfe die Ausgabe im Terminal, um sicherzustellen, dass beide Dienste (`recipe-app` und `recipe-database`) erfolgreich gestartet wurden.

#### Schritt 6: Das Rezeptbuch testen
1. Öffne in deinem Browser `http://localhost:3000` oder nutze ein Tool wie `Postman`, um HTTP-Anfragen zu testen.
2. Um ein Rezept hinzuzufügen, sende eine `POST`-Anfrage an `http://localhost:3000/recipes` mit folgendem JSON-Inhalt:
    ```json
    {
      "title": "Spaghetti Carbonara",
      "ingredients": ["Spaghetti", "Eier", "Speck", "Parmesan"],
      "instructions": "Spaghetti kochen, Speck anbraten, mit Eiern und Käse mischen."
    }
    ```
3. Um alle Rezepte anzuzeigen, sende eine `GET`-Anfrage an `http://localhost:3000/recipes`.

#### Schritt 7: Anwendung stoppen
- Entferne die Container mit:
    ```bash
    docker-compose down
    ```