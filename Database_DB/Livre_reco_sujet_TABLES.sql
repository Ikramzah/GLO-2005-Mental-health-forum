CREATE TABLE Livre (
    id_livre INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255),
    annee_publication INT,
    genre VARCHAR(100),
    description TEXT
);

CREATE TABLE Recommender (
    id_recommender INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Sujets (
    id_sujet INT PRIMARY KEY AUTO_INCREMENT,
    nom_sujet VARCHAR(100) UNIQUE NOT NULL
);

-- Table d'association pour gérer la relation many-to-many entre Livre et Sujets
CREATE TABLE Livre_Sujet (
    id_livre INT,
    id_sujet INT,
    PRIMARY KEY (id_livre, id_sujet),
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE,
    FOREIGN KEY (id_sujet) REFERENCES Sujets(id_sujet) ON DELETE CASCADE
);

-- Table d'association pour les recommandations (qui recommande quel livre)
CREATE TABLE Recommandation (
    id_recommender INT,
    id_livre INT,
    date_recommandation DATE DEFAULT CURDATE(),
    PRIMARY KEY (id_recommender, id_livre),
    FOREIGN KEY (id_recommender) REFERENCES Recommender(id_recommender) ON DELETE CASCADE,
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE
);
