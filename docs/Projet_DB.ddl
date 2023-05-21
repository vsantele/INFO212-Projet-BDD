-- *********************************************
-- * Standard SQL generation                   
-- *--------------------------------------------
-- * DB-MAIN version: 11.0.2              
-- * Generator date: Sep 14 2021              
-- * Generation date: Sun May 21 21:51:03 2023 
-- * LUN file: C:\Users\yboun\OneDrive\Bureau\leDB\INFO212-Projet-BDD\docs\Projet_DB.lun 
-- * Schema: Projet DB/SQL1 
-- ********************************************* 


-- Database Section
-- ________________ 

create database Projet DB;


-- DBSpace Section
-- _______________


-- Tables Section
-- _____________ 

create table ADRESSE (
     IdAdresse varchar(1) not null,
     Rue varchar(1) not null,
     CodePostal numeric(1) not null,
     Ville varchar(1) not null,
     Pays varchar(1) not null,
     constraint ID_ADRESSE_ID primary key (IdAdresse));

create table ALBUM (
     NumAlbum numeric(1) not null,
     Titre char(1) not null,
     Genre1 char(1) not null,
     Genre2 char(1),
     Genre3 char(1),
     Genre4 char(1),
     Genre5 char(1),
     Id char(1) not null,
     constraint ID_ALBUM_ID primary key (NumAlbum));

create table Appartient (
     NumAlbum numeric(1) not null,
     NumSon numeric(1) not null,
     constraint ID_Appartient_ID primary key (NumAlbum, NumSon));

create table ARTISTE (
     Id char(1) not null,
     NomArtiste varchar(1) not null,
     estGroupe char not null,
     Groupe_ char(1),
     constraint ID_ARTISTE_ID primary key (Id));

create table CLIENT (
     NumClient char(1) not null,
     IdPersonne numeric(1) not null,
     constraint ID_CLIENT_ID primary key (NumClient),
     constraint SID_CLIEN_PERSO_ID unique (IdPersonne));

create table Commande (
     ID_Com -- Sequence attribute not implemented -- not null,
     Date_livraison char(1) not null,
     Date_Commande char(1) not null,
     Quantite -- Compound attribute -- not null,
     IdMagasin numeric(1) not null,
     ID_Fou numeric(10) not null,
     constraint ID_Commande_ID primary key (ID_Com));

create table Contenu (
     ID_Com numeric(10) not null,
     IdDisque char(1) not null,
     constraint ID_Contenu_ID primary key (IdDisque, ID_Com));

create table DISQUE (
     IdDisque char(1) not null,
     PrixVente char(1) not null,
     PrixAchat char(1) not null,
     DISQUESINGLE char(1),
     DISQUEALBUM char(1),
     ID_Fou numeric(10) not null,
     constraint ID_DISQUE_ID primary key (IdDisque));

create table DISQUEALBUM (
     IdDisque char(1) not null,
     NumAlbum numeric(1) not null,
     constraint ID_DISQU_DISQU_1_ID primary key (IdDisque),
     constraint SID_DISQU_ALBUM_ID unique (NumAlbum));

create table DISQUESINGLE (
     IdDisque char(1) not null,
     NumSon numeric(1) not null,
     constraint ID_DISQU_DISQU_ID primary key (IdDisque),
     constraint SID_DISQU_SON_ID unique (NumSon));

create table EMPLOYE (
     IdPersonne numeric(1) not null,
     Email char(1) not null,
     Salaire numeric(1) not null,
     IdMagasin numeric(1) not null,
     constraint ID_EMPLO_PERSO_ID primary key (IdPersonne));

create table FACTURE (
     Reference -- Compound attribute -- not null,
     DateAchat char(1) not null,
     PrixTotal char(1) not null,
     constraint ID_FACTURE_ID primary key (Reference -- Compound attribute --));

create table Fournisseur (
     ID_Fou -- Sequence attribute not implemented -- not null,
     Nom char(1) not null,
     constraint ID_Fournisseur_ID primary key (ID_Fou));

create table GERANT (
     IdMagasin numeric(1) not null,
     VoitureSociete char not null,
     constraint SID_GERAN_MAGAS_ID unique (IdMagasin));

create table Interprete (
     Id char(1) not null,
     NumSon numeric(1) not null,
     constraint ID_Interprete_ID primary key (NumSon, Id));

create table MAGASIN (
     IdMagasin numeric(1) not null,
     Nom varchar(1) not null,
     Telephone numeric(1) not null,
     IdAdresse varchar(1),
     constraint ID_MAGASIN_ID primary key (IdMagasin));

create table PERSONNE (
     IdPersonne numeric(1) not null,
     Nom varchar(1) not null,
     Prenom varchar(1) not null,
     Telephone numeric(1) not null,
     IdAdresse varchar(1),
     constraint ID_PERSONNE_ID primary key (IdPersonne));

create table PRODUCTEUR (
     Id char(1) not null,
     constraint ID_PRODU_ARTIS_ID primary key (Id));

create table Produit (
     Id char(1) not null,
     NumSon numeric(1) not null,
     constraint ID_Produit_ID primary key (NumSon, Id));

create table SON (
     NumSon numeric(1) not null,
     Titre varchar(1) not null,
     DureeSec numeric(1) not null,
     Genre1 varchar(1) not null,
     Genre2 varchar(1),
     Genre3 varchar(1),
     Genre4 varchar(1),
     Genre5 varchar(1),
     Remix_ numeric(1) not null,
     constraint ID_SON_ID primary key (NumSon));

create table Stocke (
     IdDisque char(1) not null,
     IdMagasin numeric(1) not null,
     Quantite char(1) not null,
     constraint ID_Stocke_ID primary key (IdMagasin, IdDisque));

create table Vente (
     Numero char(1) not null,
     Quantite char(1) not null,
     DateAchat date not null,
     IdDisque char(1) not null,
     NumClient char(1) not null,
     IdPersonne numeric(1) not null,
     constraint ID_Vente_ID primary key (Numero));


-- Constraints Section
-- ___________________ 

alter table ALBUM add constraint ID_ALBUM_CHK
     check(exists(select * from Appartient
                  where Appartient.NumAlbum = NumAlbum)); 

alter table ALBUM add constraint REF_ALBUM_ARTIS_FK
     foreign key (Id)
     references ARTISTE;

alter table Appartient add constraint REF_Appar_SON_FK
     foreign key (NumSon)
     references SON;

alter table Appartient add constraint EQU_Appar_ALBUM
     foreign key (NumAlbum)
     references ALBUM;

alter table ARTISTE add constraint REF_ARTIS_ARTIS_FK
     foreign key (Groupe_)
     references ARTISTE;

alter table CLIENT add constraint SID_CLIEN_PERSO_FK
     foreign key (IdPersonne)
     references PERSONNE;

alter table Commande add constraint ID_Commande_CHK
     check(exists(select * from Contenu
                  where Contenu.ID_Com = ID_Com)); 

alter table Commande add constraint REF_Comma_MAGAS_FK
     foreign key (IdMagasin)
     references MAGASIN;

alter table Commande add constraint REF_Comma_Fourn_FK
     foreign key (ID_Fou)
     references Fournisseur;

alter table Contenu add constraint REF_Conte_DISQU
     foreign key (IdDisque)
     references DISQUE;

alter table Contenu add constraint EQU_Conte_Comma_FK
     foreign key (ID_Com)
     references Commande;

alter table DISQUE add constraint EXCL_DISQUE
     check((DISQUEALBUM is not null and DISQUESINGLE is null)
           or (DISQUEALBUM is null and DISQUESINGLE is not null)
           or (DISQUEALBUM is null and DISQUESINGLE is null)); 

alter table DISQUE add constraint REF_DISQU_Fourn_FK
     foreign key (ID_Fou)
     references Fournisseur;

alter table DISQUEALBUM add constraint ID_DISQU_DISQU_1_FK
     foreign key (IdDisque)
     references DISQUE;

alter table DISQUEALBUM add constraint SID_DISQU_ALBUM_FK
     foreign key (NumAlbum)
     references ALBUM;

alter table DISQUESINGLE add constraint ID_DISQU_DISQU_FK
     foreign key (IdDisque)
     references DISQUE;

alter table DISQUESINGLE add constraint SID_DISQU_SON_FK
     foreign key (NumSon)
     references SON;

alter table EMPLOYE add constraint REF_EMPLO_MAGAS_FK
     foreign key (IdMagasin)
     references MAGASIN;

alter table EMPLOYE add constraint ID_EMPLO_PERSO_FK
     foreign key (IdPersonne)
     references PERSONNE;

alter table GERANT add constraint SID_GERAN_MAGAS_FK
     foreign key (IdMagasin)
     references MAGASIN;

alter table Interprete add constraint EQU_Inter_SON
     foreign key (NumSon)
     references SON;

alter table Interprete add constraint REF_Inter_ARTIS_FK
     foreign key (Id)
     references ARTISTE;

alter table MAGASIN add constraint ID_MAGASIN_CHK
     check(exists(select * from GERANT
                  where GERANT.IdMagasin = IdMagasin)); 

alter table MAGASIN add constraint REF_MAGAS_ADRES_FK
     foreign key (IdAdresse)
     references ADRESSE;

alter table PERSONNE add constraint REF_PERSO_ADRES_FK
     foreign key (IdAdresse)
     references ADRESSE;

alter table PRODUCTEUR add constraint ID_PRODU_ARTIS_FK
     foreign key (Id)
     references ARTISTE;

alter table Produit add constraint REF_Produ_SON
     foreign key (NumSon)
     references SON;

alter table Produit add constraint REF_Produ_PRODU_FK
     foreign key (Id)
     references PRODUCTEUR;

alter table SON add constraint ID_SON_CHK
     check(exists(select * from Interprete
                  where Interprete.NumSon = NumSon)); 

alter table SON add constraint REF_SON_SON_FK
     foreign key (Remix_)
     references SON;

alter table Stocke add constraint REF_Stock_MAGAS
     foreign key (IdMagasin)
     references MAGASIN;

alter table Stocke add constraint REF_Stock_DISQU_FK
     foreign key (IdDisque)
     references DISQUE;

alter table Vente add constraint REF_Vente_DISQU_FK
     foreign key (IdDisque)
     references DISQUE;

alter table Vente add constraint REF_Vente_CLIEN_FK
     foreign key (NumClient)
     references CLIENT;

alter table Vente add constraint REF_Vente_EMPLO_FK
     foreign key (IdPersonne)
     references EMPLOYE;


-- Index Section
-- _____________ 

create unique index ID_ADRESSE_IND
     on ADRESSE (IdAdresse);

create unique index ID_ALBUM_IND
     on ALBUM (NumAlbum);

create index REF_ALBUM_ARTIS_IND
     on ALBUM (Id);

create unique index ID_Appartient_IND
     on Appartient (NumAlbum, NumSon);

create index REF_Appar_SON_IND
     on Appartient (NumSon);

create unique index ID_ARTISTE_IND
     on ARTISTE (Id);

create index REF_ARTIS_ARTIS_IND
     on ARTISTE (Groupe_);

create unique index ID_CLIENT_IND
     on CLIENT (NumClient);

create unique index SID_CLIEN_PERSO_IND
     on CLIENT (IdPersonne);

create unique index ID_Commande_IND
     on Commande (ID_Com);

create index REF_Comma_MAGAS_IND
     on Commande (IdMagasin);

create index REF_Comma_Fourn_IND
     on Commande (ID_Fou);

create unique index ID_Contenu_IND
     on Contenu (IdDisque, ID_Com);

create index EQU_Conte_Comma_IND
     on Contenu (ID_Com);

create unique index ID_DISQUE_IND
     on DISQUE (IdDisque);

create index REF_DISQU_Fourn_IND
     on DISQUE (ID_Fou);

create unique index ID_DISQU_DISQU_1_IND
     on DISQUEALBUM (IdDisque);

create unique index SID_DISQU_ALBUM_IND
     on DISQUEALBUM (NumAlbum);

create unique index ID_DISQU_DISQU_IND
     on DISQUESINGLE (IdDisque);

create unique index SID_DISQU_SON_IND
     on DISQUESINGLE (NumSon);

create index REF_EMPLO_MAGAS_IND
     on EMPLOYE (IdMagasin);

create unique index ID_EMPLO_PERSO_IND
     on EMPLOYE (IdPersonne);

create unique index ID_FACTURE_IND
     on FACTURE (Reference -- Compound attribute --);

create unique index ID_Fournisseur_IND
     on Fournisseur (ID_Fou);

create unique index SID_GERAN_MAGAS_IND
     on GERANT (IdMagasin);

create unique index ID_Interprete_IND
     on Interprete (NumSon, Id);

create index REF_Inter_ARTIS_IND
     on Interprete (Id);

create unique index ID_MAGASIN_IND
     on MAGASIN (IdMagasin);

create index REF_MAGAS_ADRES_IND
     on MAGASIN (IdAdresse);

create unique index ID_PERSONNE_IND
     on PERSONNE (IdPersonne);

create index REF_PERSO_ADRES_IND
     on PERSONNE (IdAdresse);

create unique index ID_PRODU_ARTIS_IND
     on PRODUCTEUR (Id);

create unique index ID_Produit_IND
     on Produit (NumSon, Id);

create index REF_Produ_PRODU_IND
     on Produit (Id);

create unique index ID_SON_IND
     on SON (NumSon);

create index REF_SON_SON_IND
     on SON (Remix_);

create unique index ID_Stocke_IND
     on Stocke (IdMagasin, IdDisque);

create index REF_Stock_DISQU_IND
     on Stocke (IdDisque);

create unique index ID_Vente_IND
     on Vente (Numero);

create index REF_Vente_DISQU_IND
     on Vente (IdDisque);

create index REF_Vente_CLIEN_IND
     on Vente (NumClient);

create index REF_Vente_EMPLO_IND
     on Vente (IdPersonne);

