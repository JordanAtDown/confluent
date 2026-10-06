# Schémas du GDD

Transcription à la main des 8 schémas de `gdd.md` que l'export markdown perd : il n'en reste
là-bas qu'un `[embedded content: …]`. Les mêmes contenus, en mermaid, lisibles dans le repo.

**Ce fichier n'est pas régénéré par `/gdd-sync`.** Si un schéma change dans le doc, il faut le
retranscrire ici. Le `pub` ci-dessous est la version du widget au moment de la transcription :
le comparer pour savoir ce qui a bougé.

| Schéma | Widget | `pub` |
| --- | --- | --- |
| Boucle de pilotage | `b87990b4-f84d` | 7 |
| Boucle globale | `a16248f1-93a7` | 7 |
| Vent et voile | `e7863f54-271d` | 1 |
| Houle | `f999d7fb-092c` | 1 |
| Zones de mer | `166690e0-36e8` | 2 |
| Marée | `c7c9be95-ea9c` | 1 |
| Tempête | `274618b8-14b1` | 2 |
| Bateau | `86d0ccf6-1583` | 1 |

## Boucle de pilotage

Navigation, en continu, à la seconde.

```mermaid
flowchart LR
    OBS["Observer<br/>mer, vent, ciel"]
    DEC["Décider<br/>le cap, l'allure, faire demi-tour"]
    AGI["Agir<br/>régler la voile, prendre la barre, louvoyer"]
    RES["Ressentir<br/>vitesse, gîte, eau sur le pont"]
    OBS --> DEC --> AGI --> RES --> OBS
```

## Boucle globale

Chaque sortie enrichit la carte, jusqu'à la route finale.

```mermaid
flowchart TD
    PORT["Partir du port<br/>relire sa carte annotée"]
    PLAN["Planifier une route<br/>destination, fenêtre de marée"]
    NAV["Naviguer<br/>boucle de pilotage"]
    EXP["Explorer un lieu<br/>à pied, en première personne"]
    IND["Trouver un indice<br/>pourquoi ou comment"]
    REL["Relier les indices<br/>annoter la carte"]
    FIN["Tenter le parcours final<br/>bonne route, bon moment"]

    PORT --> PLAN --> NAV
    NAV -->|accoster| EXP
    EXP --> IND --> REL
    REL -->|rentrer ou repartir| PORT
    REL -->|quand la route est comprise| FIN
    NAV -.->|naufrage : mort, retour au port| PORT
```

## Dangers

Les six schémas suivants suivent tous la même forme : à gauche ce que le joueur voit, à droite
les deux issues. C'est la règle « féroce mais juste » — le danger est annoncé par son signe
avant de frapper, et se tromper a une conséquence lisible, jamais fatale d'un coup.

### Vent et voile

```mermaid
flowchart LR
    classDef bonne stroke:#2e7d32,stroke-width:2px
    classDef erreur stroke:#c62828,stroke-width:2px

    V1["Cap trop près du vent<br/>Signe : la voile faseye,<br/>la girouette pointe vers l'avant"]
    V1 -->|bonne réponse| V1G["Abattre, puis louvoyer"]:::bonne
    V1 -->|si on se trompe| V1B["Le bateau ralentit jusqu'à l'arrêt"]:::erreur

    V2["Voile trop bordée par vent fort<br/>Signe : forte gîte,<br/>le vent force dans la voile"]
    V2 -->|bonne réponse| V2G["Choquer la voile"]:::bonne
    V2 -->|si on se trompe| V2B["Le pont prend l'eau"]:::erreur
```

### Houle

Une houle forte se prend de face ou de biais, jamais par le travers.

```mermaid
flowchart LR
    classDef bonne stroke:#2e7d32,stroke-width:2px
    classDef erreur stroke:#c62828,stroke-width:2px

    H1["Houle forte prise par le travers<br/>Signe : crêtes parallèles au bateau,<br/>roulis qui s'amplifie"]
    H1 -->|bonne réponse| H1G["De face ou de biais, ou la contourner"]:::bonne
    H1 -->|si on se trompe| H1B["Le pont prend l'eau"]:::erreur
```

### Zones de mer

Chaque zone a ses dangers, et un signe pour les lire.

```mermaid
flowchart LR
    classDef bonne stroke:#2e7d32,stroke-width:2px
    classDef erreur stroke:#c62828,stroke-width:2px

    Z1["Large : tempête en vue<br/>Signe : nuages sombres,<br/>lumière qui baisse"]
    Z1 -->|bonne réponse| Z1G["Longer les îles, près d'un abri"]:::bonne
    Z1 -->|si on se trompe| Z1B["Pris au large, loin de tout abri"]:::erreur

    Z2["Récif : vague qui déferle<br/>Signe : ligne d'écume, eau turquoise"]
    Z2 -->|bonne réponse| Z2G["Passer par un chenal à l'eau sombre"]:::bonne
    Z2 -->|si on se trompe| Z2B["Le pont prend l'eau, ou on touche le fond"]:::erreur

    Z3["Mer croisée<br/>Signe : deux réseaux de crêtes<br/>qui se croisent"]
    Z3 -->|bonne réponse| Z3G["La traverser vite, ou l'éviter"]:::bonne
    Z3 -->|si on se trompe| Z3B["Roulis imprévisible, le pont prend l'eau"]:::erreur

    Z4["Détroit à courant<br/>Signe : courant visible à la surface"]
    Z4 -->|bonne réponse| Z4G["Suivre le courant, ou faire le tour"]:::bonne
    Z4 -->|si on se trompe| Z4B["À contre-courant, on avance à peine"]:::erreur
```

### Marée

Un récif se passe au bon moment de la marée.

```mermaid
flowchart LR
    classDef bonne stroke:#2e7d32,stroke-width:2px
    classDef erreur stroke:#c62828,stroke-width:2px

    M1["Récif sans assez d'eau<br/>Signe : traces sur la roche, récifs<br/>qui affleurent, écume sur les récifs"]
    M1 -->|bonne réponse| M1G["Arriver au bon moment, ou jeter l'ancre"]:::bonne
    M1 -->|si on se trompe| M1B["Le bateau touche le fond et s'arrête<br/>conséquence à régler"]:::erreur
```

### Tempête

```mermaid
flowchart LR
    classDef bonne stroke:#2e7d32,stroke-width:2px
    classDef erreur stroke:#c62828,stroke-width:2px

    T1["Vague prise par le travers<br/>Signe : crête parallèle au bateau"]
    T1 -->|bonne réponse| T1G["Prendre la vague à 30–45° de l'avant"]:::bonne
    T1 -->|si on se trompe| T1B["Gros roulis, le pont prend l'eau"]:::erreur

    T2["Vague prise pile de face, trop vite<br/>Signe : l'étrave plonge dans le creux"]
    T2 -->|bonne réponse| T2G["Garder un angle de 30–45° et ralentir"]:::bonne
    T2 -->|si on se trompe| T2B["Le bateau plante dans la vague suivante"]:::erreur

    T3["Surf trop en biais<br/>Signe : l'arrière du bateau dérape"]
    T3 -->|bonne réponse| T3G["Garder la vague bien dans l'axe arrière"]:::bonne
    T3 -->|si on se trompe| T3B["Le bateau part en travers de la vague"]:::erreur

    T4["Déferlante<br/>Signe : écume blanche sur la crête"]
    T4 -->|bonne réponse| T4G["Lui présenter l'avant à 30–45°, ou l'éviter"]:::bonne
    T4 -->|si on se trompe| T4B["Mal placé, elle remplit le pont"]:::erreur

    T5["Virer dans une série de vague<br/>Signe : grosses vagues rapprochées"]
    T5 -->|bonne réponse| T5G["Attendre l'accalmie pour virer"]:::bonne
    T5 -->|si on se trompe| T5B["Par le travers au pire moment"]:::erreur
```

### Bateau

Une erreur ne fait jamais chavirer d'un coup.

```mermaid
flowchart LR
    classDef bonne stroke:#2e7d32,stroke-width:2px
    classDef erreur stroke:#c62828,stroke-width:2px

    B1["Erreurs qui s'enchaînent<br/>Signe : eau sur le pont, bateau<br/>plus lourd, roulis qui s'amplifie"]
    B1 -->|bonne réponse| B1G["S'abriter et laisser le pont se vider"]:::bonne
    B1 -->|si on se trompe| B1B["Au-delà d'un seuil, le bateau chavire"]:::erreur
```
