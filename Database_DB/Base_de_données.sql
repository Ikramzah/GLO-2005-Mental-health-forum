DROP DATABASE IF EXISTS MENTALHEALTH_DB;
CREATE DATABASE IF NOT EXISTS MENTALHEALTH_DB;

USE MENTALHEALTH_DB;

CREATE TABLE ResetPasswordCodes (
    email VARCHAR(100) NOT NULL,
    code VARCHAR(6) NOT NULL,
    expiration DATETIME NOT NULL
);

-- Création de la table Utilisateurs
CREATE TABLE Utilisateurs (
    username VARCHAR(50)  PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    photo_de_profil VARCHAR(100),
    date_inscription DATE NOT NULL,
    date_de_naissance DATE,
    lieu_de_residence VARCHAR(100)
    anonyme BOOLEAN DEFAULT FALSE;
);

-- Table Conseillers
CREATE TABLE Conseillers (
    username VARCHAR(50) PRIMARY KEY,
    specialisation VARCHAR(100),
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table Etudiants
CREATE TABLE Etudiants (
    username VARCHAR(50) PRIMARY KEY,
    statut_etudiant ENUM('international', 'en echange', 'citoyen', 'resident permanent') NOT NULL,
    niveau_anonymat ENUM('anonyme', 'pseudo', 'public') DEFAULT 'pseudo',
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table Moderateur
CREATE TABLE Moderateur (
    username VARCHAR(50) PRIMARY KEY,
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insertion des 30 étudiants
INSERT INTO Utilisateurs (username, nom, prenom, email, mot_de_passe, date_inscription, date_de_naissance, lieu_de_residence, photo_de_profil)
VALUES
('studen001', 'Martin', 'Olivier', 'olivier.martin@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-05', '2002-03-14', 'Montréal','images/photo de profil defaut.png'),
('studen002', 'Tremblay', 'Marie', 'marie.tremblay@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-06', '1999-07-22', 'Québec','images/photo de profil defaut.png'),
('studen003', 'Gagnon', 'Luc', 'luc.gagnon@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-07', '2001-11-10', 'Laval','images/photo de profil defaut.png'),
('studen004', 'Roy', 'Julie', 'julie.roy@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-08', '2003-04-19', 'Gatineau','images/photo de profil defaut.png'),
('studen005', 'Bouchard', 'Samuel', 'samuel.bouchard@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-09', '2002-02-28', 'Montréal','images/photo de profil defaut.png'),
('studen006', 'Ouellet', 'Chloé', 'chloe.ouellet@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-10', '2000-12-05', 'Sherbrooke','images/photo de profil defaut.png'),
('studen007', 'Fortin', 'Antoine', 'antoine.fortin@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-10', '2001-06-15', 'Trois-Rivières','images/photo de profil defaut.png'),
('studen008', 'Lapointe', 'Emma', 'emma.lapointe@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-11', '2002-10-02', 'Montréal','images/photo de profil defaut.png'),
('studen009', 'Côté', 'Jérôme', 'jerome.cote@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-11', '2001-09-12', 'Chicoutimi','images/photo de profil defaut.png'),
('studen010', 'Pelletier', 'Anne', 'anne.pelletier@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-12', '1998-05-23', 'Montréal','images/photo de profil defaut.png'),
('studen011', 'Gauthier', 'Éric', 'eric.gauthier@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-12', '2003-03-03', 'Ottawa','images/photo de profil defaut.png'),
('studen012', 'Morin', 'Isabelle', 'isabelle.morin@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-13', '2002-07-17', 'Saint-Jérôme','images/photo de profil defaut.png'),
('studen013', 'Lavoie', 'Maxime', 'maxime.lavoie@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-13', '2001-08-24', 'Montréal','images/photo de profil defaut.png'),
('studen014', 'Campeau', 'Sophie', 'sophie.campeau@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-14', '1999-10-01', 'Drummondville','images/photo de profil defaut.png'),
('studen015', 'Leclerc', 'Thomas', 'thomas.leclerc@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-15', '1998-01-30', 'Brossard','images/photo de profil defaut.png'),
('studen016', 'Paquet', 'Jeanne', 'jeanne.paquet@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-15', '2000-02-12', 'Montréal','images/photo de profil defaut.png'),
('studen017', 'Giroux', 'Alexandre', 'alex.giroux@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-16', '2001-08-08', 'Gatineau','images/photo de profil defaut.png'),
('studen018', 'Fournier', 'Camille', 'camille.fournier@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-16', '2002-11-20', 'Québec','images/photo de profil defaut.png'),
('studen019', 'Gravel', 'David', 'david.gravel@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-17', '2003-01-17', 'Montréal','images/photo de profil defaut.png'),
('studen020', 'Beaulieu', 'Sarah', 'sarah.beaulieu@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-17', '1999-04-21', 'Longueuil','images/photo de profil defaut.png'),
('studen021', 'Mercier', 'Sébastien', 'sebastien.mercier@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-18', '2001-05-14', 'Châteauguay','images/photo de profil defaut.png'),
('studen022', 'Simard', 'Audrey', 'audrey.simard@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-18', '2003-02-02', 'Montréal','images/photo de profil defaut.png'),
('studen023', 'Bélanger', 'François', 'francois.belanger@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-19', '2000-08-25', 'Montréal','images/photo de profil defaut.png'),
('studen024', 'Bergeron', 'Catherine', 'catherine.bergeron@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-19', '1998-09-27', 'Lévis','images/photo de profil defaut.png'),
('studen025', 'Leblanc', 'Nicolas', 'nicolas.leblanc@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-20', '2002-03-01', 'Saint-Hyacinthe','images/photo de profil defaut.png'),
('studen026', 'Cyr', 'Valérie', 'valerie.cyr@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-20', '1997-12-11', 'Terrebonne','images/photo de profil defaut.png'),
('studen027', 'Dufour', 'Kevin', 'kevin.dufour@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-21', '2000-10-09', 'Montréal','images/photo de profil defaut.png'),
('studen028', 'Boisvert', 'Annie', 'annie.boisvert@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-21', '1999-07-30', 'Sherbrooke','images/photo de profil defaut.png'),
('studen029', 'Chevalier', 'Jonathan', 'jonathan.chevalier@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-22', '2001-03-13', 'Trois-Rivières','images/photo de profil defaut.png'),
('studen030', 'Langlois', 'Karine', 'karine.langlois@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2025-01-22', '2002-11-04', 'Québec','images/photo de profil defaut.png'),
('studen031', 'Boisvert', 'Jonathan', 'jonathan.boisvert@example.com', 'scrypt:32768:8:1$AtEfviaDnW6jD84z$79ab4c9ae28040b0205f2897ea3a8cfdc72d5f2cad1d382e646bdc21a79130853c2847d93e0db5477b5c460fd492e38e26eedfdff918d22114da45bb5ba2aca7', '2024-09-28', '2003-03-13', 'Trois-Rivières','images/photo de profil defaut.png');

-- Insertion des étudiants
INSERT INTO Etudiants (username, statut_etudiant, niveau_anonymat)
VALUES
('studen001', 'citoyen', 'public'),
('studen002', 'international', 'pseudo'),
('studen003', 'en echange', 'anonyme'),
('studen004', 'citoyen', 'public'),
('studen005', 'resident permanent', 'pseudo'),
('studen006', 'international', 'anonyme'),
('studen007', 'citoyen', 'pseudo'),
('studen008', 'en echange', 'public'),
('studen009', 'citoyen', 'pseudo'),
('studen010', 'resident permanent', 'public'),
('studen011', 'citoyen', 'anonyme'),
('studen012', 'international', 'public'),
('studen013', 'en echange', 'pseudo'),
('studen014', 'citoyen', 'public'),
('studen015', 'resident permanent', 'anonyme'),
('studen016', 'citoyen', 'pseudo'),
('studen017', 'international', 'public'),
('studen018', 'en echange', 'anonyme'),
('studen019', 'citoyen', 'public'),
('studen020', 'resident permanent', 'pseudo'),
('studen021', 'international', 'anonyme'),
('studen022', 'citoyen', 'public'),
('studen023', 'en echange', 'pseudo'),
('studen024', 'citoyen', 'public'),
('studen025', 'resident permanent', 'anonyme'),
('studen026', 'citoyen', 'pseudo'),
('studen027', 'international', 'public'),
('studen028', 'en echange', 'anonyme'),
('studen029', 'citoyen', 'pseudo'),
('studen030', 'resident permanent', 'public'),
('studen031', 'citoyen', 'public');

-- Insertion des conseillers
INSERT INTO Utilisateurs (username, nom, prenom, email, mot_de_passe, date_inscription, date_de_naissance, lieu_de_residence, photo_de_profil)
VALUES
('conseil01', 'Arsenault', 'Daniel', 'daniel.arsenault@example.com', 'scrypt:32768:8:1$Z5nER6qcGcvoVV7w$05877e9962ac06e71c3c5318e7b0bc664258b59f60e1428b2efb8744f793a1fa82402b060c31983ef6cbbfb2e429244209e47b4509cc425372fa010a56e3ba35', '2025-02-01', '1985-04-12', 'Montréal','images/Daniel.png' ),
('conseil02', 'Robert', 'Patricia', 'patricia.robert@example.com', 'scrypt:32768:8:1$Z5nER6qcGcvoVV7w$05877e9962ac06e71c3c5318e7b0bc664258b59f60e1428b2efb8744f793a1fa82402b060c31983ef6cbbfb2e429244209e47b4509cc425372fa010a56e3ba35', '2025-02-02', '1979-09-08', 'Québec','images/Patricia.png'),
('conseil03', 'Lefebvre', 'Monique', 'monique.lefebvre@example.com', 'scrypt:32768:8:1$Z5nER6qcGcvoVV7w$05877e9962ac06e71c3c5318e7b0bc664258b59f60e1428b2efb8744f793a1fa82402b060c31983ef6cbbfb2e429244209e47b4509cc425372fa010a56e3ba35', '2025-02-03', '1988-11-23', 'Longueuil','images/Monique.png'),
('conseil04', 'Carpentier', 'Yves', 'yves.carpentier@example.com', 'scrypt:32768:8:1$Z5nER6qcGcvoVV7w$05877e9962ac06e71c3c5318e7b0bc664258b59f60e1428b2efb8744f793a1fa82402b060c31983ef6cbbfb2e429244209e47b4509cc425372fa010a56e3ba35', '2025-02-04', '1990-01-15', 'Sherbrooke','images/Yves.png'),
('conseil05', 'Deschamps', 'Amélie', 'amelie.deschamps@example.com', 'scrypt:32768:8:1$Z5nER6qcGcvoVV7w$05877e9962ac06e71c3c5318e7b0bc664258b59f60e1428b2efb8744f793a1fa82402b060c31983ef6cbbfb2e429244209e47b4509cc425372fa010a56e3ba35', '2025-02-05', '1982-03-29', 'Gatineau','images/Amelie.png');

INSERT INTO Conseillers (username, specialisation)
VALUES
('conseil01', 'Orientation académique'),
('conseil02', 'Bourses et financements'),
('conseil03', 'Insertion professionnelle'),
('conseil04', 'Mobilité internationale'),
('conseil05', 'Conseil psychologique');

-- Insertion des modérateurs
INSERT INTO Utilisateurs (username, nom, prenom, email, mot_de_passe, date_inscription, date_de_naissance, lieu_de_residence, photo_de_profil)
VALUES
('mod01', 'Lévesque', 'Stéphane', 'stephane.levesque@example.com', 'scrypt:32768:8:1$ez6BjYEp3MoKHSaw$a4e5f50d7c035a47535ed481b6e9f635c9702a6cecf1d5afcd69ba7a182cf03483a17223bf5250daf31e2dbe2d6e937ee9c628c7459178c5829058baaad9ce3c', '2025-03-01', '1975-12-06', 'Montréal','images/photo de profil defaut.png'),
('mod02', 'Desjardins', 'Carole', 'carole.desjardins@example.com', 'scrypt:32768:8:1$ez6BjYEp3MoKHSaw$a4e5f50d7c035a47535ed481b6e9f635c9702a6cecf1d5afcd69ba7a182cf03483a17223bf5250daf31e2dbe2d6e937ee9c628c7459178c5829058baaad9ce3c', '2025-03-02', '1980-07-19', 'Québec','images/photo de profil defaut.png'),
('mod03', 'Dubois', 'Frédéric', 'frederic.dubois@example.com', 'scrypt:32768:8:1$ez6BjYEp3MoKHSaw$a4e5f50d7c035a47535ed481b6e9f635c9702a6cecf1d5afcd69ba7a182cf03483a17223bf5250daf31e2dbe2d6e937ee9c628c7459178c5829058baaad9ce3c', '2025-03-03', '1972-05-11', 'Sherbrooke','images/photo de profil defaut.png');

INSERT INTO Moderateur (username)
VALUES
('mod01'),
('mod02'),
('mod03');

DELIMITER //
CREATE TRIGGER verif_age_avant_insert
BEFORE INSERT ON Utilisateurs
FOR EACH ROW
BEGIN
  IF NEW.date_de_naissance IS NOT NULL AND 
     NEW.date_de_naissance > DATE_SUB(CURDATE(), INTERVAL 18 YEAR) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Lutilisateur doit avoir au moins 18 ans.';
  END IF;
END;
//
DELIMITER ;


-- Indexation pour optimisation
CREATE INDEX idx_utilisateurs_email ON Utilisateurs(email);

-- Table Publications
CREATE TABLE Publications (
    id_publication INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    p_titre TEXT NOT NULL,
    texte TEXT NOT NULL,
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    statut ENUM('anonyme', 'public') NOT NULL DEFAULT 'public',
    nb_reponses INT DEFAULT 0 CHECK (nb_reponses >= 0),
    nb_reaction INT DEFAULT 0 CHECK (nb_reaction >= 0),
    images LONGBLOB,
    status_suppression BOOLEAN DEFAULT FALSE, 
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) 
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table Reagir_publication
CREATE TABLE Reagir_publication (
    id_reaction INT AUTO_INCREMENT PRIMARY KEY,
    id_publication INT NOT NULL,
    username VARCHAR(50) NOT NULL,
    type_reaction ENUM('LIKE', 'DISLIKE', 'LOVE', 'SAD', 'ANGRY') NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_publication) REFERENCES Publications(id_publication)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (username) REFERENCES Utilisateurs(username)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_reaction UNIQUE (id_publication, username)
);

CREATE TABLE Commentaires (
    id_commentaire INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    id_publication INT NOT NULL,
    id_parent_commentaire INT NULL,
    status_suppression BOOLEAN DEFAULT FALSE,
    contenu TEXT NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nb_reactions INT DEFAULT 0,
    CONSTRAINT fk_commentaire_utilisateur FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_commentaire_publication FOREIGN KEY (id_publication) REFERENCES Publications(id_publication) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_commentaire_parent FOREIGN KEY (id_parent_commentaire) REFERENCES Commentaires(id_commentaire) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_commentaires_username ON Commentaires(username);
CREATE INDEX idx_commentaires_publication ON Commentaires(id_publication);
CREATE INDEX idx_commentaires_parent ON Commentaires(id_parent_commentaire);
CREATE INDEX idx_commentaires_date ON Commentaires(date_creation);

CREATE TABLE Reagir_commentaire (
    id_reaction_c INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    id_commentaire INT NOT NULL,
    type_reaction ENUM('LIKE', 'DISLIKE', 'LOVE', 'SAD', 'ANGRY') NOT NULL,
    date_reaction TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reaction_utilisateur FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reaction_commentaire FOREIGN KEY (id_commentaire) REFERENCES Commentaires(id_commentaire) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_reaction UNIQUE (username, id_commentaire)
);

CREATE INDEX idx_reagir_commentaire_user ON Reagir_commentaire(username);
CREATE INDEX idx_reagir_commentaire_id ON Reagir_commentaire(id_commentaire);
CREATE INDEX idx_reagir_commentaire_type ON Reagir_commentaire(type_reaction);

CREATE TABLE Reserver (
    id_rdv INT AUTO_INCREMENT PRIMARY KEY,
    username_etudiant VARCHAR(50) NOT NULL,
    username_conseiller VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    statut ENUM('En attente', 'Confirmé', 'Annulé') DEFAULT 'En attente',
    raison TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reserver_etudiant FOREIGN KEY (username_etudiant) REFERENCES Etudiants(username) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reserver_conseiller FOREIGN KEY (username_conseiller) REFERENCES Conseillers(username) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_reserver_etudiant ON Reserver(username_etudiant);
CREATE INDEX idx_reserver_conseiller ON Reserver(username_conseiller);
CREATE INDEX idx_reserver_date ON Reserver(date);
CREATE INDEX idx_reserver_date_heure ON Reserver(date, heure_debut, heure_fin);

-- Ajout d'une contrainte UNIQUE pour éviter les doublons identiques 
ALTER TABLE Reserver ADD CONSTRAINT uq_rdv_unique UNIQUE (username_etudiant, username_conseiller, date, heure_debut, heure_fin);

-- Contraintes supplémentaires
ALTER TABLE Reserver
ADD CONSTRAINT chk_heure
CHECK (heure_debut < heure_fin);

DELIMITER //
CREATE TRIGGER verif_date_reservation
BEFORE INSERT ON Reserver
FOR EACH ROW
BEGIN
  IF NEW.date < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La date de réservation doit être aujourdhui ou dans le futur.';
  END IF;
END;
//
DELIMITER ;


-- Table Effacer
CREATE TABLE Effacer (
    id_effacement INT AUTO_INCREMENT PRIMARY KEY,
    id_publication INT NULL,
    id_commentaire INT NULL,
    username VARCHAR(50) NOT NULL,
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    raison TEXT NOT NULL,
    type_effacement ENUM('utilisateur', 'modérateur') NOT NULL,
    FOREIGN KEY (id_publication) REFERENCES Publications(id_publication)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_commentaire) REFERENCES Commentaires(id_commentaire)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (username) REFERENCES Utilisateurs(username)
        ON DELETE CASCADE ON UPDATE CASCADE  -- ← PAS DE VIRGULE ICI
);

-- Insertion des publications
INSERT INTO Publications (username, p_titre, texte, statut, date) VALUES
('studen001', 'Stress avant les examens', ' Je me sens dépassé par la charge de travail, comment gérez-vous le stress avant les examens?', 'public', '2025-03-01 14:30:00'),
('studen002', 'Difficultés d''adaptation', 'Je suis nouveau à l''université et j''ai du mal à m''intégrer. Des conseils?', 'public', '2025-03-02 09:15:00'),
('studen003', 'Problèmes de sommeil', 'Depuis le début de la session, je dors très mal. Est-ce que d''autres vivent la même chose?', 'anonyme', '2025-03-03 22:45:00'),
('studen004', 'Gestion du temps', 'Comment faites-vous pour équilibrer études, travail et vie sociale?', 'public', '2025-03-04 16:20:00'),
('studen005', 'Anxiété de performance', 'J''ai peur de ne pas être à la hauteur malgré mes bons résultats. Est-ce normal?', 'public', '2025-03-05 11:10:00'),
('studen006', 'Solitude sur le campus', 'Je me sens seul même entouré de gens. Des suggestions pour briser la glace?', 'public', '2025-03-06 18:30:00'),
('studen007', 'Choix de carrière', 'Je doute de mon choix de programme. Comment prendre une décision éclairée?', 'public', '2025-03-07 13:25:00'),
('studen008', 'Problèmes financiers', 'Je peine à joindre les deux bouts. Des ressources pour les étudiants dans le besoin?', 'anonyme', '2025-03-08 20:15:00'),
('studen009', 'Concentration en cours', 'J''ai du mal à rester concentré pendant les longs cours. Des techniques qui fonctionnent?', 'public', '2025-03-09 10:05:00'),
('studen010', 'Équilibre travail-études', 'Mon emploi à temps partiel empiète sur mes études. Comment mieux organiser mon temps?', 'public', '2025-03-10 15:40:00');


-- Données pour Commentaires
INSERT INTO Commentaires (id_commentaire, username, id_publication, id_parent_commentaire, contenu, date_creation) VALUES
(1, 'studen011', 1, NULL, 'J''utilise la technique Pomodoro pour gérer mon temps d''étude, ça m''aide beaucoup!', '2025-03-01 15:45:00'),
(2, 'studen012', 1, NULL, 'N''hésite pas à faire des pauses et à bouger un peu, ça aide à décompresser.', '2025-03-01 16:20:00'),
(3, 'studen013', 1, 1, 'Je ne connaissais pas Pomodoro, merci pour le conseil!', '2025-03-01 17:30:00'),
(4, 'studen014', 2, NULL, 'Participe aux activités organisées par ton association étudiante, c''est un bon moyen de rencontrer des gens.', '2025-03-02 10:05:00'),
(5, 'conseil01', 2, NULL, 'Nous organisons des sessions de bienvenue chaque semaine, viens nous voir au centre d''orientation!', '2025-03-02 11:15:00'),
(6, 'studen015', 3, NULL, 'J''ai le même problème depuis que j''ai commencé à boire du café l''après-midi.', '2025-03-03 23:30:00'),
(7, 'conseil05', 3, NULL, 'Les problèmes de sommeil sont fréquents chez les étudiants. Nous pouvons en parler lors d''une consultation.', '2025-03-04 09:00:00'),
(8, 'studen016', 4, NULL, 'J''utilise un agenda papier pour visualiser mon temps, ça change tout!', '2025-03-04 18:45:00'),
(9, 'studen017', 5, NULL, 'C''est tout à fait normal, j''ai ressenti la même chose pendant mes 2 premières années.', '2025-03-05 12:20:00'),
(10, 'conseil05', 5, NULL, 'L''anxiété de performance est courante. N''hésite pas à prendre rendez-vous si tu veux en parler.', '2025-03-05 14:00:00');

-- Insertion des effacements
INSERT INTO Effacer (id_publication, id_commentaire, username, date, raison, type_effacement)
VALUES
(3, NULL, 'mod02', '2025-03-28 09:15:00', 'Publicité non autorisée', 'modérateur'),
(NULL, 2, 'mod03', '2025-03-28 10:00:00', 'Commentaire offensant', 'modérateur'),
(NULL, 6, 'mod01', '2025-03-28 15:30:00', 'Spam de liens externes', 'modérateur'),
(NULL, 8, 'mod03', '2025-03-28 17:50:00', 'Commentaire répétitif', 'modérateur'),
(NULL, 9, 'mod01', '2025-03-28 18:30:00', 'Harcèlement verbal', 'modérateur');


INSERT INTO Reagir_publication (id_publication, username, type_reaction, timestamp) VALUES
(1, 'studen001', 'LIKE', '2025-04-01 10:30:00'),
(1, 'studen002', 'LOVE', '2025-04-01 11:00:00'),
(2, 'studen003', 'SAD', '2025-04-02 09:45:00'),
(2, 'studen004', 'ANGRY', '2025-04-02 14:30:00'),
(3, 'studen005', 'LIKE', '2025-04-03 16:15:00'),
(3, 'studen006', 'LOVE', '2025-04-03 17:20:00'),
(4, 'studen007', 'DISLIKE', '2025-04-04 13:10:00'),
(5, 'studen008', 'LIKE', '2025-04-05 18:30:00'),
(6, 'studen009', 'LOVE', '2025-04-06 12:50:00'),
(7, 'studen010', 'SAD', '2025-04-07 08:00:00');


-- Données pour Reagir_commentaire
INSERT INTO Reagir_commentaire (username, id_commentaire, type_reaction) VALUES
('studen018', 1, 'LIKE'),
('studen019', 1, 'LOVE'),
('studen020', 2, 'LIKE'),
('studen021', 3, 'LIKE'),
('studen022', 4, 'LIKE'),
('studen023', 5, 'LOVE'),
('studen024', 6, 'SAD'),
('studen025', 7, 'LIKE'),
('studen026', 8, 'LIKE'),
('studen027', 9, 'LOVE'),
('studen028', 10, 'LIKE'),
('studen029', 1, 'LOVE'),
('studen030', 2, 'LIKE'),
('conseil02', 3, 'LIKE'),
('conseil03', 4, 'LOVE');

-- Données pour Reserver
INSERT INTO Reserver (username_etudiant, username_conseiller, date, heure_debut, heure_fin, statut, raison) VALUES
('studen001', 'conseil05', '2025-05-30', '10:00:00', '10:45:00', 'Confirmé', 'Crise d''angoisse récurrente'),
('studen002', 'conseil01', '2025-05-28', '14:00:00', '14:30:00', 'Confirmé', 'Épisode dépressif persistant');

CREATE TABLE Indisponibilites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username_conseiller VARCHAR(50),
    date DATE NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    raison VARCHAR(255),
    FOREIGN KEY (username_conseiller) REFERENCES Conseillers(username) ON DELETE CASCADE
);

CREATE TABLE Signalements (
    id_signalement INT AUTO_INCREMENT PRIMARY KEY,
    id_publication INT NULL,
    id_commentaire INT NULL,
    username VARCHAR(50) NOT NULL,
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    raison TEXT NOT NULL,
    est_traite BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_publication) REFERENCES Publications(id_publication)
        ON DELETE CASCADE,
    FOREIGN KEY (id_commentaire) REFERENCES Commentaires(id_commentaire)
        ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES Utilisateurs(username)
        ON DELETE CASCADE
);


-- Triggers
DELIMITER $$
CREATE TRIGGER trig_prevent_double_booking
BEFORE INSERT ON Reserver
FOR EACH ROW
BEGIN
    IF NEW.heure_debut >= NEW.heure_fin THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Heure de début doit être strictement inférieure à heure de fin.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Reserver
        WHERE date = NEW.date
          AND (
               username_conseiller = NEW.username_conseiller
               OR username_etudiant = NEW.username_etudiant
              )
          AND (NEW.heure_debut < heure_fin AND NEW.heure_fin > heure_debut)
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chevauchement détecté : le conseiller ou l''étudiant a déjà un rendez-vous sur ce créneau.';
    END IF;
END$$
DELIMITER ;

-- Triggers de mise à jour des réactions
DELIMITER $$
CREATE TRIGGER trig_update_reaction_count
AFTER INSERT ON Reagir_commentaire
FOR EACH ROW
BEGIN
    UPDATE Commentaires
    SET nb_reactions = nb_reactions + 1
    WHERE id_commentaire = NEW.id_commentaire;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trig_update_reaction_count_delete
AFTER DELETE ON Reagir_commentaire
FOR EACH ROW
BEGIN
    UPDATE Commentaires
    SET nb_reactions = nb_reactions - 1
    WHERE id_commentaire = OLD.id_commentaire;
END$$
DELIMITER ;

-- Procédure pour annuler un rendez-vous
DELIMITER $$
CREATE PROCEDURE annuler_rendezvous(IN p_id_rdv INT, IN p_raison_annulation TEXT)
BEGIN
    UPDATE Reserver
    SET statut = 'Annulé'
    WHERE id_rdv = p_id_rdv;
END$$
DELIMITER ;


-- Triggers de mise à jour des réactions
DELIMITER $$
CREATE TRIGGER trig_update_reaction_count_publication
AFTER INSERT ON Reagir_publication
FOR EACH ROW
BEGIN
    UPDATE Publications
    SET nb_reactions = nb_reactions + 1
    WHERE id_publication = NEW.id_publication;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trig_update_reaction_count_delete_publication
AFTER DELETE ON Reagir_publication
FOR EACH ROW
BEGIN
    UPDATE Publications
    SET nb_reactions = nb_reactions - 1
    WHERE id_publication = OLD.id_publication;
END$$
DELIMITER ;

DELIMITER $$

CREATE TRIGGER trig_update_nb_reponses
AFTER INSERT ON Commentaires
FOR EACH ROW
BEGIN
    UPDATE Publications
    SET nb_reponses = (SELECT COUNT(*) FROM Commentaires WHERE id_publication = NEW.id_publication)
    WHERE id_publication = NEW.id_publication;
END$$

DELIMITER ;


-- ========================================
-- TABLE LIVRE
-- ========================================
CREATE TABLE IF NOT EXISTS Livre (
    id_livre INT PRIMARY KEY AUTO_INCREMENT,
    nom_livre VARCHAR(100) NOT NULL,
    auteur VARCHAR(100),
    date_publication DATE,
    description VARCHAR(1000),
    editeur VARCHAR(100),
    photo_livre VARCHAR(255)
);

-- ========================================
-- TABLE RECOMMANDER
-- ========================================
CREATE TABLE IF NOT EXISTS Recommander (
    id_livre INT,
    username_conseiller VARCHAR(50),
    PRIMARY KEY (id_livre, username_conseiller),
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (username_conseiller) REFERENCES Conseillers(username) ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER $$

CREATE PROCEDURE AjouterLivre (
    IN p_nom_livre VARCHAR(100),
    IN p_auteur VARCHAR(100),
    IN p_date_publication DATE,
    IN p_description VARCHAR(1000),
    IN p_editeur VARCHAR(100),
    IN p_photo_livre VARCHAR(255)
)
BEGIN
    INSERT INTO Livre (nom_livre, auteur, date_publication, description, editeur, photo_livre)
    VALUES (p_nom_livre, p_auteur, p_date_publication, p_description, p_editeur, p_photo_livre);
END$$

CREATE PROCEDURE RecommanderLivre (
    IN p_id_livre INT,
    IN p_username_conseiller VARCHAR(50)
)
BEGIN
    INSERT INTO Recommander (id_livre, username_conseiller)
    VALUES (p_id_livre, p_username_conseiller);
END$$

CREATE PROCEDURE RechercherLivresParConseiller (
    IN p_username_conseiller VARCHAR(50)
)
BEGIN
    SELECT L.*
    FROM Livre L
    JOIN Recommander R ON L.id_livre = R.id_livre
    WHERE R.username_conseiller = p_username_conseiller;
END$$

DELIMITER ;

-- ========================================
-- PEUPLEMENT
-- ========================================

-- Livres
INSERT INTO Livre (nom_livre, auteur, date_publication, description, editeur, photo_livre)
VALUES
('Les 4 accords toltèques', 'Don Miguel Ruiz', '2000-05-01', 'Un guide vers la liberté personnelle basé sur la sagesse toltèque.', 'Jouvence', NULL),
('Ta deuxième vie commence quand tu comprends que tu n’en as qu’une', 'Raphaëlle Giordano', '2015-06-17', 'Un roman feel-good qui mêle développement personnel et fiction.', 'Eyrolles', NULL),
('Le pouvoir du moment présent', 'Eckhart Tolle', '1997-08-29', 'Un guide vers la pleine conscience et l’instant présent.', 'J’ai Lu', NULL),
('Imparfaits, libres et heureux', 'Christophe André', '2006-01-03', 'Pratique de l’estime de soi à travers la psychologie positive.', 'Odile Jacob', NULL),
('Cessez d’être gentil, soyez vrai !', 'Thomas d’Ansembourg', '2001-03-15', 'Un livre sur la communication authentique et bienveillante.', 'Les Éditions de l’Homme', NULL);

-- Recommandations
INSERT INTO Recommander (id_livre, username_conseiller)
VALUES
(1, 'conseil01'),
(2, 'conseil02'),
(3, 'conseil03'),
(4, 'conseil04'),
(5, 'conseil05');

DELIMITER $$
CREATE TRIGGER update_nb_reponses_on_suppression
AFTER UPDATE ON Commentaires
FOR EACH ROW
BEGIN
  IF OLD.status_suppression = FALSE AND NEW.status_suppression = TRUE THEN
    UPDATE Publications
    SET nb_reponses = nb_reponses - 1
    WHERE id_publication = NEW.id_publication;
  ELSEIF OLD.status_suppression = TRUE AND NEW.status_suppression = FALSE THEN
    UPDATE Publications
    SET nb_reponses = nb_reponses + 1
    WHERE id_publication = NEW.id_publication;
  END IF;
END$$
DELIMITER ;
