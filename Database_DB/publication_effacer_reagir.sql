CREATE TABLE Publications (
    id_publication INT AUTO_INCREMENT PRIMARY KEY,   
    username VARCHAR(50) NOT NULL,                   
    p_titre TEXT NOT NULL,                            
    texte TEXT NOT NULL,                              
    date DATETIME DEFAULT CURRENT_TIMESTAMP,          
    statut ENUM('anonyme', 'public') DEFAULT 'public',
    nb_reponses INT DEFAULT 0,                        
    nb_reaction INT DEFAULT 0,                        
    images LONGBLOB,      
);
CREATE TABLE Reagir_publication (
    id_reaction INT AUTO_INCREMENT PRIMARY KEY,
    id_publication INT NOT NULL,   
    id_utilisateur VARCHAR(50) NOT NULL,  
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    raison TEXT NULL,              
    FOREIGN KEY (id_publication) REFERENCES Publications(id_publication) ON DELETE CASCADE,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateurs(username) ON DELETE CASCADE
);


CREATE TABLE Effacer (
    id_effacement INT AUTO_INCREMENT PRIMARY KEY,
    id_publication INT NULL,       
    id_commentaire INT NULL,         
    id_utilisateur VARCHAR(50) NOT NULL, 
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    raison TEXT NOT NULL,             
    FOREIGN KEY (id_publication) REFERENCES Publications(id_publication) ON DELETE CASCADE,
    FOREIGN KEY (id_commentaire) REFERENCES Commentaires(id_commentaire) ON DELETE CASCADE,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateurs(username) ON DELETE CASCADE
);

INSERT INTO Publications (username, p_titre, texte, statut, date) VALUES
('studen001', 'Stress avant les examens', 'Je me sens dépassé par la charge de travail, comment gérez-vous le stress avant les examens?', 'public', '2025-03-01 14:30:00'),
('studen002', 'Difficultés d''adaptation', 'Je suis nouveau à l''université et j''ai du mal à m''intégrer. Des conseils?', 'public', '2025-03-02 09:15:00'),
('studen003', 'Problèmes de sommeil', 'Depuis le début de la session, je dors très mal. Est-ce que d''autres vivent la même chose?', 'anonyme', '2025-03-03 22:45:00'),
('studen004', 'Gestion du temps', 'Comment faites-vous pour équilibrer études, travail et vie sociale?', 'public', '2025-03-04 16:20:00'),
('studen005', 'Anxiété de performance', 'J''ai peur de ne pas être à la hauteur malgré mes bons résultats. Est-ce normal?', 'pseudo', '2025-03-05 11:10:00'),
('studen006', 'Solitude sur le campus', 'Je me sens seul même entouré de gens. Des suggestions pour briser la glace?', 'public', '2025-03-06 18:30:00'),
('studen007', 'Choix de carrière', 'Je doute de mon choix de programme. Comment prendre une décision éclairée?', 'public', '2025-03-07 13:25:00'),
('studen008', 'Problèmes financiers', 'Je peine à joindre les deux bouts. Des ressources pour les étudiants dans le besoin?', 'anonyme', '2025-03-08 20:15:00'),
('studen009', 'Concentration en cours', 'J''ai du mal à rester concentré pendant les longs cours. Des techniques qui fonctionnent?', 'public', '2025-03-09 10:05:00'),
('studen010', 'Équilibre travail-études', 'Mon emploi à temps partiel empiète sur mes études. Comment mieux organiser mon temps?', 'public', '2025-03-10 15:40:00');