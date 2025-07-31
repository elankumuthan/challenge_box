FROM python:3.11-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Run Python script to initialize DB
RUN python init_db.py

EXPOSE 80

CMD ["python", "main.py"]
