from flask import Blueprint, render_template, request, redirect, session
from utils.db import get_db 


profile_bp = Blueprint('profile', __name__)

@profile_bp.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'username' not in session:
        return redirect('/')

    db = get_db()
    username = session['username']

    if request.method == 'POST':
        message = request.form['message']
        db.execute("INSERT INTO messages (username, message) VALUES (?, ?)", (username, message))
        db.commit()

    cur = db.cursor()
    cur.execute("SELECT message FROM messages WHERE username = ?", (username,))
    messages = cur.fetchall()

    return render_template("profile.html", username=username, messages=messages)
