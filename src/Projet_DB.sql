-- *********************************************
-- * Standard SQL generation                   
-- *--------------------------------------------
-- * DB-MAIN version: 11.0.2              
-- * Generator date: Sep 14 2021              
-- * Generation date: Sat Apr 29 14:31:54 2023 
-- * LUN file: D:\Documents\UNamur\Bloc 1\Q2\Base de Données\INFO212-Projet-BDD\docs\Projet_DB.lun 
-- * Schema: Projet_DB/SQL 
-- ********************************************* 


-- Database Section
-- ________________ 

use CLICOM;


-- Drop Tables
-- ___________

drop table if exists `ADRESSE`, `ALBUM`, `APPARTIENT`, `ARTISTE`, `CLIENT`, `COMMANDE`, 
`CONTENU`, `DISQUE`, `DISQUEALBUM`, `DISQUESINGLE`, `EMPLOYE`, `FOURNISSEUR`, `GERANT`, 
`INTERPRETE`, `MAGASIN`, `PERSONNE`, `PRODUCTEUR`, `PRODUIT`, `SON`, `STOCK`, `VENTE`;


-- Tables Section
-- ______________ 

create table ADRESSE (
     IdAdresse char(30) not null,
     Rue char(30) not null,
     CodePostal numeric(5) not null,
     Ville char(30) not null,
     Pays char(30) not null,
     constraint ID_ADRESSE_ID primary key (IdAdresse));

create table MAGASIN (
     IdMagasin numeric(6) not null,
     Nom char(30) not null,
     Telephone numeric(10) not null,
     Adresse char(30),
     constraint ID_MAGASIN_ID primary key (IdMagasin),
     foreign key (Adresse) references ADRESSE(IdAdresse) on delete no action on update cascade);

create table ARTISTE (
     IdArtiste char(30) not null,
     NomArtiste char(30) not null,
     estGroupe bit not null,
     Groupe char(30),
     constraint ID_ARTISTE_ID primary key (IdArtiste),
     foreign key (Groupe) references ARTISTE(IdArtiste) on delete no action on update cascade);

create table ALBUM (
     NumAlbum numeric(10) not null,
     Titre char(30) not null,
     Genre1 char(30) not null,
     Genre2 char(30),
     Genre3 char(30),
     Genre4 char(30),
     Genre5 char(30),
     Artiste char(30) not null,
     constraint ID_ALBUM_ID primary key (NumAlbum),
     foreign key (Artiste) references ARTISTE(IdArtiste) on delete no action on update cascade);

create table SON (
     NumSon numeric(10) not null,
     Titre char(30) not null,
     DureeSec numeric(10) not null,
     Genre1 char(30) not null,
     Genre2 char(30),
     Genre3 char(30),
     Genre4 char(30),
     Genre5 char(30),
     Remix_ numeric(10),
     constraint ID_SON_ID primary key (NumSon),
     foreign key (Remix_) references SON(NumSon) on delete no action on update cascade);

create table APPARTIENT (
     Album numeric(10) not null,
     Son numeric(10) not null,
     constraint ID_APPARTIENT_ID primary key (Album, Son),
     foreign key (Son) references SON(NumSon) on delete no action on update cascade,
     foreign key (Album) references ALBUM(NumAlbum) on delete no action on update cascade);

create table PERSONNE (
     IdPersonne numeric(6) not null,
     Nom char(30) not null,
     Prenom char(30) not null,
     Telephone numeric(10) not null,
     Adresse char(30),
     constraint ID_PERSONNE_ID primary key (IdPersonne),
     foreign key (Adresse) references ADRESSE(IdAdresse) on delete no action on update cascade);

create table CLIENT (
     NumClient numeric(10) not null,
     Personne numeric(6) not null,
     constraint ID_CLIENT_ID primary key (NumClient),
     constraint SID_CLIEN_PERSO_ID unique (Personne),
     foreign key (Personne) references PERSONNE(IdPersonne) on delete no action on update cascade);

create table FOURNISSEUR (
     IdFournisseur char(30) not null,
     Nom char(30) not null,
     constraint ID_FOURNISSEUR_ID primary key (IdFournisseur));

create table COMMANDE (
     IdCommande int not null AUTO_INCREMENT,
     Datelivraison date,
     DateCommande date not null,
     Quantite numeric(10) not null,
     Fournisseur char(30) not null,
     constraint ID_COMMANDE_ID primary key (IdCommande),
     foreign key (Fournisseur) references FOURNISSEUR(IdFournisseur) on delete no action on update cascade,
     check (Quantite >= 0),
     check (DateCommande < Datelivraison));

create table DISQUEALBUM (
     Disque char(30) not null,
     Album numeric(10) not null,
     constraint ID_DISQU_DISQU_1_ID primary key (Disque),
     constraint SID_DISQU_ALBUM_ID unique (Album),
     foreign key (Album) references ALBUM(NumAlbum) on delete no action on update cascade);

create table DISQUESINGLE (
     Disque char(30) not null,
     Son numeric(10) not null,
     constraint ID_DISQU_DISQU_ID primary key (Disque),
     constraint SID_DISQU_SON_ID unique (Son),
     foreign key (Son) references SON(NumSon) on delete no action on update cascade);

create table DISQUE (
     IdDisque char(30) not null,
     PrixVente numeric(10,4) not null,
     PrixAchat numeric(10,4) not null,
     Fournisseur char(30) not null,
     DisqueAlbum char(30),
     DisqueSingle char(30),
     constraint ID_DISQUE_ID primary key (IdDisque),
     foreign key (Fournisseur) references FOURNISSEUR(IdFournisseur) on delete no action on update cascade,
     check (PrixAchat > 0),
     check (PrixVente > 0));
     
create table CONTENU (
     Commande int not null,
     Disque char(30) not null,
     constraint ID_Contenu_ID primary key (Disque, Commande),
     foreign key (Disque) references DISQUE(IdDisque) on delete no action on update cascade,
     foreign key (Commande) references COMMANDE(IdCommande) on delete no action on update cascade);

create table EMPLOYE (
     Personne numeric(6) not null,
     Email char(50) not null,
     Salaire numeric(10,4) not null,
     Magasin numeric(6) not null,
     constraint ID_EMPLO_PERSO_ID primary key (Personne),
     foreign key (Magasin) references MAGASIN(IdMagasin) on delete no action on update cascade,
     foreign key (Personne) references PERSONNE(IdPersonne) on delete no action on update cascade,
     check (Salaire > 0));

create table GERANT (
     Employe numeric(6) not null,
     Magasin numeric(6) not null,
     VoitureSociete char not null,
     constraint ID_GERANT_ID primary key (Employe),
     constraint SID_GERAN_MAGAS_ID unique (Magasin),
     foreign key (Magasin) references MAGASIN(IdMagasin) on delete no action on update cascade,
     foreign key (Employe) references EMPLOYE(Personne) on delete no action on update cascade);

create table INTERPRETE (
     Artiste char(30) not null,
     Son numeric(10) not null,
     constraint ID_INTERPRETE_ID primary key (Son, Artiste),
     foreign key (Son) references SON(NumSon) on delete no action on update cascade,
     foreign key (Artiste) references ARTISTE(IdArtiste) on delete no action on update cascade);

create table PRODUCTEUR (
     Artiste char(30) not null,
     constraint ID_PRODU_ARTIS_ID primary key (Artiste),
     foreign key (Artiste) references ARTISTE(IdArtiste) on delete no action on update cascade);

create table PRODUIT (
     Producteur char(30) not null,
     Son numeric(10) not null,
     constraint ID_PRODUIT_ID primary key (Son, Producteur),
     foreign key (Son) references SON(NumSon) on delete no action on update cascade,
     foreign key (Producteur) references PRODUCTEUR(Artiste) on delete no action on update cascade);

create table STOCK (
     Disque char(30) not null,
     Magasin numeric(6) not null,
     Quantite numeric(10) not null,
     constraint ID_STOCK_ID primary key (Magasin, Disque),
     foreign key (Magasin) references MAGASIN(IdMagasin) on delete no action on update cascade,
     foreign key (Disque) references DISQUE(IdDisque) on delete no action on update cascade,
     check (Quantite >= 0));

create table VENTE (
     Numero numeric(10) not null,
     Quantite numeric(10) not null,
     DateAchat date not null,
     Disque char(30) not null,
     Client numeric(10) not null,
     Employe numeric(6) not null,
     constraint ID_VENTE_ID primary key (Numero),
     foreign key (Disque) references DISQUE(IdDisque) on delete no action on update cascade,
     foreign key (Client) references CLIENT(NumClient) on delete no action on update cascade,
     foreign key (Employe) references EMPLOYE(Personne) on delete no action on update cascade,
     check (Quantite >= 0));


-- Constraints Section
-- ___________________ 

drop trigger if exists TRG_DISQUE_INSERT_SURTYPE;
delimiter //
create trigger TRG_DISQUE_INSERT_SURTYPE
before insert on DISQUE for each row
begin
     set new.DisqueAlbum = null, new.DisqueSingle = null;
end//
delimiter ;

-- revoke update (DisqueSingle, DisqueSingle) on DISQUE from public;
-- revoke update (Disque) on DISQUEALBUM from public;
-- revoke update (Disque) on DISQUESINGLE from public;

alter table DISQUEALBUM add constraint FK_ALBUM_DISQUE
foreign key (Disque) references DISQUE(IdDisque) on delete cascade on update cascade;

alter table DISQUESINGLE add constraint FK_SINGLE_DISQUE
foreign key (Disque) references DISQUE(IdDisque) on delete cascade on update cascade;

drop trigger if exists TRG_ALBUM_INSERT_ISA_DISQUE;
delimiter //
create trigger TRG_ALBUM_INSERT_ISA_DISQUE
before insert on DISQUEALBUM for each row
begin
	declare I int;
     declare msg varchar(128);
     select COUNT(*) into I from DISQUE where IdDisque = new.Disque
     and (DisqueAlbum is not null or DisqueSingle is not null);
     if I = 1 then
		set msg = 'Error insert on DISQUEALBUM';
          signal sqlstate '45000' set message_text = msg;
     end if;
     update DISQUE set DisqueAlbum = '*'
     where IdDisque = new.Disque;
end//
delimiter ;


drop trigger if exists TRG_SINGLE_INSERT_ISA_DISQUE;
delimiter //
create trigger TRG_SINGLE_INSERT_ISA_DISQUE
before insert on DISQUESINGLE for each row
begin
     declare I int;
     declare msg varchar(128);
     select COUNT(*) into I from DISQUE where IdDisque = new.Disque
     and (DisqueAlbum is not null or DisqueSingle is not null);
	if I = 1 then
	     set msg = 'Error insert on DISQUESINGLE';
          signal sqlstate '45000' set message_text = msg;
     end if;
     update DISQUE set DisqueSingle = '*'
     where IdDisque = new.Disque;
end//
delimiter ;

drop trigger if exists TRG_ALBUM_DELETE_ISA_DIS;
delimiter //
create trigger TRG_ALBUM_DELETE_ISA_DIS
after delete on DISQUEALBUM for each row
begin
     update DISQUE set DisqueAlbum = null
     where IdDisque = old.Disque;
end//
delimiter ;

drop trigger if exists TRG_SINGLE_DELETE_ISA_DIS;
delimiter //
create trigger TRG_SINGLE_DELETE_ISA_DIS
after delete on DISQUESINGLE for each row
begin
     update DISQUE set DisqueSingle = null
     where IdDisque = old.Disque;
end//
delimiter ;

drop trigger if exists TRG_INSERT_STOCK;
delimiter //
drop trigger if exists TRG_UPDATE_STOCK;
delimiter //
create trigger TRG_UPDATE_STOCK
before update on STOCK for each row
begin
	declare I integer;
	if new.Quantite < 2 then
		select COUNT(*) into I from CONTENU where Disque = new.Disque;
        if I = 0 then
			insert into COMMANDE(DateCommande, Quantite, Fournisseur) values(curdate(), 10, 'FOUDB01');
			insert into CONTENU values(LAST_INSERT_ID(),new.Disque);
        end if;
        set new.Disque = new.Disque, New.Magasin = New.Magasin, New.Quantite = New.Quantite;        
    end if;
end//
delimiter ;

drop trigger if exists TRG_INSERT_STOCK;
delimiter //
create trigger TRG_INSERT_STOCK
before insert on STOCK for each row
begin
	declare I integer;
	if new.Quantite < 2 then
		select COUNT(*) into I from CONTENU where Disque = new.Disque;
        if I = 0 then
			insert into COMMANDE(DateCommande, Quantite, Fournisseur) values(curdate(), 10, 'FOUDB01');
			insert into CONTENU values(LAST_INSERT_ID(),new.Disque);
        end if;
        set new.Disque = new.Disque, New.Magasin = New.Magasin, New.Quantite = New.Quantite;        
    end if;
end//
delimiter ;


-- View Section
-- ____________

drop view if exists FACTURE;
create view FACTURE as
select v.Numero, p.Nom, p.Prenom, d.IdDisque, v.DateAchat, v.Quantite, 
       (d.PrixVente * v.Quantite) AS PrixTotal
from VENTE v
inner join CLIENT c on v.Client = c.NumClient
inner join DISQUE d on v.Disque = d.IdDisque
inner join PERSONNE p on c.Personne = p.IdPersonne;


-- Insert Section
-- ______________

insert into ADRESSE values('ADRDB01','Rue des Cerfs', 1000, 'Bruxelles', 'Belgique');
insert into ADRESSE values('ADRDB02','Boulevard des Rois', 1050, 'Ixelles', 'Belgique');
insert into ADRESSE values('ADRDB03','Chemin des Fêtes', 1070, 'Anderlecht', 'Belgique');
insert into ADRESSE values('ADRDB04','Rue de la Colline', 4000, 'Liège', 'Belgique');
insert into ADRESSE values('ADRDB05','Rue de Victoire', 5020, 'Malonne', 'Belgique');
insert into ADRESSE values('ADRDB06','Rue des Rosiers', 7500, 'Tournai', 'Belgique');
insert into ADRESSE values('ADRDB07','Rue du Musée', 1410, 'Waterloo', 'Belgique');

insert into MAGASIN values(123456, 'Rockamusic', 087148634, 'ADRDB01');

insert into ARTISTE values('ARTDB01', 'Bert East', 0, null);
insert into ARTISTE values('ARTDB02', 'Whistle', 0, null);
insert into ARTISTE values('ARTDB05', 'Donnie Diamond', 1, null);
insert into ARTISTE values('ARTDB03', 'Patrick Terris', 0, 'ARTDB05');
insert into ARTISTE values('ARTDB04', 'Don Dale', 0, 'ARTDB05');

insert into ALBUM values(1, 'Time flies', 'hip-hop', null, null, null, null, 'ARTDB01');
insert into ALBUM values(2, 'Time flies', 'hip-hop', 'rock', null, null, null, 'ARTDB02');
insert into ALBUM values(3, 'Time flies', 'hip-hop', 'rock', 'RnB', null, null, 'ARTDB05');

insert into SON values(1, 'A Way Of Diamonds', 187, 'hip-hop', null, null, null, null, null);
insert into SON values(2, 'Choice Of Stars', 187, 'hip-hop', 'RnB', null, null, null, null);
insert into SON values(3, 'Copy Her Party', 187, 'rock', null, null, null, null, null);
insert into SON values(4, 'Without My Mind', 187, 'hip-hop', null, null, null, null, null);
insert into SON values(5, 'Fame Promises', 187, 'hip-hop', null, null, null, null, null);
insert into SON values(6, 'No Money', 187, 'hip-hop', null, null, null, null, null);
insert into SON values(7, 'I Need You', 187, 'hip-hop', 'RnB', null, null, null, null);
insert into SON values(8, 'She Said I Want You', 187, 'hip-hop', 'rock', null, null, null, null);
insert into SON values(9, 'She Heard He Will Try', 187, 'hip-hop', null, null, null, null, 8);

insert into APPARTIENT values(1,1);
insert into APPARTIENT values(1,2);
insert into APPARTIENT values(1,3);
insert into APPARTIENT values(2,4);
insert into APPARTIENT values(2,5);
insert into APPARTIENT values(2,6);
insert into APPARTIENT values(3,7);
insert into APPARTIENT values(3,8);
insert into APPARTIENT values(3,9);

insert into PERSONNE values(1, 'Max', 'Marchal', 0475673956, 'ADRDB02');
insert into PERSONNE values(2, 'Remi', 'Gérald', 0477123456, 'ADRDB03');
insert into PERSONNE values(3, 'Edouard', 'Dumont', 0489126745, 'ADRDB04');
insert into PERSONNE values(4, 'Norbert', 'Geiger', 0472561937, 'ADRDB05');
insert into PERSONNE values(5, 'Édouard', 'Lajoie', 0478143956, 'ADRDB06');
insert into PERSONNE values(6, 'Thibaud', 'Beaulieu', 0470183645, 'ADRDB07');

insert into CLIENT values(1, 1);
insert into CLIENT values(2, 2);
insert into CLIENT values(3, 3);

insert into FOURNISSEUR values('FOUDB01', 'Scorpion Music');
insert into FOURNISSEUR values('FOUDB02', 'Anybody Music Group');

insert into COMMANDE values(1, '2023-01-01', '2022-12-01', 2, 'FOUDB01');
insert into COMMANDE values(2, '2023-02-01', '2022-12-02', 3, 'FOUDB01');
insert into COMMANDE values(3, '2023-03-01', '2022-12-03', 4, 'FOUDB01');
insert into COMMANDE values(4, '2023-04-01', '2022-11-04', 5, 'FOUDB01');
insert into COMMANDE values(5, '2023-05-01', '2022-11-05', 8, 'FOUDB01');

insert into DISQUE(IdDisque, PrixVente, PrixAchat, Fournisseur) values('DISDB01', 10.5, 8.3, 'FOUDB01');
insert into DISQUE(IdDisque, PrixVente, PrixAchat, Fournisseur) values('DISDB02', 11.5, 9.3, 'FOUDB01');
insert into DISQUE(IdDisque, PrixVente, PrixAchat, Fournisseur) values('DISDB03', 9.5, 10, 'FOUDB01');
insert into DISQUE(IdDisque, PrixVente, PrixAchat, Fournisseur) values('DISDB04', 12, 10, 'FOUDB01');
insert into DISQUE(IdDisque, PrixVente, PrixAchat, Fournisseur) values('DISDB05', 15, 13.7, 'FOUDB01');
insert into DISQUE(IdDisque, PrixVente, PrixAchat, Fournisseur) values('DISDB06', 9, 8.3, 'FOUDB01');
insert into DISQUE(IdDisque, PrixVente, PrixAchat, Fournisseur) values('DISDB07', 10, 8.3, 'FOUDB01');

insert into DISQUESINGLE values('DISDB01', 1);
insert into DISQUESINGLE values('DISDB02', 2);
insert into DISQUESINGLE values('DISDB03', 3);

insert into DISQUEALBUM values('DISDB04', 1);
insert into DISQUEALBUM values('DISDB05', 2);
insert into DISQUEALBUM values('DISDB06', 3);

insert into CONTENU values(1, 'DISDB01');
insert into CONTENU values(2, 'DISDB02');
insert into CONTENU values(3, 'DISDB03');
insert into CONTENU values(4, 'DISDB04');
insert into CONTENU values(5, 'DISDB05');

insert into EMPLOYE values(1, 'cruluveroyi-9942@yopmail.com', 3500, 123456);
insert into EMPLOYE values(4, 'cricreyauxappu-4065@yopmail.com', 2600, 123456);
insert into EMPLOYE values(5, 'nonneugavogreu-2075@yopmail.com', 2700, 123456);
insert into EMPLOYE values(6, 'cavassoulauzi-3503@yopmail.com', 1900.5, 123456);

insert into GERANT values(1, 123456, 1);

insert into INTERPRETE values('ARTDB01', 1);
insert into INTERPRETE values('ARTDB01', 2);
insert into INTERPRETE values('ARTDB01', 3);
insert into INTERPRETE values('ARTDB02', 4);
insert into INTERPRETE values('ARTDB02', 5);
insert into INTERPRETE values('ARTDB02', 6);
insert into INTERPRETE values('ARTDB05', 7);
insert into INTERPRETE values('ARTDB05', 8);
insert into INTERPRETE values('ARTDB05', 9);

insert into PRODUCTEUR values('ARTDB03');
insert into PRODUCTEUR values('ARTDB04');

insert into PRODUIT values('ARTDB03', 1);
insert into PRODUIT values('ARTDB03', 2);
insert into PRODUIT values('ARTDB03', 3);
insert into PRODUIT values('ARTDB03', 4);
insert into PRODUIT values('ARTDB04', 5);
insert into PRODUIT values('ARTDB04', 6);
insert into PRODUIT values('ARTDB04', 7);
insert into PRODUIT values('ARTDB04', 8);
insert into PRODUIT values('ARTDB04', 9);

insert into STOCK values('DISDB01', 123456, 12);
insert into STOCK values('DISDB02', 123456, 5);
insert into STOCK values('DISDB03', 123456, 20);
insert into STOCK values('DISDB04', 123456, 8);
insert into STOCK values('DISDB05', 123456, 3);
insert into STOCK values('DISDB06', 123456, 10);

insert into VENTE values(1, 2, '2023-02-10', 'DISDB01', 1, 4);
insert into VENTE values(2, 4, '2023-03-20', 'DISDB02', 2, 5);
insert into VENTE values(3, 1, '2023-04-18', 'DISDB04', 3, 6);

commit;