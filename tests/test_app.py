import pytest
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import requests

from app import app


@pytest.fixture
def client():
    """Fixture pour initialiser un client de test Flask"""
    app.testing = True  # Met l'application en mode test
    with app.test_client() as client:
        yield client

def test_login_page(client):
    """Test de la route de connexion"""
    # Test GET de la page de connexion
    response = client.get('/login')
    assert response.status_code == 200

    # Test POST avec des données valides
    response = client.post('/login', data={
        'username': 'testuser',
        'password': 'testpassword'
    })
    assert response.status_code == 302  # Vérifie la redirection après une connexion réussie

    # Test POST avec des données invalides
    response = client.post('/login', data={
        'username': 'wronguser',  # Utilisateur incorrect
        'password': 'wrongpassword'
    })
    assert response.status_code == 302  # Redirection après une tentative échouée

def test_mlflow_connection():
    """Test si MLFlow est accessible"""
    try:
        response = requests.get("http://127.0.0.1:5001")
        assert response.status_code == 200
    except requests.ConnectionError:
        pytest.fail("MLFlow server is not running on http://127.0.0.1:5001")