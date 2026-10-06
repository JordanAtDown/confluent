# Confluent — GDD v0.1

Oct 6, 2026 · @Jordan

## Pitch & piliers

Seul sur un océan, le joueur navigue à la découverte d'indices, en vue à la première personne. Chaque découverte permet de constituer un journal de bord dont la compréhension permettra de comprendre le monde ainsi que l'enquête à laquelle le joueur fait face pour atteindre la fin du jeu.

**Fiche** — Solo · première personne · exploration / enquête · Godot  · PC · manette et clavier

**Piliers**

1. **La connaissance est la progression**** ****:** l'exploration et la connaissance propre du joueur permettent sa progression.
2. **Une mer lisible** : les conditions de navigation doivent être comprise en les voyant par le joueur afin de prendre des décisions sur la navigation et l'exploration.
3. **Un monde ****o****u****ve****r****t**** ****à**** ****la cur****i****o****s****i****té**** ****:** le monde doit pouvoir être exploré entièrement ; regarder au loin doit être une manière de lire le monde afin de tracer notre route.
4. **Un monde organique**** ****:** vent, houle, tempêtes et marée suivent des règles stables que le joueur apprend et exploite.

## Inspirations

**Outer Wilds** est la référence principale. Ce qu'on en retient :

- **Progression par le savoir** : la fin est atteignable dès le début, à condition de savoir comment.
- **Monde visible** : on voit les lieux avant d'y aller, la curiosité fixe la destination.
- **Monde horloger** : des événements réguliers que l'on apprend à anticiper.
- **Journal d'indices** : les découvertes se relient et ouvrent de nouvelles questions.
- **Le déplacement est un gameplay** : naviguer doit pouvoir se maitrise et cela fait partie de l'apprentissage.

Comme dans Outer Wilds, la mort renvoie au départ : seuls la compréhension du joueur et son journal de bord persistent.

## Boucle de gameplay

La boucle s'emboîte sur trois niveaux : piloter à la seconde, une sortie en mer le temps d'une marée, et comprendre le monde sur toute la partie.

**1.** **N****av****iguer** : lire la mer et le vent → régler la voile et la barre → sentir le résultat (vitesse, gîte, eau sur le pont) → corriger.

&#91;embedded content: boucle de pilotage · 4 étapes\]

**2. ****E****x****plorer** : au port, relire sa carte → choisir une destination et une fenêtre de marée → naviguer, ou jeter l'ancre pour attendre → accoster et explorer à pied → trouver un indice et l'annoter → continuer, rentrer, ou faire naufrage et repartir du port.

**3. Comprendre** : les indices s'accumulent → le joueur comprend les règles du monde (marées, vents, tempêtes) → il en déduit la route finale → il tente le parcours final.

Le schéma ci-dessous montre la boucle globale (niveaux 2 et 3).

&#91;embedded content: boucle globale · une sortie en mer, jusqu'au parcours final\]

Renoncer fait partie de la boucle : faire demi-tour face à une mer trop forte est une décision, pas un échec.

**Naufrage = mort.** Le joueur repart toujours du même port. Seules persistent sa compréhension du monde et des mécaniques, et son journal de bord (la carte annotée et le relevé des indices). Rien d'autre.

## Navigation organique

La navigation porte l'exploration : chaque trajet est une décision prise en lisant la mer, le ciel et le vent. Les conditions décident de ce qui est atteignable, et quand.

| Système | Ce qu'il change | Comment le joueur le lit | Décision type |
| --- | --- | --- | --- |
| Vent | Vitesse, cap possible, gîte | Voile, girouette, écume, son | Choisir un cap selon le vent de la zone, ou profiter du passage d'une tempête |
| Houle | Stabilité, risque de chavirer | Lignes de crêtes, période, roulis | Prendre la houle de face, de biais ou l'éviter |
| Zones de mer | Comportement local de l'eau | Couleur, déferlantes, mer croisée, courant visible | Prendre le raccourci d'une zone, ou faire le tour |
| Tempêtes | Danger fort, visibilité | Ciel, front nuageux, baisse de lumière, houle qui grossit | Fuir, s'abriter ou traverser |
| Marée | Cycle qui ouvre ou ferme passages, récifs, grottes à certains moments | Traces sur la roche, récifs qui affleurent | Arriver au bon moment, ou jeter l'ancre pour attendre |

**Règles de design**

- **Cohérence** : un même signe annonce toujours la même conséquence.
- **Féroce mais juste** : le danger est toujours annoncé avant de frapper.

## Système océan

Le vent, la houle, les zones, la marée et la tempête forment un seul système, que le joueur apprend à lire ; le bateau est ce qui les encaisse. Chaque sous-système se présente de la même façon : ses **règles**, puis un **schéma des dangers**, où chaque danger part de son signe et se divise en deux  issues, la bonne réponse et ce qui arrive si on se trompe (c'est la règle « féroce mais juste »), et enfin l'**opportunité**, ce que le système offre au joueur qui le comprend.

Les règles ne sont pas purement réalistes : elles servent la lisibilité et le plaisir de piloter.

### Vent et voile

Chaque zone a son vent dominant, que l'on apprend ; il ne change pas avec le temps, seul le passage d'une tempête le modifie. Voile semi-simulée : le joueur règle la voile et la barre. Impossible de remonter face au vent (zone morte d'environ 45° de chaque côté, à régler) : il faut louvoyer.

&#91;embedded content: vent et voile · 2 dangers, leur signe et leurs deux issues\]

**Opportunité** : un vent portant raccourcit une traversée ; le passage d'une tempête apporte un vent fort.

### Houle

L'angle du bateau par rapport aux lignes de crêtes décide de son comportement : de face ou de biais, il monte et descend ; par le travers, il roule fortement. Le joueur lit la houle par ses lignes de crêtes, la période entre deux crêtes, et le roulis et le tangage ressentis dans la caméra.

&#91;embedded content: houle · 1 danger, son signe et ses deux issues\]

**Opportunité** : une houle venue de l'arrière peut porter le bateau.

### Zones de mer

La mer est du level design : chaque zone a une « personnalité » qui fait obstacle ou raccourci, et se reconnaît de loin. Une zone tord un seul système et pose une décision claire. Zones en cours de définition ; validées : le large, le récif, la mer croisée et le détroit à courant.

**Le large**

- **Ce que c'est** : la pleine mer, loin des îles. Un vent fort et régulier, toujours dans la même direction ; une longue houle de 1 à 2 m, bien rangée ; aucun abri.
- **De loin** : des lignes de crêtes nettes et régulières, à perte de vue.
- **Danger** : l'exposition. Si une tempête arrive, rien n'est proche.
- **Décision** : couper par le large, rapide, en surveillant le ciel ; ou longer les îles, plus lent mais près d'un abri.
- **Pour le prototype** : c'est la zone de référence, celle où l'on règle le bateau avant d'ajouter les autres.

**Le récif**

- **Ce que c'est** : une barrière de rochers à fleur d'eau, traversée par quelques chenaux plus profonds. En approchant, le fond remonte et les vagues se dressent, puis se cassent sur le récif (écume, gerbes). Derrière, une lagune calme sert d'abri.
- **De loin** : une ligne de déferlantes et l'eau turquoise ; les chenaux se lisent à l'eau plus sombre, où les vagues ne cassent pas.
- **Danger** : une vague qui déferle, ou toucher le fond.
- **Décision** : passer par un chenal, court mais exigeant ; ou faire le tour par le large, long mais sûr.
- **Pour le prototype** : un seul chenal dépend de la marée : il s'ouvre à marée haute et se ferme à marée basse. Le reste du récif est fixe.

**La mer croisée**

- **Ce que c'est** : deux houles venues de directions différentes qui se croisent.
- **De loin** : une surface hachée, sans lignes de crêtes nettes, l'inverse du large.
- **Danger** : aucun angle n'est bon ; le bateau roule dans tous les sens et le pont prend l'eau.
- **Décision** : la traverser vite, ou l'éviter.

**Le détroit à courant**

- **Ce que c'est** : un passage étroit entre deux îles, où un courant fort pousse le bateau dans un sens.
- **De loin** : des remous et des traînées d'écume alignées dans le sens du courant.
- **Danger** : à contre-courant, on avance à peine.
- **Décision** : prendre le détroit s'il va dans son sens, ce qui est très rapide ; ou faire le tour.
- **Pour le prototype** : le courant est fixe ; plus tard, la marée pourra l'inverser.

&#91;embedded content: zones de mer · 4 dangers, leur signe et leurs deux issues\]

**Opportunité** : un courant porteur raccourcit une route ; la lagune sert d'abri.

### Marée

Marée longue : un cycle dure plus longtemps qu'une traversée complète, et une sortie en mer se planifie autour d'une seule marée. C'est l'eau qui monte et descend ; les îles et les récifs ne bougent pas. Un passage est praticable quand l'eau au-dessus du récif dépasse le tirant d'eau. Jeter l'ancre fait défiler le temps plus vite : c'est ainsi qu'on attend la bonne marée. Des indices glanés apprennent au joueur à interpréter les signes de la marée.

&#91;embedded content: marée · 1 danger, son signe et ses deux issues\]

**Opportunité** : selon le niveau d'eau, des passages, des récifs et des grottes s'ouvrent ou se ferment.

### Tempête

Tempêtes déterministes : même moment, même trajet à chaque partie. Elles se déplacent sur des trajectoires lisibles, donc anticipables, et s'annoncent par paliers : de loin, la masse nuageuse et la lumière qui baisse ; de près, la houle qui grossit, le vent qui tourne, le grondement. Dans la tempête, les vagues font 8 à 10 m du creux à la crête, courtes et raides : depuis le creux, on lève la tête pour voir la crête. Elles arrivent en séries de 3 à 5 grosses vagues, séparées par des accalmies.

&#91;embedded content: tempête · 5 dangers, leur signe et leurs deux issues\]

**Opportunité** : le vent fort pousse le bateau jusqu'à sa vitesse maximale ; chaque crête permet de voir loin et de repérer un abri ; une tempête peut faire partie de la solution.

### Bateau

Un simple voilier, contrôlé depuis le pont en première personne ; instruments diégétiques minimaux (girouette, boussole). Aucun nouvel instrument : tout est disponible dès le départ.

**Eau sur le pont** : une erreur ne fait jamais chavirer d'un coup. Chaque erreur des schémas ci-dessus envoie de l'eau sur le pont, qui s'évacue ensuite d'elle-même. Le chavirage n'arrive que si les erreurs s'accumulent. La tolérance est un réglage à trouver au banc d'essai.

&#91;embedded content: bateau · eau sur le pont et chavirage\]

**Dégâts progressifs** : chocs et vagues abîment la coque, l'eau monte dans la cale ; le naufrage arrive après des signes clairs. Réparation simple, comme dans Outer Wilds : on s'approche de la zone abîmée, on répare, on attend un peu, la coque est restaurée.

## Monde & carte

Un océan majoritaire, parsemé d'îles et de points d'intérêt, assez petit pour être mémorisé et assez grand pour qu'on s'y sente explorateur.

- **Taille cible** : une traversée complète en 8 à 12 minutes de navigation par beau temps.
- **Points d'intérêt** : îles, épaves, structures englouties, récifs, phares. Chacun porte au moins un indice ; certaines îles sont de vrais lieux à explorer à pied, avec leurs propres petites énigmes.
- **Repères verticaux** : phares, pics, ruines visibles de loin pour s'orienter sans carte.
- **Zones de mer** : régions à la personnalité distincte, en cours de définition. Validées : le large, le récif, la mer croisée et le détroit à courant (voir Système océan).
- **Sans mur invisible** : le monde boucle sur lui-même ; sortir à l'est ramène à l'ouest, sortir au nord ramène au sud. Le joueur comprend que le monde est fini et peut en faire le tour. Décision : un monde torique.

**Échelle et rythm****e**

Ces chiffres fixent ce que le joueur ressent : la taille de son bateau, le temps d'une traversée, ce qu'il voit au loin, le danger d'une mer.&#32;

| Grandeur | Valeur | Ce que ça donne au joueur |
| --- | --- | --- |
| Voilier | 8 m de long, yeux à ≈ 3 m au-dessus de l'eau | Assez petit pour sentir chaque vague, assez haut pour lire la mer autour |
| Vitesse | 5 m/s par beau temps, jusqu'à 8 m/s par vent de tempête | Avancer sans lenteur ; profiter d'une tempête fait gagner du temps |
| Monde | 3 × 3 km | Une traversée d'environ 10 min par beau temps, plus longue en louvoyant |
| Distance de vue | 1,5 km | On voit les lieux avant d'y aller, sans jamais voir deux fois le même lieu |
| Houle | Du creux à la crête : lagune < 0,3 m · large 1 à 2 m · tempête 8 à 10 m, vagues courtes et raides | Trois niveaux de danger qu'on distingue d'un coup d'œil |
| Marée | Cycle de 40 min, marnage de 3 m | Une sortie tient dans une marée ; 3 m suffisent à couvrir ou découvrir un récif |
| Tirant d'eau | 1,2 m | Décide quels passages sont praticables, et quand |
| Tempête | Rayon de 400 m, déplacement à 2 m/s | Visible de loin, contournable, plus lente que le bateau : on peut la fuir ou la suivre |

## Énigme finale

Le joueur récolte des indices pour comprendre le monde. C'est cette compréhension qui lui permet de trouver l'objectif de fin, puis la route pour l'atteindre. Le détail de l'énigme sera défini plus tard.

## Expérience utilisateur

Le jeu s'enseigne par le monde : le joueur apprend en observant, pas en lisant des consignes.

- **H****U****D**** ****d****i****é****g****é****t****i****que** : l'information passe par la voile, la girouette, la boussole, le roulis, le ciel, la mer.
- **Son** : le vent, les déferlantes et le grondement d'une tempête sont des informations de navigation.
- **Première zone pédagogique** : une mer calme qui montre la houle, vent et marée un par un, sans danger (reporté, hors prototype).
- **Journal de bord** : il réunit la carte et le relevé des indices. Les côtes se dessinent une fois vues et le joueur y ajoute ses notes ; les indices et leurs liens y sont gardés, sans donner la solution.
- **Première personne** : à pied sur les îles et à bord ; le joueur ressent la mer dans la caméra (roulis, embruns) sans perdre la lisibilité.

## Périmètre du prototype & questions ouvertes

Le prototype doit valider une seule chose : lire les informations de navigation est agréable et laisse au joueur de vrais choix : quel passage prendre, à quel moment passer, quelle route selon le vent.

**Critères de réussite**

- **Prise en main jouissive** : après quelques minutes, naviguer est agréable.
- **Vraies décisions** : le joueur sait choisir sa route pour rejoindre un point, éviter un danger, ou se servir d'une condition météo pour aller plus vite.

**Contenu du prototype**

- 1 voilier (voile + barre), contrôlé en première personne, à la manette ou au clavier
- 1 point de réapparition, où l'on revient après un chavirage
- 4 zones de mer distinctes (le large, le récif et sa lagune, la mer croisée, le détroit à courant), chacune avec son vent dominant
- 1 tempête mobile qui modifie les zones qu'elle traverse
- 1 cycle de marée qui ouvre et ferme un chenal du récif, lisible uniquement par des signes visuels (rochers, récifs qui affleurent)
- Jeter l'ancre pour attendre : le temps défile plus vite
- Quelques îles et repères verticaux pour s'orienter et viser des destinations (accoster suffit)
- Un monde torique, sans mur invisible

**Hors périmètre** : narration et enquête, cycle jour/nuit, parcours final, indices et exploration à pied, journal de bord et carte, dormir pour passer le temps, dégâts et réparation (le chavirage est inclus, avec un simple retour au point de réapparition), zone d'apprentissage, direction artistique finale, sauvegarde, menus.

**Reporté**

- Enquête et narration, à peaufiner plus tard
- Thème (monde englouti, deuil, fin d'un cycle)
- Choix final de fin de jeu, lié à la narration
- Boucle temporelle : le monde se réinitialise-t-il aussi après un temps donné, ou seulement à la mort ?
- Zone d'apprentissage
- Cycle jour/nuit : prévu, hors prototype
- Œil de la tempête (centre calme) : mis de côté, à rediscuter avec l'énigme finale

**Ouvert** : rien pour l'instant.
