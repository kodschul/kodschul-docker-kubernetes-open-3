# Lab 4.1 – Lösung: Docker-Netzwerke

Fertiger Stand als Befehlsfolge: `project/examples/m04-networking/l01-networks/hello-net.sh`. Getestet am 24.11.2026 mit Docker 29.9.3; IDs, Subnetze und IPs weichen ab.

## Aufgabe 1: Netzwerk anlegen

```bash
docker network ls
```

```text
NETWORK ID     NAME      DRIVER    SCOPE
1d62a60aa40d   bridge    bridge    local
42a751622b23   host      host      local
a58314f0838f   none      null      local
```

Läuft noch ein Compose-Projekt, steht zusätzlich `hello_default` in der Liste; nach `docker compose down` ist es weg.

```bash
docker network create hello-net
docker network inspect hello-net
```

```text
4aebee267396dd037893b22eb2127abafcd2510608a8719a2e2ef7d87ebcc1d9
[
    {
        "Name": "hello-net",
        "Driver": "bridge",                       ← Standardtreiber
        "IPAM": {
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",    ← Adressbereich des Netzwerks
                    "Gateway": "172.18.0.1"       ← Ausgang zum Host
                }
            ]
        },
        "Internal": false,
        "Labels": {},
        "Containers": {},                         ← noch leer
        …                                         ← weitere Felder: ignorierbar
    }
]
```

`create` gibt die lange Netzwerk-ID aus. Das Subnetz vergibt Docker selbst; im Test wurde es `172.18.0.0/16`, bei einem späteren Lauf `172.19.0.0/16`.

## Aufgabe 2: Hello-App im Netzwerk hello-net

```bash
docker run -d --name backend --network hello-net hello-backend:v1
docker run -d --name frontend --network hello-net -p 8080:80 \
  -e BACKEND_URL=http://backend hello-frontend:v1
```

`http://localhost:8080` zeigt „Hello-App v1" mit `Backend: e567916523df (172.19.0.2) um 23:23:55` (siehe Bild in der Theorie). `http://localhost:8081/api` ist nicht erreichbar (`curl` meldet `Failed to connect`): Das Backend hat keinen veröffentlichten Port. Das Frontend erreicht es trotzdem, weil beide im selben Netzwerk hängen.

Ohne `-e BACKEND_URL=http://backend` nutzt das Frontend seinen Standardwert `http://localhost:8081` und zeigt „Backend nicht erreichbar"; `localhost` ist im Container der Container selbst.

## Aufgabe 3: Container in der Standard-Bridge

```bash
docker run -d --name test busybox:1.37 sleep 3600
docker exec test wget -qO- -T 3 http://backend/api
```

```text
wget: bad address 'backend'
```

`test` hängt in der Standard-Bridge. Dort gibt es keine Namensauflösung für Container, und `hello-net` ist von dort aus ohnehin nicht erreichbar. `sleep 3600` hält den Container eine Stunde lang am Laufen, damit `docker exec` Befehle darin starten kann.

## Aufgabe 4: connect

```bash
docker network connect hello-net test
docker exec test wget -qO- -T 3 http://backend/api
```

```json
{"ip":"172.19.0.2","pod":"e567916523df","time":"23:23:55","version":"v1"}
```

```bash
docker network inspect hello-net --format '{{range .Containers}}{{println .Name .IPv4Address}}{{end}}'
```

```text
frontend 172.19.0.3/16
backend 172.19.0.2/16
test 172.19.0.4/16
```

`test` hängt jetzt in zwei Netzwerken (Standard-Bridge und `hello-net`) und hat in jedem eine eigene IP. `docker exec test cat /etc/resolv.conf` zeigt `nameserver 127.0.0.11`: den DNS-Server von Docker, der `backend` auflöst. Die Schritte 3 und 4 zeigt das Terminal-Bild in der Theorie.

## Aufgabe 5: Aufräumen

```bash
docker rm -f frontend backend test
docker network rm hello-net
```

```text
frontend
backend
test
hello-net
```

Im Ordner `playground` startet `docker compose up -d` die Hello-App wieder aus `compose.yml` (Stand Lab 3.3). Vergleich mit Compose: Netzwerk anlegen, Container hineinhängen, Namen vergeben und aufräumen erledigt Compose automatisch; das vertieft Lab 4.2.
