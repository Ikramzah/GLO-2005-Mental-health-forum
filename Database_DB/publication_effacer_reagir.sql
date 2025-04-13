USE MENTALHEALTH_DB;

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

-- Insertion des réactions aux publications
INSERT INTO Reagir_publication (id_publication, username, type_reaction)
VALUES
(1, 'emilie_gagnon', 'LIKE'),
(1, 'marc_leclerc', 'LOVE'),
(2, 'luc_tremblay', 'SAD'),
(3, 'alice_dubois', 'DISLIKE'),
(4, 'sophie_larose', 'ANGRY'),
(5, 'emilie_gagnon', 'LIKE'),
(6, 'marc_leclerc', 'LOVE'),
(7, 'luc_tremblay', 'SAD'),
(8, 'alice_dubois', 'LIKE'),
(9, 'sophie_larose', 'DISLIKE'),
(10, 'emilie_gagnon', 'LOVE');

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

-- Triggers de mise à jour des réactions
DELIMITER $$
CREATE TRIGGER trig_update_reaction_count
AFTER INSERT ON Reagir_publication
FOR EACH ROW
BEGIN
    UPDATE Publications
    SET nb_reactions = nb_reactions + 1
    WHERE id_publication = NEW.id_publication;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trig_update_reaction_count_delete
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

