# Olist - Segmentation des clients E-commerce

## Contexte du Projet
Ce projet a été réalisé dans le cadre d'une mission de conseil pour **Olist**, une entreprise brésilienne proposant une solution de vente sur les marketplaces en ligne. 

L'objectif principal est de fournir à l'équipe Marketing (dirigée par João) une **segmentation client actionnable** pour optimiser leurs campagnes de communication, tout en proposant un **contrat de maintenance** basé sur l'analyse de l'obsolescence du modèle dans le temps.

## Objectifs
1. **Extraction et Préparation des données :** Création d'une base de données clients avec des features pertinentes (RFM + Satisfaction).
2. **Modélisation Non-Supervisée :** Utilisation d'algorithmes de Machine Learning pour identifier des profils clients distincts.
3. **Traduction Métier :** Fournir des personae clairs et exploitables pour le marketing (ex: Champions, Endormis, Nouveaux).
4. **Simulation de Maintenance :** Analyser la dérive des comportements (Concept Drift) pour recommander une fréquence de ré-entraînement du modèle.

## Technologies Utilisées
* **Langages :** Python, SQL (SQLite)
* **Manipulation de Données :** Pandas, NumPy
* **Machine Learning :** Scikit-learn (K-Means, StandardScaler, Silhouette Score, Adjusted Rand Index)
* **Visualisation :** Matplotlib, Seaborn, Plotly (Profils Radar)

## Structure du Dépôt

Le projet est divisé en 4 parties distinctes, respectant la convention PEP8 :

* `Judith_Samuel_1_script_052025.sql` : Requêtes SQL pour la consolidation des données et l'alimentation du dashboard Customer Experience de Fernanda.
* `Judith_Samuel_2_notebook_exploration_052025.ipynb` : Notebook d'Analyse Exploratoire des Données (EDA), nettoyage et traitement des valeurs aberrantes (Z-score).
* `Judith_Samuel_3_notebook_essais_052025.ipynb` : Notebook de modélisation. Feature engineering (Matrice RFM + Satisfaction), standardisation, optimisation (Méthode du Coude, Silhouette) et clustering avec K-Means (K=5).
* `Judith_Samuel_4_notebook_simulations_052025.ipynb` : Notebook de simulation temporelle. Calcul de l'évolution du score ARI mois par mois pour évaluer la dérive des clusters et justifier le délai de maintenance (estimé à 4 mois).

## Résultats Principaux
L'algorithme K-Means a permis de dégager **5 segments clients distincts** avec une excellente compacité et séparation. Ces segments ont été traduits en profils marketing via des graphiques en radar.
L'étude de stabilité temporelle (score ARI) démontre une chute de la pertinence des segments initiaux sous le seuil d'acceptabilité après **1 mois**, déclenchant ainsi le besoin d'un ré-entraînement automatisé.

## Installation & Exécution
1. Cloner ce dépôt : `git clone https://github.com/sam974/p5-customer-segmentation.git`
2. Les données initiales (base SQLite) doivent être placées dans le dossier d'input approprié (non incluses dans ce dépôt par souci de confidentialité).
3. Installer les dépendances : `pip install -r requirements.txt` *(si tu as généré ce fichier, sinon tu peux supprimer cette ligne)*
4. Exécuter les notebooks dans l'ordre (Exploration > Essais > Simulation).