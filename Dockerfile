# Utiliser l'image de base officielle de MLFlow
#FROM ghcr.io/mlflow/mlflow:v2.19.0
FROM python:3.9-slim

# Install required system dependencies
#RUN apt-get update && apt-get install -y \
#    libpq-dev \
#    build-essential

RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && rm -rf /var/lib/apt/lists/*
    #&& pip install psycopg2

# Mettre à jour pip et installer les dépendances à partir de requirements.txt
COPY requirements.txt /app/
WORKDIR /app
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

RUN python -c "import psycopg2"

COPY ./Algos/st_javaness /app/st_javaness

# Copier le code source dans le conteneur
COPY . /app/

# Exécuter les tests unitaires
RUN pytest --maxfail=1 --disable-warnings -q

# Assurer les bonnes permissions pour les fichiers du modèle
#RUN chmod -R 755 /app/st_javaness

#COPY DB_pco /app/DB_pco

# Exposer le port 5000 pour l'application web, 8001 pour api_data et 8000 pour api_model
EXPOSE 8001 8000 5000

# Commande pour démarrer l'application
CMD ["python", "app.py"]
#CMD ["mlflow", "server", "--backend-store-uri", "file:/app/mlruns", "--default-artifact-root", "/app/mlruns", "python", "app.py"]
