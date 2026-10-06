# Phase 2 — Ressenti

**Objectif** : que piloter soit agréable après quelques minutes (critère « prise en main jouissive »). Cette phase s'appuie sur la fonction de hauteur et l'horloge de la phase 1.

| # | Domaine | Problématique | Décision v0.1 | Statut |
| --- | --- | --- | --- | --- |
| 9 | Navigation | Flottaison | RigidBody3D avec 4 à 8 points de flottaison sur la coque, qui interrogent hauteur(x, z, t). Poussée simplifiée et amortissement fort : stable avant d'être réaliste. Eau sur le pont et chavirage suivent les règles du Système océan (GDD) : un niveau d'eau sur le pont, qui alourdit le bateau et se vide avec le temps ; chavirage seulement au-delà d'un seuil, avec retour au point de réapparition. Le courant du détroit, lu dans la carte des zones, s'applique au bateau comme une force horizontale ; à l'ancre, le bateau est retenu sur place. | Départ |
| 12 | Navigation | Caméra | Yeux à ≈ 3 m, champ de vision de 75° réglable. La caméra ne reprend qu'une partie du roulis du bateau (≈ 40 %), amortie. Option de confort pour réduire encore le mouvement, prioritaire : en tempête, le bateau monte et descend de 8 à 10 m toutes les 7 s environ ; à tester tôt. | Départ |
| 10 | Navigation | Modèle de voile | Modèle par allures : la vitesse dépend de l'angle du vent apparent, via une courbe polaire simple (Curve). Zone morte de 45° face au vent, qui oblige à louvoyer. Un seul réglage de voile (border / choquer) et une barre. La gîte croît avec la force du vent dans la voile. | Départ |
| 11 | Navigation | Agir sur un pont qui bouge | Le joueur se déplace dans le repère du bateau. Il « prend le poste » à la barre ou à l'écoute, et les commandes changent alors. Jeter ou lever l'ancre est une action du pont. Mêmes actions à la manette et au clavier. | Départ |
| 22 | Son | Sons informatifs | Sons spatialisés (AudioStreamPlayer3D) : vent dans la voile selon le vent apparent, déferlantes placées sur le récif, grondement placé au centre de la tempête. | Départ |
