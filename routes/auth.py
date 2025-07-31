from flask import Blueprint, render_template, request, session, redirect
from utils.db import get_db

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/', methods=['GET', 'POST'])
def login():
    sql_preview = None
    error = None

    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        #Build vulnerable SQL statement (and capture it)
        query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
        sql_preview = query  # Store for display on page

        try:
            cur = get_db().cursor()
            cur.execute(query)
            user = cur.fetchone()

            if user:
                session['username'] = username
                return redirect('/profile')
            else:
                error = "Login failed"
        except Exception as e:
            error = f"SQL Error: {e}"

    return render_template("login.html", error=error, sql_preview=sql_preview)
