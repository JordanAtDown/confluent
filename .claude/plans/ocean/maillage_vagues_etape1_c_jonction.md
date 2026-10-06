# Phase C — La jonction

Plan de phase de l'étape 1 — voir le [master plan](maillage_vagues_etape1.md) pour le contexte,
les décisions et les questions ouvertes.

- **Prérequis** : phases A **et** B terminées. Sans les deux témoins validés, un défaut ne se
  localise plus.
- **Suite** : banque de houles, tore, zones, battement de tempête (hors étape 1).

## Objectif

La fonction Gerstner de la phase B remplace la sinusoïde du maillage de la phase A, toujours avec
**une seule houle**. Le critère de l'étape 1 s'y décide : sous le bateau, les bouées collent.

---

## C1 — La houle sur les anneaux

**On construit**
- Le shader du maillage appelle la fonction Gerstner depuis la Resource partagée.
- Houle longue et douce pour commencer : 40 m, 1 m, raideur faible.
- Marge de culling portée à l'amplitude maximale prévue.

**On valide**
- Aucun morceau de mer ne disparaît au bord de l'écran.
- En fil de fer coloré : jusqu'où la houle reste lisible avant de devenir une dent de scie.

**Piège** — le déplacement horizontal déforme la grille ; les frontières d'anneaux ne coïncident
plus exactement. C'est attendu, C3 s'en occupe.

## C2 — L'effacement par longueur d'onde

**On construit**
- Chaque sommet connaît le pas de son anneau. Une houle s'efface **progressivement** quand sa
  longueur d'onde descend sous environ 4 pas locaux (seuil réglable au panneau).
- Le CPU garde la houle entière.

**On valide**
- En baissant la longueur d'onde jusqu'à 2 m : disparition au loin sans scintillement, netteté
  près de la caméra.
- Déplacer le seuil ne crée aucun cercle visible autour de la caméra.

**Question liée** — 4 pas locaux est un point de départ, à régler ici. (master, question 4)

## C3 — Les raccords sous déplacement horizontal

**On construit**
- La transition de A4 revérifiée avec Gerstner : le sommet de frontière rejoint la moyenne des
  **positions déplacées** de ses voisins grossiers.

**On valide**
- À la raideur maximale admissible : aucune fissure, aucun chevauchement.
- Traverser une frontière à vitesse de bateau puis à ×100 : rien ne saute.

**Piège** — tester à la raideur maximale, pas à la raideur par défaut : les fissures n'apparaissent
qu'à forte raideur.

## C4 — Les bouées sur toute la portée

**On construit**
- Des sondes CPU réparties du centre fin jusqu'au dernier anneau.
- Au panneau : l'écart vertical entre chaque bouée et l'eau rendue sous elle, et le temps CPU de
  l'ensemble des sondes.

**On valide**
- Sous le bateau (anneau fin) : les bouées collent. C'est le critère de l'étape 1.
- Au loin : l'écart grandit avec l'effacement. On mesure à partir de quelle distance.
- Le coût CPU de l'ensemble des sondes reste sous 2 ms par image (budget GDD #24).

**Question liée** — jusqu'où le CPU reste-t-il fiable ? Cette mesure contraint la flottaison (#9)
et tout ce qui vivra loin du bateau. (master, question 5)

## C5 — Le budget

**On construit** — rien de neuf : on règle. Nombre d'anneaux, taille du centre, pas fin, seuil
d'effacement.

**On valide**
- 60 images/s en 1080p sur la machine de référence (RTX 4060 ou 5060, 8 Go ; voir le master),
  caméra à 3 m, regard à l'horizon (le cas le plus coûteux).
- Dans le budget de #24, relevé séparément : eau 8 ms sur le GPU, sondes 2 ms sur le CPU. Le
  compteur d'images par seconde seul ne suffit pas.
- Si ça ne tient pas, dans cet ordre : baisser le pas fin, réduire le centre, retirer un anneau.
  C'est l'ordre qui abîme le moins la lecture de la houle.

**Question liée, levée** — #24, la machine de référence, est tranchée par le GDD. C5 se mesure
sur cette machine. (master, question 1)

---

## Critère de sortie de la phase C — et de l'étape 1

- Sous le bateau : les bouées collent à l'eau rendue.
- Aucune fissure ni chevauchement à la raideur maximale, ni à ×100.
- L'effacement ne crée ni scintillement ni cercle visible.
- La distance à partir de laquelle l'écart CPU/GPU grandit est mesurée et notée.
- 60 images/s en 1080p sur la machine de référence dans le cas le plus coûteux, avec l'eau sous
  8 ms GPU et les sondes sous 2 ms CPU.
