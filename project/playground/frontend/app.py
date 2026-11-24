"""Hello-Frontend: zeigt Version, Farbe, Container bzw. Pod und die Antwort des Backends.

Jede Einstellung kommt aus einer Umgebungsvariablen (Standardwert in Klammern):
  APP_VERSION   angezeigte Version                       (v1)
  APP_COLOR     Hintergrundfarbe der Seite               (lightblue)
  BACKEND_URL   Adresse des Backends                     (http://localhost:8081)
  PORT          Port, auf dem der Webserver lauscht      (80)
  DATA_DIR      Ordner für access.log                    (/data)
  SECRET_FILE   Datei mit dem Admin-Passwort             (/etc/hello-secret/admin-password)
  STARTUP_DELAY Sekunden Wartezeit vor dem Start         (0)
"""

import os
import socket
import time
from datetime import datetime

import requests
from flask import Flask

APP_VERSION = os.getenv("APP_VERSION", "v1")
APP_COLOR = os.getenv("APP_COLOR", "lightblue")
BACKEND_URL = os.getenv("BACKEND_URL", "http://localhost:8081")
PORT = int(os.getenv("PORT", "80"))
DATA_DIR = os.getenv("DATA_DIR", "/data")
SECRET_FILE = os.getenv("SECRET_FILE", "/etc/hello-secret/admin-password")
STARTUP_DELAY = int(os.getenv("STARTUP_DELAY", "0"))

POD_NAME = socket.gethostname()                 # im Pod: Name des Pods
POD_IP = socket.gethostbyname(POD_NAME)         # im Pod: IP des Pods

app = Flask(__name__)
healthy = True                                  # wird über /fail und /recover umgeschaltet


def write_access_log():
    """Hängt eine Zeile an DATA_DIR/access.log an."""
    os.makedirs(DATA_DIR, exist_ok=True)
    with open(os.path.join(DATA_DIR, "access.log"), "a") as f:
        f.write(f"{datetime.now().isoformat(timespec='seconds')} {POD_NAME} {POD_IP} {APP_VERSION}\n")


def ask_backend():
    """Fragt das Backend; bei Fehler kommt ein Hinweistext statt eines Absturzes."""
    try:
        r = requests.get(BACKEND_URL, timeout=2)
        data = r.json()
        return f"{data['pod']} ({data['ip']}) um {data['time']}"
    except Exception as e:
        return f"Backend nicht erreichbar ({BACKEND_URL}): {type(e).__name__}"


def password_status():
    """Liest nur, ob ein Passwort gesetzt ist; der Wert selbst wird nie angezeigt."""
    try:
        with open(SECRET_FILE) as f:
            return "Passwort gesetzt" if f.read().strip() else "Passwort leer"
    except FileNotFoundError:
        return "kein Passwort gesetzt"


@app.route("/")
def index():
    write_access_log()
    return f"""<!doctype html>
<html lang="de">
<head><meta charset="utf-8"><title>Hello-App {APP_VERSION}</title></head>
<body style="background:{APP_COLOR}; font-family:sans-serif; padding:2rem;">
  <h1>Hello-App {APP_VERSION}</h1>
  <p><b>Frontend:</b> {POD_NAME} ({POD_IP})</p>
  <p><b>Backend:</b> {ask_backend()}</p>
  <p><b>Admin:</b> {password_status()}</p>
</body>
</html>"""


@app.route("/healthz")
def healthz():
    """Health-Endpunkt für Healthchecks und Probes (Lab 3.2, Lab 8.4); prüft nur das Frontend selbst."""
    return ("ok", 200) if healthy else ("simulierter Ausfall", 500)


@app.route("/fail")
def fail():
    """Simuliert einen Ausfall: /healthz antwortet ab jetzt mit 500."""
    global healthy
    healthy = False
    return f"{POD_NAME}: /healthz meldet jetzt 500\n"


@app.route("/recover")
def recover():
    global healthy
    healthy = True
    return f"{POD_NAME}: /healthz meldet wieder 200\n"


@app.route("/work")
def work():
    """Erzeugt etwa 0,2 Sekunden CPU-Last je Aufruf (Lab 8.5)."""
    end = time.time() + 0.2
    n = 0
    while time.time() < end:
        n += 1
    return f"{POD_NAME}: {n} Schleifen\n"


if __name__ == "__main__":
    if STARTUP_DELAY:
        print(f"Starte in {STARTUP_DELAY} Sekunden ...", flush=True)
        time.sleep(STARTUP_DELAY)
    print(f"Hello-Frontend {APP_VERSION} auf Port {PORT}, Backend: {BACKEND_URL}", flush=True)
    app.run(host="0.0.0.0", port=PORT)
