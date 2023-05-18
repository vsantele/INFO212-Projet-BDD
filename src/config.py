from dotenv import load_dotenv
import os

load_dotenv()

DB_USER = os.getenv("DB_USER") or "mysqlUser"
DB_PASSWORD = os.getenv("DB_PASSWORD") or "mysqlPassword"
DB_HOST = os.getenv("DB_HOST") or "localhost"
DB_PORT = int(os.getenv("DB_PORT") or "3306")
DB_NAME = os.getenv("DB_NAME") or "CLICOM"
