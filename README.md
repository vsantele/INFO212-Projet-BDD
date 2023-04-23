# INFO212-Projet-BDD

## Installation

### Prérequis

- [Python 3] (https://www.python.org/downloads/)
- [Docker] (https://www.docker.com/products/docker-desktop)

### Développement

- Cloner le repo
- Créer un environnement virtuel

  ```bash
  python -m venv env
  ```

- Activer l'environnement virtuel

  ```bash
  # Linux/macos
  source env/bin/activate
  # Windows CMD
  env\Scripts\activate.bat
  # Windows PowerShell
  env\Scripts\Activate.ps1
  ```

- Installer les dépendances

  ```bash
  pip install -r requirements.txt
  ```

- Créer un fichier `.env` à la racine du projet avec le contenu suivant:

  ```bash
  cp .env.example .env
  ```

- Lancer le serveur de base de données

  ```bash
  docker compose up -d
  ```

- Lancer le script

  ```bash
  python src/main.py
  ```
