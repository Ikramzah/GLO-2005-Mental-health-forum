# USafeForum 🧠💬  
**Plateforme web de soutien psychologique pour étudiants universitaires**

🎓 Projet académique – **GLO-2005 : Modèles et langages des bases de données pour l’ingénierie**

🎥 **Vidéo de démonstration** :  
👉 [https://www.youtube.com/](https://www.youtube.com/watch?v=_MLxOdztJqU)

---

## 📌 Description du projet
USafeForum est une application web conçue pour offrir un espace **sécurisé, structuré et accessible** de soutien psychologique aux étudiants universitaires.

La plateforme permet :
- la publication et le partage de contenus (anonymes ou identifiés),
- l’interaction via commentaires et réactions,
- la modération du contenu,
- la réservation de rendez-vous avec des conseillers,
- la recommandation de livres spécialisés en santé mentale.

Le projet met un accent particulier sur la **conception de la base de données**, l’intégrité des données, la sécurité et la performance.

---

## 🏗️ Architecture du système
Le système est organisé selon une architecture **3-tiers** :

- **Frontend** : HTML / CSS  
- **Backend** : Python (Flask)  
- **Base de données** : MySQL  

---

## 🧩 Modélisation des données
- Modèle entité-relation complet
- Héritage entre utilisateurs (Étudiants, Conseillers, Modérateurs)
- Relations complexes (réactions, signalements, réservations, recommandations)
- Normalisation jusqu’à la **FNBC (Boyce-Codd)**

---

## 🛠️ Fonctionnalités principales
- Gestion des utilisateurs et rôles
- Publications et commentaires hiérarchiques
- Réactions et signalements
- Modération du contenu
- Réservation de rendez-vous
- Recommandation de livres
- Réinitialisation sécurisée des mots de passe

---

## ⚙️ Base de données & SQL avancé
- Requêtes complexes (jointures, sous-requêtes, agrégations)
- **Triggers SQL** :
  - validation de l’âge (> 18 ans)
  - prévention des conflits de réservation
  - mise à jour automatique des statistiques
- **Procédures stockées**
- Indexation avancée pour l’optimisation des performances

---

## 🔐 Sécurité
- Hachage sécurisé des mots de passe (Werkzeug – `generate_password_hash`)
- Requêtes paramétrées (prévention SQL injection)
- Validation stricte des données côté serveur
- Gestion sécurisée des uploads de fichiers

---

## 🧪 Tests
- Tests manuels fonctionnels
- Validation des permissions par rôle
- Tests de conflits de réservation
- Vérification des flux critiques (authentification, modération, reset password)

---

## ♿ Accessibilité
- Interface claire et intuitive
- Compatible avec navigateurs récents
- Pistes d’amélioration identifiées pour les futures versions

---

## 👩‍💻 My Contribution
Dans ce projet d’équipe, j’ai contribué notamment à :
- la conception du modèle de données,
- l’implémentation de tables SQL et contraintes,
- l’écriture de requêtes complexes et triggers,
- le développement backend (Flask),
- la sécurité des données et validations,
- la rédaction du rapport technique.

---

## 👥 Équipe
Projet réalisé en équipe de 4 personnes dans le cadre du cours **GLO-2005** à l’Université Laval.

---

## 📚 Technologies utilisées
- Python (Flask)
- MySQL
- SQL (triggers, procédures, index)
- HTML / CSS
- Werkzeug (sécurité)

