## Docker: Verwalten von Images - Speichern, Laden, Verteilen

Docker ermöglicht es, Images zu erstellen, zu speichern, zu laden und zu verteilen. Dies ist ein wichtiger Bestandteil des Entwicklungs- und Bereitstellungsprozesses von Anwendungen. Im Folgenden sind einige grundlegende Konzepte und Codebeispiele zum Verwalten von Docker-Images:

### Beispiel 1: Speichern von Docker-Images

Um ein Docker-Image zu speichern, können Sie den `docker save`-Befehl verwenden:

```bash
docker save -o mein_image.tar mein_image:tag
```

### Beispiel 2: Laden von Docker-Images
Um ein zuvor gespeichertes Docker-Image zu laden, verwenden Sie den docker load-Befehl:

```bash
docker load -i mein_image.tar
```

### Beispiel 3: Verteilen von Docker-Images
Um Docker-Images zwischen verschiedenen Umgebungen zu verteilen, können Sie ein Docker-Repository verwenden, z. B. Docker Hub oder ein privates Repository. Sie können auch Images manuell exportieren und importieren oder Docker-Registries verwenden.

```bash
# Login bei Docker Hub (falls erforderlich)
docker login

# Taggen des Images für Docker Hub
docker tag mein_image:tag benutzername/mein_image:tag

# Hochladen des Images auf Docker Hub
docker push benutzername/mein_image:tag
```
Dieser Prozess ermöglicht es, Docker-Images einfach zu verteilen und in verschiedenen Umgebungen bereitzustellen.