# Phase B — Gerstner, isolé

Plan de phase de l'étape 1 — voir le [master plan](maillage_vagues_etape1.md) pour le contexte,
les décisions et les questions ouvertes.

- **Prérequis** : aucun. Indépendante de la phase A.
- **Suite** : la phase C branche la fonction de B2 sur le maillage en anneaux de la phase A.

## Objectif

Valider la fonction hauteur — shader et GDScript, mêmes paramètres — avant toute complexité de LOD.

Scène séparée : plan fixe de 128 m au pas de 0,25 m, caméra libre, une seule houle. Ni banque,
ni zones, ni tore.

Rappels du projet : le temps arrive par global shader uniform depuis `WorldClock`, jamais par
`TIME` ; les paramètres de la houle sont dans une `Resource` partagée, rangée dans `resources/`.

---

## B1 — Une vague, shader seul

**On construit**
- Une houle de Gerstner dans le vertex shader : direction, longueur d'onde, amplitude, raideur.
  Déplacement vertical **et** horizontal.
- Temps reçu par global shader uniform depuis WorldClock, jamais `TIME`.
- Normales analytiques en fragment.

**On valide**
- La crête avance dans la bonne direction, à la bonne vitesse.
- En montant la raideur : profil pointu, puis repli des crêtes. On note le seuil.

**Question liée** — la raideur maximale est-elle par houle ou cumulée ? Ce test donne le seuil
d'une houle isolée ; la somme le dépassera, à reprendre avec la banque. (master, question 6)

## B2 — La même vague en GDScript

**On construit**
- `hauteur(x, z, t)` en GDScript, écrite à partir des **mêmes paramètres**, rangés dans une
  Resource partagée.
- Des bouées posées chaque image à la hauteur lue.
- Déplacement horizontal inversé en 3 itérations de point fixe.

**On valide**
- Les bouées collent à l'eau rendue, à ×1 comme à ×100.
- Sauter en arrière dans le temps redonne exactement la même mer.

**Piège** — sans l'inversion du déplacement horizontal, les bouées dérivent dès que la raideur
monte. C'est ce test qui le révèle.

---

## Critère de sortie de la phase B

- La crête avance dans la bonne direction, à la bonne vitesse ; le seuil de raideur est noté.
- Les bouées collent à l'eau rendue à ×1 et à ×100, y compris à forte raideur.
- Un saut dans le temps redonne exactement la même mer (déterminisme).
- Une seule `Resource` de paramètres alimente le shader et le GDScript.
