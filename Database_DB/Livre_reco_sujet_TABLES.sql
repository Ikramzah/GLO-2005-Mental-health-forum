USE MENTALHEALTH_DB;

-- Table Livre
CREATE TABLE IF NOT EXISTS Livre (
    id_livre INT PRIMARY KEY AUTO_INCREMENT,
    nom_livre VARCHAR(100) NOT NULL,
    auteur VARCHAR(100),
    date_publication DATE,
    description VARCHAR(1000),
    editeur VARCHAR(100),
    photo_livre VARCHAR(255)
);

-- Table Recommander
CREATE TABLE IF NOT EXISTS Recommander (
    id_livre INT,
    username_conseiller VARCHAR(50),
    PRIMARY KEY (id_livre, username_conseiller),
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (username_conseiller) REFERENCES Conseillers(username) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table Sujets
CREATE TABLE IF NOT EXISTS Sujets (
    id_sujet INT PRIMARY KEY AUTO_INCREMENT,
    titre_sujet VARCHAR(150) NOT NULL UNIQUE,
    id_publication INT,
    username VARCHAR(50),
    date_creation DATE DEFAULT CURDATE(),
    FOREIGN KEY (username) REFERENCES Utilisateurs(username) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_publication) REFERENCES Publications(id_publication) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ========================
-- ROUTINES (PROCÉDURES)
-- ========================

DELIMITER $$

-- Ajouter un nouveau livre
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

-- Associer un livre recommandé à un conseiller
CREATE PROCEDURE RecommanderLivre (
    IN p_id_livre INT,
    IN p_username_conseiller VARCHAR(50)
)
BEGIN
    INSERT INTO Recommander (id_livre, username_conseiller)
    VALUES (p_id_livre, p_username_conseiller);
END$$

-- Obtenir les livres recommandés par un conseiller
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

-- ========================
-- PEUPLEMENT (Données)
-- ========================

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

-- Sujets
INSERT INTO Sujets (titre_sujet, id_publication, username)
VALUES
('Gérer l’anxiété avant les examens', 1, 'studen001'),
('S’adapter à la vie au Québec', 2, 'studen007'),
('Trouver un équilibre études/vie perso', 3, 'studen013'),
('Soutien émotionnel pour étudiants internationaux', 4, 'studen027'),
('Surmonter la solitude en résidence', 5, 'studen022');
