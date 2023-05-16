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
            elif user_choice == utils.User_choices.CLIENT.value:
                connected, num_client = connect_client(db)
                if connected:
                    utils.print_client_menu()
                    client_choice = utils.get_choice(utils.Client_choices.VIEW_CLI.value, utils.Client_choices.QUIT.value)
                    is_deleted = False
                    while not is_deleted and client_choice != utils.Client_choices.QUIT.value:
                        if client_choice == utils.Client_choices.VIEW_CLI.value:
                            view_client(db, num_client)
                        elif client_choice == utils.Client_choices.EDI_CLI.value:
                            edit_client(db, num_client)
                        elif client_choice == utils.Client_choices.DELETE_CLI.value:
                            print("Supprimer client")
                        elif client_choice == utils.Client_choices.ADD_BUY.value:
                            make_purchase(db, num_client)
                        else:
                            print("Afficher Facture")
                        if not is_deleted:
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
    try:
        db.cursor.execute("insert into ADRESSE(Rue, CodePostal, Ville, Pays) values(%s,%s,%s,%s);", 
                        (street,postal_code,city,country))
        db.cursor.execute("insert into PERSONNE(Nom, Prenom, Telephone, Adresse) values(%s,%s,%s,last_insert_id());",
                        (name,first_name,phone_number))
        db.cursor.execute("insert into CLIENT(Personne) values(last_insert_id())")
        db.connection.commit()
    except:
        print("Erreur lors de l'insertion du client")
    else:
        print("Client Ajouté")

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
        db.cursor.execute("select * from INFO_CLIENT where NumClient = %s;", [num_client])
    except:
        print("Erreur lors de l'affichage")
    else:
        titles = ["Numéro Client", "Nom", "Prénom", "Téléphone", "Pays", "Ville", "Rue", "Code Postal"]
        data = []
        for NumClient, Nom, Prenom, Telephone, Pays, Ville, Rue, CodePostal in db.cursor:
            data.append([str(NumClient), Nom, Prenom, str(int(Telephone)), Pays, Ville, Rue, str(int(CodePostal))])
        utils.print_data(titles, data)

def edit_client(db, num_client):
    view_client(db, num_client)
    name, first_name, phone_number, country, city, street, postal_code = (None for i in range(7))
    res = input("Voulez vous modifier votre Nom ? (Y/N) : ")
    if res.upper() == "Y":
        name = input("Entrez votre nom : ")
    res = input("Voulez vous modifier votre Prénom ? (Y/N) : ")
    if res.upper() == "Y":
        first_name = input("Entrez votre prenom : ")
    res = input("Voulez vous modifier votre Numéro de Téléphone ? (Y/N) : ")
    if res.upper() == "Y":
        phone_number = utils.get_phone_number()
    res = input("Voulez vous modifier votre Pays ? (Y/N) : ")
    if res.upper() == "Y":
        country = utils.get_country()
    res = input("Voulez vous modifier votre Ville ? (Y/N) : ")
    if res.upper() == "Y":
        city = input("Entrez le nom de votre ville : ")
    res = input("Voulez vous modifier votre Rue ? (Y/N) : ")
    if res.upper() == "Y":
        street = input("Entrez votre rue : ")
    res = input("Voulez vous modifier votre Code Postal ? (Y/N) : ")
    if res.upper() == "Y":
        postal_code = utils.get_postal_code()
    try:
        db.cursor.execute("select c.Personne, p.Adresse from CLIENT c, PERSONNE p where c.NumClient = %s and c.Personne = p.IdPersonne;", [num_client])
        for i in db.cursor:
            id_personne = i[0]
            id_adresse = i[1]
        if name is not None:
            db.cursor.execute("update PERSONNE set Nom = %s where IdPersonne = %s", [name, id_personne])
        if first_name is not None:
            db.cursor.execute("update PERSONNE set Prenom = %s where IdPersonne = %s", [first_name, id_personne])
        if phone_number is not None:
            db.cursor.execute("update PERSONNE set Telephone = %s where IdPersonne = %s", [phone_number, id_personne])
        if country is not None:
            db.cursor.execute("update ADRESSE set Pays = %s where IdAdresse = %s", [country, id_adresse])
        if city is not None:
            db.cursor.execute("update ADRESSE set Ville = %s where IdAdresse = %s", [city, id_adresse])
        if street is not None:
            db.cursor.execute("update ADRESSE set Rue = %s where IdAdresse = %s", [street, id_adresse])
        if postal_code is not None:
            db.cursor.execute("update ADRESSE set CodePostal = %s where IdAdresse = %s", [postal_code, id_adresse])
        db.connection.commit()
    except:
        print("Erreur lors de la modification")
    else:
        print("Modification effectuée")
 
def make_purchase(db, num_client):
    disque = utils.get_disque_db(db)
    quantite = utils.get_quantite()
    id_employe = utils.get_employe_db(db)
    try:
        db.cursor.execute("insert into VENTE(Quantite, DateAchat, Disque, Client, Employe) values(%s, curdate(), %s, %s, %s)", [quantite, disque, num_client, id_employe])
        db.connection.commit()
    except:
        print("Erreur lors de l'achat")
    else:
        print("Achat effectué")



if __name__ == "__main__":
    main()

