# importation des variables de connexion
from . import DBNAME, USER, PASSWORD, HOST
# importation des bibliothèques externes
import psycopg2

class EnemyDataAccess:
    """
    Classe pour accéder aux données des ennemis.

    Attributes:
        conn: Objet de connexion à la base de données.
        cur: Curseur pour exécuter des requêtes SQL.
    """

    def __init__(self):
        try:
            self.conn = psycopg2.connect(
                dbname=DBNAME,
                user=USER,
                password=PASSWORD,
                host=HOST
            )
            self.cur = self.conn.cursor()
        except Exception as e:
            print(f"Erreur connexion à la base de données: {e}")

    def get_all_enemies(self):
        """
        Récupère tous les ennemis.
        
        Retourne:
            Une liste contenant tous les ennemis.
        """
        try:
            self.cur.execute("SELECT * FROM enemy")
            rows = self.cur.fetchall()
            return rows
        except Exception as e:
            print(f"Erreur en essayant de récupérer tous les ennemis: {e}")
            # Handle the exception appropriately, e.g., log and/or raise
        finally:
            self.close_connection()

    def get_enemy_by_id(self, enemy_id):
        """
        Récupère un ennemi par son ID.

        Args:
            enemy_id (int): L'ID de l'ennemi.
        
        Retourne:
            Un ennemi.
        """
        try:
            self.cur.execute("SELECT * FROM enemy WHERE id = %s", (enemy_id,))
            row = self.cur.fetchone()
            return row
        except Exception as e:
            print(f"Erreur en essayant de récupérer l'ennemi par son ID: {e}")

        finally:
            self.close_connection()

    def close_connection(self):
        """
        Ferme la connexion à la base de données.
        """
        if self.cur:
            self.cur.close()
        if self.conn:
            self.conn.close()

if __name__ == "__main__":
    print("test de EnemyDataAccess:")
    enemy_data_access = EnemyDataAccess()
    print(enemy_data_access.get_all_enemies())
    print(enemy_data_access.get_enemy_by_id(1))
    print(enemy_data_access.get_enemy_by_id(2))