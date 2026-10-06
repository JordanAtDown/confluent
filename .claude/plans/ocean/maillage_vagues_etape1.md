# Master plan — Maillage et vagues (étape 1)

Confluent — GDD v0.1, problématiques #1, #2 et #4.
Version du 10 octobre 2026.

Ce document réunit le contexte, les décisions et les questions ouvertes de l'étape 1. Le détail
de chaque chantier vit dans un plan de phase : on lit le master pour comprendre pourquoi, la phase
pour savoir quoi faire.

---

## Contexte

L'étape 1 de la feuille de route, « La mer seule », demande deux briques qui se tiennent l'une
l'autre : une fonction de hauteur partagée CPU/GPU (#1, #2) et un maillage centré sur la caméra
avec ses anneaux de LOD (#4). Les construire ensemble, c'est ne jamais savoir laquelle est en
cause quand une bouée décroche.

Le plan les sépare donc en deux chantiers isolés, puis les joint.

- Le **maillage** se construit sans vagues, avec un damier en coordonnées monde et un fil de fer
  coloré par anneau pour seuls témoins. Sur une mer plate et unie, un défaut de recalage est
  invisible.
- **Gerstner** se construit sur un plan dense et fixe, avec une seule houle, loin de toute
  complexité de LOD.
- La **jonction** n'arrive qu'en phase C. La banque de houles, le tore, les zones et le battement
  ne sont étoffés qu'après elle.

## Les trois phases

| Phase | Plan | Construit | Prouve |
| --- | --- | --- | --- |
| **A** | [`maillage_vagues_etape1_a_maillage.md`](maillage_vagues_etape1_a_maillage.md) | Plan suiveur, anneaux, recalage d'un bloc, raccords — sans vagues | Le maillage est stable et sans fissure sous un relief fixe |
| **B** | [`maillage_vagues_etape1_b_gerstner.md`](maillage_vagues_etape1_b_gerstner.md) | Une houle de Gerstner, shader et GDScript, sur un plan dense fixe | La fonction hauteur CPU colle au rendu GPU |
| **C** | [`maillage_vagues_etape1_c_jonction.md`](maillage_vagues_etape1_c_jonction.md) | Gerstner sur les anneaux, effacement, raccords, sondes, budget | Les bouées collent sous le bateau, à 60 images/s |

## Ordre et dépendances

```
A (maillage)  ──┐
                ├──►  C (jonction)  ──►  Ensuite (banque, tore, zones, battement)
B (Gerstner)  ──┘
```

- **A et B sont indépendantes** : elles ne partagent aucun fichier et peuvent avancer dans
  n'importe quel ordre, ou en parallèle.
- **C exige A et B terminées.** Elle remplace la sinusoïde de A4 par la fonction de B2 ; sans les
  deux témoins validés, un défaut en C ne se localise plus.
- À l'intérieur d'une phase, l'ordre des étapes est strict : chacune s'appuie sur la précédente.

## Critère de sortie de l'étape 1

Sous le bateau, dans l'anneau fin, les bouées CPU collent à l'eau rendue. C'est le critère
posé en C4 ; le reste de C (effacement, budget) en conditionne la tenue, pas la définition.

## Invariants du projet qui s'appliquent

Rappel de `.claude/rules/ocean.md` et de `CLAUDE.md`, parce que ce plan les touche tous.

- **Déterminisme.** Vagues = fonctions pures de la position et du temps du monde. Pas de
  `randf()`, pas d'état accumulé image par image. D'où le test de saut dans le temps en B2.
- **Une seule horloge** : l'autoload `WorldClock`. Dans un shader, le temps arrive par global
  shader uniform, jamais par `TIME`.
- **`hauteur(x, z, t)` écrite deux fois** (shader et GDScript) depuis les mêmes paramètres, rangés
  dans une `Resource` partagée.
- **Les chiffres sont des `.tres` dans `resources/`**, pas des constantes dans un script. Cela
  vaut pour les valeurs de départ ci-dessous (pas fin, centre, anneaux, seuil d'effacement, houle
  d'essai).
- **Compatibility** : pas de shader de calcul, donc Gerstner en vertex shader.
- **Un enfant ne connaît pas son parent** ; chaque dossier naît avec son premier fichier ; les
  tests miroirs de `src/` vont dans `test/`.

## Valeurs de départ

| Paramètre | Valeur | Vu en |
| --- | --- | --- |
| Pas fin | 0,5 m | A1 |
| Côté du centre fin | 64 m | A1 |
| Anneaux | 6, pas doublé à chaque anneau | A2 |
| Portée | environ 4 km | A2 |
| Sommets | environ 90 000 | A2 |
| Pas de l'anneau le plus grossier | 16 m | A3 |
| Relief d'essai (sinusoïde) | 1 m d'amplitude, 40 m de longueur d'onde | A4 |
| Plan dense de la phase B | 128 m, pas 0,25 m | B |
| Houle d'essai de la jonction | 40 m, 1 m, raideur faible | C1 |
| Seuil d'effacement | environ 4 pas locaux | C2 |
| Cible de performance | 60 images/s, 1080p, sur la machine de référence, caméra à 3 m, regard à l'horizon | C5 |
| Budget GPU de l'eau | 8 ms par image (GDD #24) | C5 |
| Budget CPU des sondes | 2 ms par image, toutes sondes confondues (GDD #24) | C4, C5 |

## Machine de référence et budget

Tranchés dans le GDD (décision #24, statut Décidé, export du 2026-10-10) ; le plan s'y aligne.

- **Machine** : le milieu du parc Steam — RTX 4060 ou RTX 5060 (8 Go de VRAM), 6 à 8 cœurs, 16 Go
  de RAM, Windows 11, écran 1080p.
- **Cible** : 60 images/s en 1080p sur cette machine. Pas de mode dégradé en v0.1.
- **Budget par image, à mesurer et non à supposer** : eau 8 ms sur le GPU, sondes CPU 2 ms. On
  relève le temps GPU de l'eau et le temps CPU des sondes séparément, pas seulement le compteur
  d'images par seconde.
- **Ce que la machine contraint en premier** : le nombre de houles de la banque (6 au départ).
  Cette étape n'en a qu'une ; le budget se re-mesure à chaque houle ajoutée.
- **Hors cible v0.1** : 1440p, 4K, Steam Deck, macOS. Le portable RTX 4060 Laptop n'est vérifié
  qu'à l'étape 5 de la feuille de route.

## Décisions prises

- **Anneaux concentriques retenus.** La grille projetée est écartée : instable quand le point de
  vue bouge, peu détaillée au loin, elle contredit « l'eau ne glisse pas » et la correspondance
  CPU. Le CDLOD n'apporte rien sur une mer sans relief fixe.
- **Progression par paliers**, du plan dense unique aux anneaux : le plan dense valide la fonction
  hauteur avant toute complexité de LOD.
- **Maillage d'abord sans vagues**, avec damier monde et fil de fer par anneau.
- **Gerstner d'abord réduit à une houle** : banque, tore, zones et battement reportés après la
  jonction.
- **Recalage d'un bloc** sur le pas le plus grossier, pour commencer.
- **Effacement des houles courtes côté GPU seulement.** La correspondance exacte n'est exigée que
  sous le bateau.
- **La transition entre anneaux interpole la position complète** du sommet, pas seulement sa
  hauteur.
- **Normales analytiques en fragment**, pas de normal maps à ce stade.

## Questions ouvertes

| # | Question | Phase | Quand la trancher |
| --- | --- | --- | --- |
| 1 | ~~#24, la machine de référence~~ — **tranchée** par le GDD (voir ci-dessus). Plus rien ne bloque le démarrage de l'étape 1 ni C5. | C5 | Résolue le 2026-10-10 |
| 2 | Les valeurs de départ (0,5 m, 64 m, 6 anneaux) tiennent-elles les 8 ms GPU de l'eau, ou faut-il les revoir dès A2 ? | A2 | À la mesure de A2 |
| 3 | Le recalage d'un bloc suffit-il ? Si le centre fin devient trop coûteux en A3, passer au recalage anneau par anneau avec bandes de raccord. | A3 | À la mesure de A3 |
| 4 | Le seuil d'effacement : 4 pas locaux est un point de départ. | C2 | Réglage en C2 |
| 5 | Jusqu'où le CPU reste-t-il fiable ? La mesure de C4 contraint la flottaison (#9) et tout ce qui vivra loin du bateau. | C4 | Mesure de C4 |
| 6 | La raideur maximale est-elle par houle ou cumulée ? B1 donne le seuil d'une houle isolée ; la somme le dépassera. | B1 | À reprendre avec la banque |

## Ensuite

Banque de 6 à 10 houles (départ à 6, montée seulement après mesure dans le budget de #24), calage
sur le tore, poids par zone, battement de tempête — directement sur les anneaux, la jonction étant
validée. Ces sujets auront leur propre plan, hors de l'étape 1.

## Références

- Crest — Technical Documentation : https://crest.readthedocs.io/en/4.9/user/technical-information.html
- Crest — System Notes : https://crest.readthedocs.io/en/4.23.0/user/system-notes.html
- Geometry clipmaps (Losasso et Hoppe, SIGGRAPH 2004), vulgarisé : https://app.cinevva.com/blog/2026-02-25-open-world-browser-part-06-clipmaps.html
- Terrain3D, clipmap en Godot 4 : https://deepwiki.com/TokisanGames/Terrain3D
- Johanson — Real-time water rendering, projected grid (2004) : https://fileadmin.cs.lth.se/graphics/theses/projects/projgrid
- Catlike Coding — Waves (Gerstner, résolution de maillage) : https://catlikecoding.com/unity/tutorials/flow/waves/
