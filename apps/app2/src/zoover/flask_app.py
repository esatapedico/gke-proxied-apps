from flask import Flask
from flask_injector import FlaskInjector

app = Flask(__name__)


@app.route("/app2")
def health():
    return "I am a Python service for Rafael's Zoover DevOps application 👍"

@app.route("/")
def root():
    return "This is a random root so the top-level domain does not 404. Managed by Python."


FlaskInjector(app=app)
