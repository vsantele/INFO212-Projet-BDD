from database import Database
from retry import retry
from pays import Countries
from enum import Enum
from datetime import date


class User_choices(Enum):
    ADD_CLI = 1
    VENDEUR = 2
    CLIENT = 3
    COMPTA = 4
    QUIT = 5


class ClientChoices(Enum):
    VIEW_CLI = 1
    EDI_CLI = 2
    DELETE_CLI = 3
    ADD_BUY = 4
    SEE_INVOICE = 5
    SEE_PURCHASES = 6
    QUIT = 7


class VendeurChoices(Enum):
    MAKE_SELL = 1
    SHOW_INVOICE = 2
    SHOW_SELLS = 3
    QUIT = 4


COUNTRIES = [country.name for country in Countries()]


def print_user_menu():
    print("╔════════════════════╗")
    print("║        USER        ║")
    print("╠════════════════════╣")
    print("║ 1 - Ajouter client ║")
    print("║ 2 - Vendeur        ║")
    print("║ 3 - Client         ║")
    print("║ 4 - Servive compta ║")
    print("║ 5 - Quitter        ║")
    print("╚════════════════════╝")


def print_client_menu():
    print("╔══════════════════════════════════╗")
    print("║               MENU               ║")
    print("╠══════════════════════════════════╣")
    print("║ 1 - Afficher information client  ║")
    print("║ 2 - Modifier information client  ║")
    print("║ 3 - Supprimer client             ║")
    print("║ 4 - Effectuer un achat           ║")
    print("║ 5 - Afficher facture             ║")
    print("║ 6 - Afficher vos achats          ║")
    print("║ 7 - Quitter                      ║")
    print("╚══════════════════════════════════╝")


def print_vendeur_menu():
    print("╔══════════════════════════════════╗")
    print("║               MENU               ║")
    print("╠══════════════════════════════════╣")
    print("║ 1 - Effectuer une vente          ║")
    print("║ 2 - Afficher facture             ║")
    print("║ 3 - Afficher vos ventes          ║")
    print("║ 4 - Quitter                      ║")
    print("╚══════════════════════════════════╝")


def print_data(titles, data):
    to_print = [titles] + data
    form = ""
    for i in range(len(to_print[0])):
        form += "{" + str(i) + ":" + str(max_len(to_print, i)) + "}\t"
    for val in to_print:
        print(form.format(*val))


def max_len(data, index):
    return max([len(str(i[index])) for i in data])


@retry(ValueError)
def get_choice(min, max):
    choice = int(input("Entrez le numéro du choix que vous voulez effetuer : "))
    if choice < min or choice > max:
        raise ValueError
    else:
        return choice


@retry(ValueError)
def get_phone_number():
    phone_number = int(input("Entrez votre numéro de téléphone : "))
    if phone_number < 10000000 or phone_number > 9999999999:
        raise ValueError
    else:
        return phone_number


@retry(ValueError)
def get_country():
    country = input("Entrez votre pays : ")
    if country not in COUNTRIES:
        raise ValueError
    else:
        return country


@retry(ValueError)
def get_postal_code():
    postal_code = int(input("Entrez votre code postale : "))
    if postal_code < 1000 or postal_code > 9999999:
        raise ValueError
    else:
        return postal_code


@retry(ValueError)
def get_num(type):
    num_client = int(input("Entrez votre numéro " + type + "  : "))
    if num_client <= 0:
        raise ValueError
    else:
        return num_client


@retry(ValueError)
def get_quantite():
    quantite = int(input("Entrez la quantité désirée : "))
    if quantite <= 0:
        raise ValueError
    else:
        return quantite


@retry(ValueError)
def get_disque_db(db):
    disque = input("Entrez l'identifiant du disque souhaité : ")
    db.cursor.execute("select * from DISQUE where IdDisque = %s;", [disque])
    disque_db = [i for i in db.cursor]
    if len(disque_db) == 0:
        raise ValueError
    else:
        return disque


@retry(ValueError)
def get_employe_db(db):
    id_employe = int(
        input("Entrez l'identifiant de l'employé qui a effectué la vente : ")
    )
    db.cursor.execute("select * from EMPLOYE where Personne = %s;", [id_employe])
    employe_db = [i for i in db.cursor]
    if len(employe_db) == 0:
        raise ValueError
    else:
        return id_employe


@retry(ValueError)
def get_date():
    date_invoice = input("Entrez la date de la facture (AAAA-MM-JJ) : ")
    date_list = date_invoice.split("-")
    if len(date_list) != 3:
        raise ValueError
    else:
        return date(int(date_list[0]), int(date_list[1]), int(date_list[2]))
