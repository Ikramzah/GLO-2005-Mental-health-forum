USE MENTALHEALTH_DB;

-- Création de la table Utilisateurs
CREATE TABLE Utilisateurs (
    username VARCHAR(50)  PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    photo_de_profil MEDIUMBLOB,
    date_inscription DATE NOT NULL,
    date_de_naissance DATE,
    lieu_de_residence VARCHAR(100)
);

-- Table Conseillers
CREATE TABLE Conseillers (
    username VARCHAR(50) PRIMARY KEY,
    specialisation VARCHAR(100),
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE
);

-- Table Etudiants
CREATE TABLE Etudiants (
    username VARCHAR(50) PRIMARY KEY,
    statut_etudiant ENUM('international', 'en echange', 'citoyen', 'resident permanent') NOT NULL,
    niveau_anonymat ENUM('anonyme', 'pseudo', 'public') DEFAULT 'pseudo',
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE
);

-- Table Moderateur
CREATE TABLE Moderateur (
    username VARCHAR(50) PRIMARY KEY,
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE
);

-- Insertion des 30 étudiants
INSERT INTO Utilisateurs (username, nom, prenom, email, mot_de_passe, date_inscription, date_de_naissance, lieu_de_residence)
VALUES
('studen001', 'Martin', 'Olivier', 'olivier.martin@example.com', 'mdp123', '2025-01-05', '2002-03-14', 'Montréal'),
('studen002', 'Tremblay', 'Marie', 'marie.tremblay@example.com', 'mdp123', '2025-01-06', '1999-07-22', 'Québec'),
('studen003', 'Gagnon', 'Luc', 'luc.gagnon@example.com', 'mdp123', '2025-01-07', '2001-11-10', 'Laval'),
('studen004', 'Roy', 'Julie', 'julie.roy@example.com', 'mdp123', '2025-01-08', '2003-04-19', 'Gatineau'),
('studen005', 'Bouchard', 'Samuel', 'samuel.bouchard@example.com', 'mdp123', '2025-01-09', '2002-02-28', 'Montréal'),
('studen006', 'Ouellet', 'Chloé', 'chloe.ouellet@example.com', 'mdp123', '2025-01-10', '2000-12-05', 'Sherbrooke'),
('studen007', 'Fortin', 'Antoine', 'antoine.fortin@example.com', 'mdp123', '2025-01-10', '2001-06-15', 'Trois-Rivières'),
('studen008', 'Lapointe', 'Emma', 'emma.lapointe@example.com', 'mdp123', '2025-01-11', '2002-10-02', 'Montréal'),
('studen009', 'Côté', 'Jérôme', 'jerome.cote@example.com', 'mdp123', '2025-01-11', '2001-09-12', 'Chicoutimi'),
('studen010', 'Pelletier', 'Anne', 'anne.pelletier@example.com', 'mdp123', '2025-01-12', '1998-05-23', 'Montréal'),
('studen011', 'Gauthier', 'Éric', 'eric.gauthier@example.com', 'mdp123', '2025-01-12', '2003-03-03', 'Ottawa'),
('studen012', 'Morin', 'Isabelle', 'isabelle.morin@example.com', 'mdp123', '2025-01-13', '2002-07-17', 'Saint-Jérôme'),
('studen013', 'Lavoie', 'Maxime', 'maxime.lavoie@example.com', 'mdp123', '2025-01-13', '2001-08-24', 'Montréal'),
('studen014', 'Campeau', 'Sophie', 'sophie.campeau@example.com', 'mdp123', '2025-01-14', '1999-10-01', 'Drummondville'),
('studen015', 'Leclerc', 'Thomas', 'thomas.leclerc@example.com', 'mdp123', '2025-01-15', '1998-01-30', 'Brossard'),
('studen016', 'Paquet', 'Jeanne', 'jeanne.paquet@example.com', 'mdp123', '2025-01-15', '2000-02-12', 'Montréal'),
('studen017', 'Giroux', 'Alexandre', 'alex.giroux@example.com', 'mdp123', '2025-01-16', '2001-08-08', 'Gatineau'),
('studen018', 'Fournier', 'Camille', 'camille.fournier@example.com', 'mdp123', '2025-01-16', '2002-11-20', 'Québec'),
('studen019', 'Gravel', 'David', 'david.gravel@example.com', 'mdp123', '2025-01-17', '2003-01-17', 'Montréal'),
('studen020', 'Beaulieu', 'Sarah', 'sarah.beaulieu@example.com', 'mdp123', '2025-01-17', '1999-04-21', 'Longueuil'),
('studen021', 'Mercier', 'Sébastien', 'sebastien.mercier@example.com', 'mdp123', '2025-01-18', '2001-05-14', 'Châteauguay'),
('studen022', 'Simard', 'Audrey', 'audrey.simard@example.com', 'mdp123', '2025-01-18', '2003-02-02', 'Montréal'),
('studen023', 'Bélanger', 'François', 'francois.belanger@example.com', 'mdp123', '2025-01-19', '2000-08-25', 'Montréal'),
('studen024', 'Bergeron', 'Catherine', 'catherine.bergeron@example.com', 'mdp123', '2025-01-19', '1998-09-27', 'Lévis'),
('studen025', 'Leblanc', 'Nicolas', 'nicolas.leblanc@example.com', 'mdp123', '2025-01-20', '2002-03-01', 'Saint-Hyacinthe'),
('studen026', 'Cyr', 'Valérie', 'valerie.cyr@example.com', 'mdp123', '2025-01-20', '1997-12-11', 'Terrebonne'),
('studen027', 'Dufour', 'Kevin', 'kevin.dufour@example.com', 'mdp123', '2025-01-21', '2000-10-09', 'Montréal'),
('studen028', 'Boisvert', 'Annie', 'annie.boisvert@example.com', 'mdp123', '2025-01-21', '1999-07-30', 'Sherbrooke'),
('studen029', 'Chevalier', 'Jonathan', 'jonathan.chevalier@example.com', 'mdp123', '2025-01-22', '2001-03-13', 'Trois-Rivières'),
('studen030', 'Langlois', 'Karine', 'karine.langlois@example.com', 'mdp123', '2025-01-22', '2002-11-04', 'Québec');

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
('studen030', 'resident permanent', 'public');

-- Insertion des conseillers
INSERT INTO Utilisateurs (username, nom, prenom, email, mot_de_passe, date_inscription, date_de_naissance, lieu_de_residence)
VALUES
('conseil01', 'Arsenault', 'Daniel', 'daniel.arsenault@example.com', 'mdp456', '2025-02-01', '1985-04-12', 'Montréal'),
('conseil02', 'Robert', 'Patricia', 'patricia.robert@example.com', 'mdp456', '2025-02-02', '1979-09-08', 'Québec'),
('conseil03', 'Lefebvre', 'Monique', 'monique.lefebvre@example.com', 'mdp456', '2025-02-03', '1988-11-23', 'Longueuil'),
('conseil04', 'Carpentier', 'Yves', 'yves.carpentier@example.com', 'mdp456', '2025-02-04', '1990-01-15', 'Sherbrooke'),
('conseil05', 'Deschamps', 'Amélie', 'amelie.deschamps@example.com', 'mdp456', '2025-02-05', '1982-03-29', 'Gatineau');

INSERT INTO Conseillers (username, specialisation)
VALUES
('conseil01', 'Orientation académique'),
('conseil02', 'Bourses et financements'),
('conseil03', 'Insertion professionnelle'),
('conseil04', 'Mobilité internationale'),
('conseil05', 'Conseil psychologique');

-- Insertion des modérateurs
INSERT INTO Utilisateurs (username, nom, prenom, email, mot_de_passe, date_inscription, date_de_naissance, lieu_de_residence)
VALUES
('mod01', 'Lévesque', 'Stéphane', 'stephane.levesque@example.com', 'mdp789', '2025-03-01', '1975-12-06', 'Montréal'),
('mod02', 'Desjardins', 'Carole', 'carole.desjardins@example.com', 'mdp789', '2025-03-02', '1980-07-19', 'Québec'),
('mod03', 'Dubois', 'Frédéric', 'frederic.dubois@example.com', 'mdp789', '2025-03-03', '1972-05-11', 'Sherbrooke');

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
