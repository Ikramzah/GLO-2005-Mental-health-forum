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
