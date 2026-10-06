# Phase A — Le maillage, sans vagues

Plan de phase de l'étape 1 — voir le [master plan](maillage_vagues_etape1.md) pour le contexte,
les décisions et les questions ouvertes.

- **Prérequis** : aucun. Indépendante de la phase B.
- **Suite** : la phase C reprend le maillage et remplace sa sinusoïde par Gerstner.

## Objectif

Un maillage centré sur la caméra, en anneaux de LOD, qui reste stable et sans fissure sous un
relief fixe. Sur une mer plate et unie, un défaut de recalage est invisible : le damier en
coordonnées monde et le fil de fer coloré par anneau sont les seuls témoins.

Scène dédiée. Damier en coordonnées monde dans le shader, fil de fer activable, couleur par
anneau.

Valeurs de départ : pas fin 0,5 m, centre 64 m, 6 anneaux → environ 4 km de portée, autour de
90 000 sommets. Ces chiffres vivent dans un `.tres` de `resources/`, pas dans le script.

---

## A1 — Le plan qui suit la caméra

**On construit**
- Un `PlaneMesh` subdivisé, pas 0,5 m, côté 64 m.
- Un shader `spatial` minimal : damier calculé à partir de la position **monde**, aucun
  déplacement vertical.
- Chaque image : position = celle de la caméra, puis recalage sur le pas
  (`floor(p / pas) * pas` en x et z, y à zéro).

**On valide**
- En avançant la caméra, le damier reste rigoureusement immobile.
- Le plan ne quitte jamais le dessous de la caméra, même à vitesse de bateau.

**Piège** — calculer le damier en coordonnées locales : il suivrait le plan et tout semblerait
correct.

## A2 — Les anneaux

**On construit**
- Générateur `ArrayMesh` en GDScript : un centre fin carré, puis N anneaux au pas doublé à chaque
  fois.
- Un attribut « niveau d'anneau » par sommet (`CUSTOM0` ou `COLOR`).
- Un seul maillage, donc un seul appel de rendu.

**On valide**
- En fil de fer vu de haut : anneaux emboîtés, sans trou ni recouvrement.
- Nombre de sommets conforme au calcul, images par seconde tenues.
- Portée supérieure à la distance de vue de 1,5 km.

**Piège** — à la frontière entre deux anneaux, un sommet fin sur deux n'a pas de vis-à-vis dans
l'anneau grossier. On ne corrige pas ici (A4), mais on marque ces sommets par un attribut.

**Question liée** — les valeurs de départ tiennent-elles le budget de l'eau (8 ms GPU, GDD #24,
machine de référence du master), ou faut-il les revoir dès maintenant ? Relever le temps GPU par
image, pas seulement les images par seconde. (master, question 2)

## A3 — Le recalage d'un bloc

**On construit**
- Le maillage entier recalé sur le pas de l'anneau le plus grossier (16 m pour 6 anneaux à
  0,5 m).
- `extra_cull_margin` réglée large, en prévision des vagues.

**On valide**
- Le damier reste fixe pendant que les anneaux sautent par crans de 16 m sous lui.
- La caméra reste dans le centre fin, même juste avant un saut.
- Pas de clignotement ni de disparition au bord de l'écran.

**Piège** — le centre fin doit valoir au moins deux fois le pas grossier plus la marge, sinon la
caméra sort de la zone dense entre deux sauts.

**Question liée** — le recalage d'un bloc suffit-il ? Si le centre fin devient trop coûteux,
passer au recalage anneau par anneau avec bandes de raccord. (master, question 3)

## A4 — Le relief fixe, et les raccords

**On construit**
- Une sinusoïde unique et **immobile** : 1 m d'amplitude, 40 m de longueur d'onde, déplacement
  vertical seul.
- La même en GDScript, avec quelques bouées posées dessus.
- Puis la transition : chaque sommet marqué « frontière » glisse de sa position fine vers la
  moyenne de ses deux voisins grossiers, selon un facteur fondé sur la distance à la caméra.

**On valide**
- Avant la transition : repérer les fissures et les sauts au recalage — il faut les avoir vues.
- Après : plus aucune fissure, aucun saut en traversant une frontière.
- Les bouées collent au relief rendu, y compris au-dessus des anneaux grossiers.

**Piège** — la transition doit interpoler la **position complète** du sommet, pas seulement sa
hauteur. Sinon tout sera à refaire quand Gerstner déplacera l'eau horizontalement.

---

## Critère de sortie de la phase A

- Damier immobile, quelle que soit la vitesse de la caméra.
- Anneaux emboîtés sans trou ni recouvrement, portée au-delà de 1,5 km, images par seconde tenues.
- Aucune fissure ni saut aux frontières, transition sur la position complète.
- Les bouées GDScript collent à la sinusoïde rendue sur tous les anneaux.
