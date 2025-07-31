import sqlite3
from flask import g
import os

# Define the absolute path to users.db (always relative to project root)
DATABASE = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../users.db')

def get_db():
    """Returns a SQLite connection scoped to the request context (via Flask `g`)."""
    if '_database' not in g:
        g._database = sqlite3.connect(DATABASE)
    return g._database

def close_connection(exception=None):
    """Closes the database connection after request teardown."""
    db = g.pop('_database', None)
    if db is not None:
        db.close()
