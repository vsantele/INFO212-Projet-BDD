from database import Database
import utils


def main():
    try:
        db = Database()
    except Exception:
        print("Impossible de se connecter à la base de données")
    else:
        view_shops()
        num_shop = utils.get_num("magasin")
        print()
        utils.print_user_menu()
        user_choice = utils.get_choice(
            utils.User_choices.ADD_CLI.value, utils.User_choices.QUIT.value
        )
        while user_choice != utils.User_choices.QUIT.value:
            if user_choice == utils.User_choices.ADD_CLI.value:
                add_client()
            elif user_choice == utils.User_choices.CLIENT.value:
                view_clients()
                connected, num_client = connect_client()
                if connected:
                    utils.print_client_menu()
                    client_choice = utils.get_choice(
                        utils.ClientChoices.VIEW_CLI.value,
                        utils.ClientChoices.QUIT.value,
                    )
                    is_deleted = False
                    while (
                        not is_deleted
                        and client_choice != utils.ClientChoices.QUIT.value
                    ):
                        if client_choice == utils.ClientChoices.VIEW_CLI.value:
                            view_client(num_client)
                        elif client_choice == utils.ClientChoices.EDI_CLI.value:
                            edit_client(num_client)
                        elif client_choice == utils.ClientChoices.DELETE_CLI.value:
                            is_deleted = delete_client(num_client)
                        elif client_choice == utils.ClientChoices.ADD_BUY.value:
                            view_sons()
                            view_albums()
                            make_purchase(num_client)
                        elif client_choice == utils.ClientChoices.SEE_INVOICE.value:
                            see_invoice(num_client)
                        else:
                            see_purchases(num_client)
                        if not is_deleted:
                            utils.print_client_menu()
                            client_choice = utils.get_choice(
                                utils.ClientChoices.VIEW_CLI.value,
                                utils.ClientChoices.QUIT.value,
                            )
            elif user_choice == utils.User_choices.COMPTA.value:
                print("Service compta")
            elif user_choice == utils.User_choices.VENDEUR.value:
                view_sellers(num_shop)
                connected, num_vendeur = connect_vendeur()
                if connected:
                    utils.print_vendeur_menu()
                    vendeur_choice = utils.get_choice(
                        utils.VendeurChoices.MAKE_SELL.value,
                        utils.VendeurChoices.QUIT.value,
                    )
                    while vendeur_choice != utils.VendeurChoices.QUIT.value:
                        if vendeur_choice == utils.VendeurChoices.MAKE_SELL.value:
                            view_sons(num_shop)
                            view_albums(num_shop)
                            make_sale(num_vendeur)
                        elif vendeur_choice == utils.VendeurChoices.SHOW_INVOICE:
                            view_invoice(num_vendeur)
                        elif vendeur_choice == utils.VendeurChoices.SHOW_SELLS:
                            view_sells(num_vendeur)
                        utils.print_vendeur_menu()
                        vendeur_choice = utils.get_choice(
                            utils.VendeurChoices.MAKE_SELL.value,
                            utils.VendeurChoices.QUIT.value,
                        )
                print("Vendeur")
            utils.print_user_menu()
            user_choice = utils.get_choice(
                utils.User_choices.ADD_CLI.value, utils.User_choices.QUIT.value
            )

        db.close()


def add_client():
    db = Database()
    name = input("Entrez votre nom : ")
    first_name = input("Entrez votre prenom : ")
    phone_number = utils.get_phone_number()
    country = utils.get_country()
    city = input("Entrez le nom de votre ville : ")
    street = input("Entrez votre rue : ")
    postal_code = utils.get_postal_code()
    try:
        db.cursor.execute(
            "insert into ADRESSE(Rue, CodePostal, Ville, Pays) values(%s,%s,%s,%s);",
            (street, postal_code, city, country),
        )
        db.cursor.execute(
            "insert into PERSONNE(Nom, Prenom, Telephone, Adresse) values(%s,%s,%s,last_insert_id());",
            (name, first_name, phone_number),
        )
        db.cursor.execute("insert into CLIENT(Personne) values(last_insert_id())")
        db.connection.commit()
    except:
        print("Erreur lors de l'insertion du client")
    else:
        print("Client Ajouté")


def connect_client():
    db = Database()
    num_client = utils.get_num("client")
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


def connect_vendeur():
    db = Database()
    num_vendeur = utils.get_num("vendeur")
    try:
        db.cursor.execute("select * from EMPLOYE  where Personne = %s", [num_vendeur])
    except:
        print("Erreur lors de la connection")
        return (False, 0)
    else:
        if len(list(db.cursor)) == 0:
            print("Numéro client invalide")
            return (False, 0)
        else:
            print("Connecté")
            return (True, num_vendeur)


def view_client(num_client):
    db = Database()
    try:
        db.cursor.execute(
            "select * from INFO_CLIENT where NumClient = %s;", [num_client]
        )
    except Exception:
        print("Erreur lors de l'affichage du client")
    else:
        titles = [
            "Numéro Client",
            "Nom",
            "Prénom",
            "Téléphone",
            "Pays",
            "Ville",
            "Rue",
            "Code Postal",
        ]
        data = db.cursor.fetchone()

        utils.print_data(titles, [data])


def view_clients():
    db = Database()
    try:
        db.cursor.execute("select * from INFO_CLIENT;")
        clients = db.cursor.fetchall()
        print("Clients: ")
        utils.print_data(
            [
                "Numéro Client",
                "Nom",
                "Prénom",
                "Téléphone",
                "Pays",
                "Ville",
                "Rue",
                "Code Postal",
            ],
            clients,
        )
    except Exception:
        print("Erreur lors de l'affichage des clients")


def view_shops():
    db = Database()
    try:
        db.cursor.execute(
            "select m.IdMagasin, m.Nom, a.Rue, a.CodePostal, a.Ville, a.Pays  from MAGASIN m JOIN ADRESSE a ON m.Adresse = a.IdAdresse;"
        )
        magasins = db.cursor.fetchall()
        print("Magasins: ")
        utils.print_data(
            [
                "Numéro",
                "Nom",
                "Rue",
                "Code Postal",
                "Ville",
                "Pays",
            ],
            magasins,
        )
    except Exception:
        print("Erreur lors de l'affichage des magasins")


def view_sellers(num_shop):
    db = Database()
    try:
        db.cursor.execute(
            "select p.IdPersonne, p.Nom, p.Prenom  from EMPLOYE e JOIN PERSONNE p ON p.IdPersonne = e.Personne WHERE e.Magasin = %s;",
            [num_shop],
        )
        sellers = db.cursor.fetchall()
        print("Clients: ")
        utils.print_data(
            ["Numéro", "Nom", "Prénom"],
            sellers,
        )
    except Exception:
        print("Erreur lors de l'affichage des vendeurs")


def view_sons(num_shop):
    db = Database()
    try:
        db.cursor.execute(
            "select d.IdDisque, s.Titre, s.Genre1, s.Genre2, s.Genre3, s.Genre4, s.Genre5, d.PrixVente from DISQUESINGLE ds JOIN SON s ON s.NumSon = ds.Son JOIN DISQUE d ON d.IdDisque = ds.Disque JOIN STOCK st on st.Disque = d.IdDisque WHERE st.Magasin = %s AND st.Quantite > 0;",
            [num_shop],
        )
        disques = db.cursor.fetchall()
        disques = [(d[0], d[1], ", ".join(filter(None, d[-5:-1])), d[7]) for d in disques]  # type: ignore
        print("Disques singles: ")
        utils.print_data(
            [
                "Numéro",
                "Titre",
                "Genres",
                "Prix vente",
            ],
            disques,
        )
    except Exception as e:
        print(e)
        print("Erreur lors de l'affichage des disques")


def view_albums(num_shop):
    db = Database()
    try:
        db.cursor.execute(
            "select d.IdDisque, a.Titre, a.Genre1, a.Genre2, a.Genre3, a.Genre4, a.Genre5, d.PrixVente from DISQUEALBUM da JOIN ALBUM a ON a.NumAlbum = da.Album JOIN DISQUE d ON d.IdDisque = ds.Disque JOIN STOCK st on st.Disque = d.IdDisque WHERE st.Magasin = %s AND st.Quantite > 0;"
        )
        disques = db.cursor.fetchall()
        disques = [(d[0], d[1], ", ".join(filter(None, d[-5:-1])), d[7]) for d in disques]  # type: ignore
        print("Disques albums: ")
        utils.print_data(
            [
                "Numéro",
                "Titre",
                "Genres",
                "Prix vente",
            ],
            disques,
        )
    except Exception:
        print("Erreur lors de l'affichage des disques")


def edit_client(num_client):
    db = Database()
    view_client(num_client)
    name, first_name, phone_number, country, city, street, postal_code = (
        None for i in range(7)
    )
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
        db.cursor.execute(
            "select c.Personne, p.Adresse from CLIENT c, PERSONNE p where c.NumClient = %s and c.Personne = p.IdPersonne;",
            [num_client],
        )
        for i in db.cursor:
            id_personne = i[0]
            id_adresse = i[1]
        if name is not None:
            db.cursor.execute(
                "update PERSONNE set Nom = %s where IdPersonne = %s",
                [name, id_personne],
            )
        if first_name is not None:
            db.cursor.execute(
                "update PERSONNE set Prenom = %s where IdPersonne = %s",
                [first_name, id_personne],
            )
        if phone_number is not None:
            db.cursor.execute(
                "update PERSONNE set Telephone = %s where IdPersonne = %s",
                [phone_number, id_personne],
            )
        if country is not None:
            db.cursor.execute(
                "update ADRESSE set Pays = %s where IdAdresse = %s",
                [country, id_adresse],
            )
        if city is not None:
            db.cursor.execute(
                "update ADRESSE set Ville = %s where IdAdresse = %s", [city, id_adresse]
            )
        if street is not None:
            db.cursor.execute(
                "update ADRESSE set Rue = %s where IdAdresse = %s", [street, id_adresse]
            )
        if postal_code is not None:
            db.cursor.execute(
                "update ADRESSE set CodePostal = %s where IdAdresse = %s",
                [postal_code, id_adresse],
            )
        db.connection.commit()
    except:
        print("Erreur lors de la modification")
    else:
        print("Modification effectuée")


def make_purchase(num_client):
    db = Database()
    disque = utils.get_disque_db(db)
    quantite = utils.get_quantite()
    id_employe = utils.get_employe_db(db)
    try:
        db.cursor.execute(
            "insert into VENTE(Quantite, DateAchat, Disque, Client, Employe) values(%s, curdate(), %s, %s, %s)",
            [quantite, disque, num_client, id_employe],
        )
        db.connection.commit()
    except:
        print("Erreur lors de l'achat")
    else:
        print("Achat effectué")


def see_invoice(num_client):
    db = Database()
    date_invoice = utils.get_date()
    try:
        db.cursor.execute(
            "select Numero, Nom, Prenom, IdDisque, DateAchat, Quantite, PrixTotal FROM FACTURE WHERE NumClient = %s AND DateAchat = %s;",
            [num_client, str(date_invoice)],
        )
    except:
        print("Erreur lors de l'affichage de la facture.")
    else:
        titles = [
            "Numéro",
            "Nom",
            "Prénom",
            "ID Disque",
            "Date Achat",
            "Quantité",
            "Prix Total",
        ]
        data = []
        for row in db.cursor:
            data.append(
                [
                    str(row[0]),
                    row[1],
                    row[2],
                    str(row[3]),
                    str(row[4]),
                    str(row[5]),
                    str(row[6]),
                ]
            )
        if len(data) == 0:
            print("Pas de facture pour cette date")
        else:
            utils.print_data(titles, data)


def delete_client(num_client):
    db = Database()
    res = input("Voulez-vous vraiment supprimer vos informations ? (Y/N) : ")
    if res.upper() == "Y":
        try:
            db.cursor.execute(
                "select c.Personne, p.Adresse from CLIENT c, PERSONNE p where c.NumClient = %s and c.Personne = p.IdPersonne;",
                [num_client],
            )
            for i in db.cursor:
                id_personne = i[0]
                id_adresse = i[1]
            db.cursor.execute(
                "update VENTE set Client = null where Client = %s;", [num_client]
            )
            db.cursor.execute("delete from CLIENT where NumClient = %s;", [num_client])
            db.cursor.execute(
                "select count(*) from EMPLOYE where Personne = %s;", [id_personne]
            )
            for i in db.cursor:
                nb_employe = i[0]
            if nb_employe == 0:
                db.cursor.execute(
                    "delete from PERSONNE where IdPersonne = %s;", [id_personne]
                )
                db.cursor.execute(
                    "select count(*) from PERSONNE where Adresse = %s;", [id_adresse]
                )
                for i in db.cursor:
                    nb_personne = i[0]
                if nb_personne == 0:
                    db.cursor.execute(
                        "delete from ADRESSE where IdAdresse = %s;", [id_adresse]
                    )
            db.connection.commit()
        except:
            print("Erreur lors de la suppression")
            return False
        else:
            print("Client supprimé")
            return True
    else:
        return False


def see_purchases(num_client):
    db = Database()
    try:
        db.cursor.execute(
            "SELECT Numero, Quantite, DateAchat, Disque FROM VENTE WHERE Client = %s;",
            [num_client],
        )
    except:
        print("Erreur lors de l'affichage des achats.")
    else:
        titles = ["Numéro", "Quantité", "Date d'Achat", "ID Disque"]
        data = []
        for Numero, Quantite, DateAchat, IdDisque in db.cursor:
            data.append([str(Numero), str(Quantite), str(DateAchat), str(IdDisque)])
        if len(data) == 0:
            print("Vous n'avez aucun achats")
        else:
            utils.print_data(titles, data)


if __name__ == "__main__":
    main()
