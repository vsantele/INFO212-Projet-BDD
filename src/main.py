from database import Database

db = Database()
from database import Database
import utils

def main():
    try:
        db = Database()
    except:
        print("Impossible de se connecter à la base de données")
    else:
        utils.print_user_menu()
        user_choice = utils.get_choice(utils.User_choices.ADD_CLI.value, utils.User_choices.QUIT.value)
        while user_choice != utils.User_choices.QUIT.value:
            if user_choice == utils.User_choices.ADD_CLI.value:
                add_client(db)
            elif user_choice == utils.User_choices.DELETE_CLI.value:
                delete_client(db, num_client)
            elif user_choice == utils.User_choices.CLIENT.value:
                connected, num_client = connect_client(db)
                if connected:
                    utils.print_client_menu()
                    client_choice = utils.get_choice(utils.Client_choices.VIEW_CLI.value, utils.Client_choices.QUIT.value)
                    while client_choice != utils.Client_choices.QUIT.value:
                        if client_choice == utils.Client_choices.VIEW_CLI.value:
                            view_client(db, num_client)
                        elif client_choice == utils.Client_choices.EDI_CLI.value:
                            print("Modifier Client")
                        elif client_choice == utils.Client_choices.DELETE_CLI.value:
                            print("Supprimer Client")
                        elif client_choice == utils.Client_choices.ADD_BUY.value:
                            print("Effectuer un achat")
                        elif client_choice == utils.Client_choices.SEE_INVOICE.value:
                            date = input("Entrez la date de la facture (AAAA-MM-JJ) : ")
                            see_invoice(db, num_client, date)
                        elif client_choice == utils.Client_choices.SEE_PURCHASES.value:
                            see_purchases(db, num_client)
                        else:
                            print("Afficher Facture")
                        utils.print_client_menu()
                        client_choice = utils.get_choice(utils.Client_choices.VIEW_CLI.value, utils.Client_choices.QUIT.value)
            elif user_choice == utils.User_choices.COMPTA.value:
                print("Service compta")
            utils.print_user_menu()
            user_choice = utils.get_choice(utils.User_choices.ADD_CLI.value, utils.User_choices.QUIT.value)
        db.close()

def add_client(db):
    name = input("Entrez votre nom : ")
    first_name = input("Entrez votre prenom : ")
    phone_number = utils.get_phone_number()
    country = utils.get_country()
    city = input("Entrez le nom de votre ville : ")
    street = input("Entrez votre rue : ")
    postal_code = utils.get_postal_code()
    client_id = None
    try:
        db.cursor.execute("insert into ADRESSE(Rue, CodePostal, Ville, Pays) values(%s,%s,%s,%s);", 
                        (street,postal_code,city,country))
        db.cursor.execute("insert into PERSONNE(Nom, Prenom, Telephone, Adresse) values(%s,%s,%s,last_insert_id());",
                        (name,first_name,phone_number))
        db.cursor.execute("insert into CLIENT(Personne) values(last_insert_id());")
        db.connection.commit()
        db.cursor.execute("select last_insert_id();")
        for i in db.cursor:
            client_id = i[0]
    except:
        print("Erreur lors de l'insertion du client")
    else:
        print("Client Ajouté avec l'ID " + str(client_id))

def connect_client(db):
    num_client = utils.get_num_client()
    try:
        db.cursor.execute("select * from CLIENT where NumClient = %s", [num_client])
    except:
        print("Erreur lors de la connection")
        return (False, 0)
    else:
        if len(list(db.cursor)) == 0:
            print("Numéro client invalide")
            return (False, 0)
        else:
            print("Connecté")
            return (True, num_client)

def view_client(db, num_client):  
    try: 
        db.cursor.execute("select c.NumClient, p.Nom, p.Prenom, p.Telephone, a.Pays, \
                          a.Ville, a.Rue, a.CodePostal from client c, Personne p, \
                          Adresse a where c.NumClient = %s and c.Personne = \
                          p.IdPersonne and p.Adresse = a.IdAdresse;", [num_client])
    except:
        print("Erreur lors de l'affichage")
    else:
        titles = ["Numéro Client", "Nom", "Prénom", "Téléphone", "Pays", "Ville", "Rue", "Code Postal"]
        data = []
        for NumClient, Nom, Prenom, Telephone, Pays, Ville, Rue, CodePostal in db.cursor:
            data.append([str(NumClient), Nom, Prenom, str(int(Telephone)), Pays, Ville, Rue, str(int(CodePostal))])
        utils.print_data(titles, data)



if __name__ == "__main__":
    main()
    
    
def see_invoice(db, num_client, date):
    try:
        db.cursor.execute("SELECT Numero, Nom, Prenom, IdDisque, DateAchat, Quantite, PrixTotal FROM facture WHERE NumClient = %s AND Date Achat = %s;", [num_client, date])
    except:
        print("Erreur lors de l'affichage de la facture.")
    else:
        titles = ["Numéro", "Nom", "Prénom", "ID Disque", "Date Achat", "Quantité", "Prix Total"]
        data = []
        for row in db.cursor:
            data.append([str(row[0]), row[1], row[2], str(row[3]), str(row[4]), str(row[5]), str(row[6])])
        utils.print_data(titles, data)
        
        
        
 def delete_client(db, num_client):
    try:
        db.cursor.execute("DELETE * FROM CLIENT WHERE NumClient = %s;", [num_client])
        db.connection.commit()
        print("Client supprimé avec succès.")
    except:
        print("Erreur lors de la suppression du client.")
        
        
def see_purchases(db, num_client):
    try:
        db.cursor.execute("SELECT Numero, Quantite, DateAchat, IdDisque FROM vente WHERE NumClient = %s;", [num_client])
    except:
        print("Erreur lors de l'affichage des achats.")
    else:
        titles = ["Numéro", "Quantité", "Date d'Achat", "ID Disque"]
        data = []
        for Numero, Quantite, DateAchat, IdDisque in db.cursor:
            data.append([str(Numero), str(Quantite), str(DateAchat), str(IdDisque)])
        utils.print_data(titles, data)

