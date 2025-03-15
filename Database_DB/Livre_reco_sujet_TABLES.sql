USE MENTALHEALTH_DB;

CREATE TABLE IF NOT EXISTS Livre (Id_Livre INT PRIMARY KEY AUTO_INCREMENT,
                                  Nom_livre VARCHAR(100) NOT NULL,
                                  Auteur VARCHAR(100),
                                  Date_publication DATE,
                                  Description VARCHAR(1000),
                                  Editeur VARCHAR(100),
                                  Photo_livre VARCHAR(45));

CREATE TABLE IF NOT EXISTS Recommander ( Livre_Id_Livre INT,
                                         Conseillers_id_conseillers INT,
                                         PRIMARY KEY (Livre_Id_Livre /*, id_conseiller*/),
                                         FOREIGN KEY (Livre_Id_Livre) REFERENCES Livre(Id_Livre) ON DELETE CASCADE,
                                         FOREIGN KEY (/id_conseiller*/) REFERENCES /* Conseillers(id_conseiller*/ ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Sujets (id_sujet INT PRIMARY KEY AUTO_INCREMENT,
                                   nom VARCHAR(100) UNIQUE NOT NULL ,
                                   id_publication VARCHAR(45),
                                   username VARCHAR(45)
                                  FOREIGN KEY /*(USERNAME) */ REFERENCES /*Utilisateurs(username)*/ ON DELETE CASCADE
                                  );