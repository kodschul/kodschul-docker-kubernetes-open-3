## Docker: Containerisolierung und Ressourcenbeschränkungen

Docker ist eine Plattform zur Entwicklung, Bereitstellung und Ausführung von Anwendungen mithilfe von Containervirtualisierung. Container bieten eine leichtgewichtige und flexible Möglichkeit, Anwendungen zu isolieren und Ressourcen effizient zu nutzen. Im Folgenden werden grundlegende Konzepte und Funktionalitäten von Docker erläutert:

### Was ist Docker?

Docker ist eine Open-Source-Plattform, die es Entwicklern ermöglicht, Anwendungen in Containern zu verpacken und auszuführen. Container sind isolierte Umgebungen, die alle erforderlichen Abhängigkeiten einer Anwendung enthalten, einschließlich des Betriebssystems, der Laufzeitumgebung, Bibliotheken und Code. Docker ermöglicht es Entwicklern, Anwendungen in einer konsistenten Umgebung auszuführen, unabhängig von der zugrunde liegenden Infrastruktur.

### Containerisolierung

Docker verwendet Linux-Container (LXC), um Anwendungen zu isolieren. Jeder Container führt in seinem eigenen isolierten Prozessraum, Dateisystem und Netzwerkstack aus. Dies ermöglicht es mehreren Containern, auf demselben Host-System zu laufen, ohne sich gegenseitig zu beeinflussen. Die Isolierung gewährleistet auch Sicherheit, da ein Container nicht ohne weiteres auf Ressourcen anderer Container zugreifen kann.

### Ressourcenbeschränkungen

Docker ermöglicht die Festlegung von Ressourcenbeschränkungen für Container, um die Systemressourcen effizient zu nutzen und die Leistung zu steuern. Zu den häufig verwendeten Ressourcenbeschränkungen gehören:

- **CPU**: Begrenzt die maximale CPU-Auslastung, die ein Container verwenden kann.
- **Speicher**: Begrenzt die maximale Speichernutzung eines Containers.
- **Netzwerkbandbreite**: Begrenzt die maximale Netzwerkbandbreite, die ein Container verwenden kann.
- **I/O-Bandbreite**: Begrenzt die maximale Ein-/Ausgabe-Bandbreite für ein Container.

### Beispiel: Starten eines Containers mit Ressourcenbeschränkungen

```bash
docker run --cpus 2 --memory 512m nginx
```

In diesem Beispiel wird ein Nginx-Container gestartet und ihm werden 2 CPU-Kerne und 512 MB RAM zugewiesen. Dies stellt sicher, dass der Container die angegebenen Ressourcenbeschränkungen einhält.