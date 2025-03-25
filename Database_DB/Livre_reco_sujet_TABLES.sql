-- Table Utilisateurs
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
    statut_etudiant Enum('international', 'en echange', 'citoyen', 'resident permanent') NOT NULL,
    niveau_anonymat ENUM('anonyme', 'pseudo', 'public') DEFAULT 'pseudo',
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE
);

-- Table Moderateur
CREATE TABLE Moderateur (
    username VARCHAR(50) PRIMARY KEY,
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE
);

-- Table Reserver
CREATE TABLE Reserver (
    id_rdv INT AUTO_INCREMENT PRIMARY KEY,
    username_conseiller VARCHAR(50),
    username_etudiant VARCHAR(50),
    date DATE NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    statut ENUM('confirme', 'annule', 'en attente') DEFAULT 'en attente',
    FOREIGN KEY (username_conseiller) REFERENCES Conseillers(username) ON DELETE CASCADE,
    FOREIGN KEY (username_etudiant) REFERENCES Etudiants(username) ON DELETE CASCADE
);

-- Contraintes supplémentaires
ALTER TABLE Reserver
ADD CONSTRAINT chk_heure
CHECK (heure_debut < heure_fin);

ALTER TABLE Reserver
ADD CONSTRAINT chk_date_futur
CHECK (date >= CURRENT_DATE());

ALTER TABLE Utilisateurs
ADD CONSTRAINT chk_age_minimum
CHECK (
  date_de_naissance <= DATE_SUB(CURRENT_DATE(), INTERVAL 18 YEAR)
  OR date_de_naissance IS NULL
);

-- Trigger pour éviter les doubles réservations
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
            SET MESSAGE_TEXT = 'Chevauchement détecté : le conseiller ou l\'étudiant a déjà un rendez-vous sur ce créneau.';
    END IF;
END$$
DELIMITER ;

-- Indexation pour optimisation du système
CREATE INDEX idx_utilisateurs_email ON Utilisateurs(email);
CREATE INDEX idx_reserver_conseiller_date ON Reserver(username_conseiller, date);
CREATE INDEX idx_reserver_etudiant_date ON Reserver(username_etudiant, date);
CREATE INDEX idx_reserver_date_heure ON Reserver(date, heure_debut, heure_fin);
