from flask import Flask
import os
from utils.db import get_db, close_connection

#Import your route blueprints
from routes.auth import auth_bp
from routes.profile import profile_bp

# 🔧 Optional: Explicit DB path if needed
DATABASE = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'users.db')

#Create and configure the Flask app
def create_app():
    app = Flask(__name__)
    app.secret_key = 'supersecretkey'  #Change for production

    # Register route blueprints
    app.register_blueprint(auth_bp)
    app.register_blueprint(profile_bp)

    # Automatically close DB connection after request
    app.teardown_appcontext(close_connection)

    return app

#Entry point for Docker or CLI
if __name__ == '__main__':
    app = create_app()
    app.run(host='0.0.0.0', port=80)
