---
paths:
  - "src/ocean/**"
  - "src/levels/**"
  - "src/boat/**"
  - "shaders/**"
---

# Océan, navigation, level design

Extrait du GDD (`docs/gdd/gdd.md` § Système océan, `docs/gdd/decisions/`). En cas de doute,
lire la section, ne pas improviser.

## Invariants

- **Le monde est déterministe.** Vagues, marée, vent et tempête sont des fonctions pures de la
  position et du temps du monde. Jamais de `randf()`, jamais d'état accumulé image par image :
  on doit pouvoir sauter à n'importe quel instant et retrouver la même mer.
- **Une seule horloge**, l'autoload `WorldClock` (temps en secondes, float 64 bits). Dans un
  shader, le temps arrive par une global shader uniform — jamais le `TIME` intégré.
- **`hauteur(x, z, t)` est écrite deux fois**, en shader et en GDScript, depuis les mêmes
  paramètres rangés dans une `Resource` partagée. Modifier une version sans l'autre est un bug :
  la flottaison ne correspondrait plus à l'eau affichée.
- **Toute carte lue par le shader** (zones, profondeur, abri) existe aussi en `Image` lisible
  côté CPU.
- **La mer ne se répète que sur la taille du monde.** Pas de tiling ; chaque houle fait un nombre
  entier de vagues sur la largeur du monde, sinon la couture du tore se voit.
- **La marée ne touche aucune collision.** C'est un décalage vertical global ajouté à la hauteur
  des vagues ; les îles et récifs ne bougent pas. Un passage est praticable quand la profondeur
  sous la coque dépasse le tirant d'eau — rien ne s'active ni ne se désactive.
- **Les chiffres viennent de `resources/*.tres`**, jamais d'une constante dans un script.

## Lisibilité

Un même signe annonce toujours la même conséquence, et le danger est annoncé avant de frapper.
Les 14 dangers, avec leur signe, leur bonne réponse et ce qui arrive si on se trompe, sont dans
`docs/gdd/schemas.md`. Implémenter un danger sans son signe est un bug de design.

| Système | Ce qu'il change | Signe que le joueur lit |
| --- | --- | --- |
| Vent | Vitesse, cap possible, gîte | Voile, girouette, écume, son |
| Houle | Stabilité, risque de chavirer | Lignes de crêtes, période, roulis |
| Zone | Comportement local de l'eau | Couleur, déferlantes, mer croisée, courant |
| Tempête | Danger fort, visibilité | Ciel, front nuageux, baisse de lumière, houle qui grossit |
| Marée | Ouvre ou ferme passages et récifs | Traces sur la roche, récifs qui affleurent |

- **HUD diégétique.** L'information passe par la voile, la girouette, la boussole, le roulis, le
  ciel, la mer et le son. Pas de texte à l'écran, pas de jauge.
- **Une erreur n'est jamais fatale d'un coup** : elle envoie de l'eau sur le pont, qui alourdit le
  bateau puis s'évacue. Le chavirage n'arrive qu'au-delà d'un seuil cumulé.
- **Renoncer est une décision.** Faire demi-tour doit rester possible et jamais puni comme un échec.

## Rendu

Compatibility : pas de shader de calcul, donc Gerstner en vertex shader (FFT est écarté pour
cette raison). Si une décision du GDD exige Forward+, le dire au lieu de l'implémenter — voir la
contradiction ouverte dans `docs/gdd/README.md`.
