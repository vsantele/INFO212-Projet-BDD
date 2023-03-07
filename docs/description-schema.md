# Description du schéma de la base de données

Un magasin possède un gérant, un stock, une adresse, des employés et un stock.

Un employé est une personne qui possède un salaire. Une personne possède une adresse, un nom et un prénom. Un gérant est un employé qui gère un magasin.

Un stock est un ensemble de disques, un magasin et une quantité. Un disque a un prix. Un disque est soit un disque album soit un disque single.

Un disque album est un disque qui contient un album. Un disque single est un disque qui contient un son. Un album possède un titre, un artiste et des chansons.

Un artiste est une personne qui possède un nom d'artiste et des albums. Un producteur est un artiste qui produit des sons. Un album possède un titre, un artiste et des chansons. Une chanson possède un titre, une durée, un artiste et potientiellement des feats et des producteurs. Si c'est un remix, il contient une référence vers l'original.

Une vente est faite dans un magasin par un vendeur pour des disques à une certaine date.
