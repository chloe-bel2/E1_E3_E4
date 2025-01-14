FROM python:3.9-slim

RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/

WORKDIR /app

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

RUN python -c "import psycopg2"

COPY ./Algos/st_javaness /app/st_javaness

COPY . /app/

EXPOSE 8001 8000 5000

CMD ["python", "app.py"]
