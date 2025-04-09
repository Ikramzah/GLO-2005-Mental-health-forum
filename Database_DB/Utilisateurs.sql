USE MENTALHEALTH_DB;

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

-- Vérification de l'âge minimum
ALTER TABLE Utilisateurs
ADD CONSTRAINT chk_age_minimum
CHECK (
  date_de_naissance <= DATE_SUB(CURRENT_DATE(), INTERVAL 18 YEAR)
  OR date_de_naissance IS NULL
);

-- Indexation pour optimisation
CREATE INDEX idx_utilisateurs_email ON Utilisateurs(email);
CREATE INDEX idx_reserver_conseiller_date ON Reserver(username_conseiller, date);
CREATE INDEX idx_reserver_etudiant_date ON Reserver(username_etudiant, date);
CREATE INDEX idx_reserver_date_heure ON Reserver(date, heure_debut, heure_fin);
