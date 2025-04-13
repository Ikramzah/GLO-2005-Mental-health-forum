USE MENTALHEALTH_DB;

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

ALTER TABLE Reserver
ADD CONSTRAINT chk_date_futur
CHECK (date >= CURRENT_DATE());

-- Données pour Commentaires
INSERT INTO Commentaires (username, id_publication, id_parent_commentaire, contenu, date_creation) VALUES
('studen011', 1, NULL, 'J''utilise la technique Pomodoro pour gérer mon temps d''étude, ça m''aide beaucoup!', '2025-03-01 15:45:00'),
('studen012', 1, NULL, 'N''hésite pas à faire des pauses et à bouger un peu, ça aide à décompresser.', '2025-03-01 16:20:00'),
('studen013', 1, 1, 'Je ne connaissais pas Pomodoro, merci pour le conseil!', '2025-03-01 17:30:00'),
('studen014', 2, NULL, 'Participe aux activités organisées par ton association étudiante, c''est un bon moyen de rencontrer des gens.', '2025-03-02 10:05:00'),
('conseil01', 2, NULL, 'Nous organisons des sessions de bienvenue chaque semaine, viens nous voir au centre d''orientation!', '2025-03-02 11:15:00'),
('studen015', 3, NULL, 'J''ai le même problème depuis que j''ai commencé à boire du café l''après-midi.', '2025-03-03 23:30:00'),
('conseil05', 3, NULL, 'Les problèmes de sommeil sont fréquents chez les étudiants. Nous pouvons en parler lors d''une consultation.', '2025-03-04 09:00:00'),
('studen016', 4, NULL, 'J''utilise un agenda papier pour visualiser mon temps, ça change tout!', '2025-03-04 18:45:00'),
('studen017', 5, NULL, 'C''est tout à fait normal, j''ai ressenti la même chose pendant mes 2 premières années.', '2025-03-05 12:20:00'),
('conseil05', 5, NULL, 'L''anxiété de performance est courante. N''hésite pas à prendre rendez-vous si tu veux en parler.', '2025-03-05 14:00:00');

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
('studen001', 'conseil05', '2025-03-15', '10:00:00', '10:45:00', 'Confirmé', 'Crise d''angoisse récurrente'),
('studen002', 'conseil01', '2025-03-16', '14:00:00', '14:30:00', 'Confirmé', 'Épisode dépressif persistant'),
('studen003', 'conseil05', '2025-03-17', '11:00:00', '11:45:00', 'En attente', 'Insomnie liée au stress'),
('studen004', 'conseil03', '2025-03-18', '15:00:00', '15:30:00', 'Confirmé', 'Difficulté à gérer mes émotions'),
('studen005', 'conseil05', '2025-03-19', '09:30:00', '10:15:00', 'Annulé', 'Peur de l''échec paralysante'),
('studen006', 'conseil02', '2025-03-20', '13:00:00', '13:45:00', 'En attente', 'Sentiment d''isolement social'),
('studen007', 'conseil01', '2025-03-21', '10:00:00', '10:30:00', 'Confirmé', 'Troubles alimentaires récents'),
('studen008', 'conseil04', '2025-03-22', '14:30:00', '15:15:00', 'Confirmé', 'Burnout académique'),
('studen009', 'conseil05', '2025-03-23', '11:30:00', '12:15:00', 'En attente', 'Pensées négatives intrusives'),
('studen010', 'conseil03', '2025-03-24', '16:00:00', '16:45:00', 'Confirmé', 'Crise existentielle et perte de motivation');

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
