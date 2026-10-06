# Feuille de route du prototype

Oct 9, 2026 · @Jordan

Le prototype se construit en six étapes, chacune jouable, dans l'ordre où on les réalisera. Chaque étape pose une seule question et ne construit que ce qu'il faut pour y répondre. Elle s'appuie sur le GDD v0.1 et les Décisions techniques v0.1 ; les numéros (#) renvoient à l'onglet Technique. Les chiffres d'échelle restent dans le GDD.

## Principes

- **Toujours jouable** : chaque étape se termine par une version qu'on prend en main, à la manette ou au clavier, et non par une démo technique.
- **Une question par étape** : on construit le minimum pour y répondre. Le reste attend l'étape où il devient la question.
- **Volumes simples** : îles et repères en greybox, rendu stylisé de base ; la direction artistique finale est hors prototype.
- **Tester sans expliquer** : le jeu s'enseigne par le monde. À chaque étape, au moins un essai avec quelqu'un à qui l'on ne dit rien : on observe ce qu'il fait, puis on lui demande ce qu'il a compris.
- **Si la réponse est non, on règle, on n'ajoute pas** : on ajuste les réglages de l'étape (panneau de debug) avant de passer à la suivante.

## Vue d'ensemble

| Étape | Ce qu'on joue | La question | Phase |
| --- | --- | --- | --- |
| 1. La mer seule | On se déplace librement à hauteur de pont sur une mer du large | La houle se lit-elle à 3 m, et le jeu sait-il exactement où est l'eau ? | Fondation |
| 2. Le bateau | On pilote le voilier sur le large, d'une bouée à l'autre | Piloter est-il agréable après quelques minutes ? | Ressenti |
| 3. Le récif et la marée | On rejoint une lagune cachée derrière un récif | Le joueur lit-il le récif et la marée, et choisit-il seul sa façon de passer ? | Océan et level design |
| 4. Les quatre mers | On rejoint des îles à travers les quatre zones | Chaque zone se reconnaît-elle de loin et change-t-elle la route ? | Océan et level design |
| 5. La tempête | Une tempête traverse la carte pendant qu'on navigue | La tempête s'annonce-t-elle assez tôt pour décider, et est-elle féroce mais juste ? | Océan et level design |
| 6. La sortie en mer | Le monde complet : partir, viser une île, accoster | Lire la mer est-il agréable et laisse-t-il de vrais choix ? | Monde |

## Étape 1 — La mer seule

**Ce qu'on joue** : une caméra à la première personne, à environ 3 m au-dessus de l'eau, qu'on déplace librement à vitesse de bateau sur une mer du large qui couvre tout le monde. Quelques bouées flottent : ce sont les sondes CPU, rendues visibles. On peut avancer ou accélérer l'heure.

**La question** : à hauteur de pont, la houle se lit-elle (direction, taille, rythme), et le jeu sait-il exactement où est l'eau ?

**À concevoir a minima**

- Horloge du monde, avec facteur de vitesse et saut à un instant (#16).
- Fonction hauteur(x, z, t) partagée entre shader et GDScript, calée sur la taille du monde : une ou deux houles pondérées pour le large, la banque montée jusqu'à 6 pour mesurer ce qu'elle coûte (#1, #2).
- Maillage centré sur la caméra, avec ses anneaux de LOD (#4).
- Superposition de debug et panneau de réglage : horloge, vitesse du temps, poids des houles (#23) ; relevé par image du temps GPU de l'eau et du temps CPU des sondes, pas seulement un compteur d'images par seconde (#24).

**Ce qu'on teste (ressenti)**

- Depuis 3 m, distingue-t-on la direction des crêtes et leur période sans aide ?
- La mer paraît-elle vivante, sans répétition visible ni crêtes qui se replient ?

**On répond oui quand**

- Les bouées collent à l'eau rendue, à vitesse ×1 comme ×100.
- Un testeur indique d'où vient la houle et sa hauteur approximative, sans indice.
- On tient 60 images par seconde en 1080p sur la machine de référence, banque à 6 houles, dans le budget de #24.

**À trancher pendant l'étape** : le nombre de houles tenable sur la machine de référence — on part de 6 et on relève l'image avant d'en ajouter (#1, #24).

**Laissé de côté** : le bateau, les zones, la marée, la tempête, le passage d'un bord du monde à l'autre (étape 6).

## Étape 2 — Le bateau

**Ce qu'on joue** : le voilier sur le large, par vent fort et régulier. Quelques bouées à rejoindre, dont une face au vent, une île en volume simple pour se repérer, et le point de réapparition.

**La question** : après quelques minutes, piloter est-il agréable, et le joueur comprend-il seul qu'il doit louvoyer pour remonter au vent ?

**À concevoir a minima**

- Flottaison sur 4 à 8 points (#9) ; eau sur le pont qui s'évacue d'elle-même ; chavirage au-delà d'un seuil, avec retour au point de réapparition.
- Caméra à 3 m qui ne reprend qu'une partie du roulis, et son option de confort (#12).
- Voile par allures : courbe polaire, zone morte de 45°, border et choquer, barre, gîte (#10).
- Déplacement sur le pont, prise de poste à la barre et à l'écoute, mêmes actions à la manette et au clavier (#11).
- Girouette et boussole ; son du vent dans la voile (#22).
- Un seul vent pour tout le monde : la carte des zones vient à l'étape 3.

**Ce qu'on teste (ressenti)**

- La sensation de vitesse depuis le pont.
- Le lien entre réglage et résultat : sent-on la voile qui porte, la gîte, le bateau qui accélère ?
- La houle par le travers : le roulis prévient-il avant que l'eau n'embarque ?
- Le confort : on pousse la houle à 8–10 m au panneau de debug, pour tester tôt la caméra dans des vagues de tempête.

**On répond oui quand**

- Un testeur rejoint la bouée au vent sans explication.
- Il a envie de continuer à naviguer, même sans but.
- Le chavirage n'arrive qu'après des erreurs accumulées, et le testeur sait dire pourquoi.

**À trancher pendant l'étape** : la tolérance de l'eau sur le pont ; l'horloge du monde après un chavirage (remise à zéro ou non).

**Laissé de côté** : les zones, la marée, la tempête.

## Étape 3 — Le récif et la marée

**Ce qu'on joue** : le large, une île entourée d'un récif et de sa lagune, et un objectif : accoster dans la lagune. Un chenal court ne passe qu'à marée haute ; le tour par le large est long mais sûr ; on peut aussi jeter l'ancre et attendre.

**La question** : le joueur lit-il de loin le récif et l'état de la marée, et choisit-il seul entre le chenal, le tour ou l'attente ?

**À concevoir a minima**

- Carte des zones, large et récif, lue par le shader et le CPU (#3).
- Carte de profondeur et masque d'abri : vagues qui se raidissent puis déferlent sur le récif, lagune calme, chenaux sans déferlantes (#5).
- Rendu lisible : couleur par bandes selon la profondeur, écume sur les crêtes et le récif (#6).
- Marée globale (#7) ; chenal praticable selon la profondeur sous la coque, bande de pleine mer sur la roche (#8).
- Jeter l'ancre accélère le temps (#11, #16).
- Toucher le fond ou prendre une déferlante envoie de l'eau sur le pont.
- Îles en volumes simples (#21) ; son des déferlantes placé sur le récif (#22).

**Ce qu'on teste (ressenti)**

- De loin, voit-on la ligne de déferlantes et le chenal plus sombre ?
- En regardant la roche, sait-on si le chenal est ouvert, et si la marée monte ou descend ?
- Attendre à l'ancre est-il une vraie décision, sans ennui ?

**On répond oui quand**

- Plusieurs testeurs prennent des routes différentes et savent expliquer leur choix.
- Celui qui touche le fond comprend pourquoi et réessaie autrement.

**À trancher pendant l'étape** : le facteur d'accélération du temps à l'ancre (#16).

**Laissé de côté** : la mer croisée, le détroit, la tempête.

## Étape 4 — Les quatre mers

**Ce qu'on joue** : un coin du monde où les quatre zones sont voisines, avec deux ou trois îles à rejoindre et plusieurs routes possibles vers chacune.

**La question** : chaque zone se reconnaît-elle de loin, et le vent et le courant font-ils choisir une route plutôt qu'une autre ?

**À concevoir a minima**

- Carte des zones complète : le large, le récif, la mer croisée (deuxième houle de même poids), le détroit, avec des transitions douces (#3).
- Vent dominant par zone, rangé dans la même carte (#13).
- Courant du détroit : une force sur le bateau, avec traînées d'écume et remous dans son sens (#9, #6).
- Un ou deux repères verticaux en volumes simples pour se situer.

**Ce qu'on teste (ressenti)**

- Le contraste entre zones : crêtes rangées du large, surface hachée de la mer croisée, remous du détroit.
- Le détroit dans le bon sens donne-t-il une vraie sensation de vitesse ? À contre-courant, comprend-on pourquoi on n'avance pas ?
- La mer croisée est-elle inconfortable sans devenir injouable ?

**On répond oui quand**

- Un testeur décrit les quatre zones en les voyant de loin, avant de les avoir traversées.
- Pour un même trajet, il change de route selon le vent et le sens du courant.

**Laissé de côté** : la tempête, la disposition finale du monde.

## Étape 5 — La tempête

**Ce qu'on joue** : la carte de l'étape 4, traversée par une tempête sur un trajet fixe, et une destination située de l'autre côté de son passage.

**La question** : la tempête s'annonce-t-elle assez tôt pour qu'on décide (fuir, s'abriter, traverser ou s'en servir), et la traverser est-il féroce mais juste ?

**À concevoir a minima**

- Tempête déterministe : position fonction du temps, trajet qui boucle sur le tore (#14).
- Houle de tempête courte et raide, en séries de grosses vagues séparées par des accalmies (#1).
- Vent qui tourne et se renforce vers le centre (#13).
- Annonce par paliers : masse nuageuse, lumière qui baisse, pluie, houle qui grossit en périphérie (#15) ; grondement placé au centre (#22).
- Déferlement près du bateau : écume, poussée, roulis et eau sur le pont (#14).

**Ce qu'on teste (ressenti)**

- Peur et maîtrise : lever la tête pour voir la crête, sentir la série arriver puis l'accalmie.
- Le confort de la caméra dans les grandes vagues (#12).
- L'opportunité : le vent fort donne-t-il envie de s'en servir pour aller plus vite ?

**On répond oui quand**

- Le testeur voit la tempête et prend une décision avant d'y entrer.
- Un naufrage dans la tempête est vécu comme une erreur de sa part, pas comme une injustice.
- Personne n'est gêné physiquement par la caméra.

**Laissé de côté** : l'œil de la tempête, plusieurs tempêtes.

## Étape 6 — La sortie en mer

**Ce qu'on joue** : le prototype complet. Le monde qui boucle sur lui-même, les quatre zones à leur place, la marée, la tempête, quelques îles. On part du point de réapparition, on choisit une destination au loin, on accoste.

**La question** : celle du GDD. Lire les informations de navigation est-il agréable, et laisse-t-il de vrais choix : quel passage prendre, à quel moment passer, quelle route selon le vent ?

**À concevoir a minima**

- La disposition des zones, des îles et des repères verticaux sur tout le monde.
- La distance de vue et le brouillard (#19) ; ce qu'on voit à travers la couture du tore (#18) ; îles lointaines simplifiées.
- Passage invisible d'un bord du monde à l'autre (#17), après avoir tranché l'approche du tore, A ou B.
- Des repères verticaux lisibles avant les îles qu'ils signalent.
- Accoster suffit : atteindre la côte d'une île est l'objectif.

**Ce qu'on teste (ressenti)**

- La durée réelle d'une traversée et le sentiment d'explorer.
- Regarder au loin pour choisir sa destination et tracer sa route.
- Comprendre que le monde est fini et qu'on peut en faire le tour.
- Franchir le bord du monde passe-t-il inaperçu, pour l'eau comme pour la caméra ?

**On répond oui quand** : les deux critères de réussite du GDD sont remplis, prise en main jouissive et vraies décisions, avec des testeurs qui n'ont joué à aucune étape précédente.

**Laissé de côté** : tout le hors-périmètre du GDD (enquête, indices et journal de bord, exploration à pied, dégâts et réparation, jour et nuit, menus).
