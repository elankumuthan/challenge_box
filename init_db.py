import sqlite3
import os

DATABASE = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'users.db')

def init_db():
    if os.path.exists(DATABASE):
        print("[~] Existing database found. Deleting and recreating it...")
        os.remove(DATABASE)

    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()

    # Create tables
    cursor.execute('''
        CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
        )
    ''')

    cursor.execute('''
        CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            message TEXT NOT NULL
        )
    ''')

    # Insert initial test user
    cursor.execute('''
        INSERT INTO users (username, password) VALUES (?, ?)
    ''', ('admin', 'admin123'))

    conn.commit()
    conn.close()
    print("[+] Database initialized successfully.")

if __name__ == "__main__":
    init_db()
