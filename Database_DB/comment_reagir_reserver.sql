CREATE TABLE Commentaires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    publication_id INT NOT NULL,
    parent_commentaire_id INT NULL,
    contenu TEXT NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_commentaire_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(id) ON DELETE CASCADE,
    CONSTRAINT fk_commentaire_publication FOREIGN KEY (publication_id) REFERENCES Publications(id) ON DELETE CASCADE,
    CONSTRAINT fk_commentaire_parent FOREIGN KEY (parent_commentaire_id) REFERENCES Commentaires(id) ON DELETE CASCADE
);

CREATE TABLE Reagir (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    commentaire_id INT NOT NULL,
    type_reaction ENUM('LIKE', 'DISLIKE', 'LOVE', 'SAD', 'ANGRY') NOT NULL,
    date_reaction TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reaction_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(id) ON DELETE CASCADE,
    CONSTRAINT fk_reaction_commentaire FOREIGN KEY (commentaire_id) REFERENCES Commentaires(id) ON DELETE CASCADE,
    CONSTRAINT unique_reaction UNIQUE (utilisateur_id, commentaire_id) 
);

CREATE TABLE Reserver (
    id INT AUTO_INCREMENT PRIMARY KEY,
    etudiant_id INT NOT NULL,
    conseiller_id INT NOT NULL,
    date_rdv DATETIME NOT NULL,
    statut ENUM('En attente', 'Confirmé', 'Annulé') DEFAULT 'En attente',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reserver_etudiant FOREIGN KEY (etudiant_id) REFERENCES Utilisateurs(id) ON DELETE CASCADE,
    CONSTRAINT fk_reserver_conseiller FOREIGN KEY (conseiller_id) REFERENCES Conseillers(id) ON DELETE CASCADE,
    CONSTRAINT unique_reservation UNIQUE (etudiant_id, date_rdv)
);
