# Phase 4 — Monde, et plus tard

**Objectif** : lire le monde au loin pour tracer sa route, sans que la couture du tore se voie.

## Phase 4 — Monde

| # | Domaine | Problématique | Décision v0.1 | Statut |
| --- | --- | --- | --- | --- |
| 18 | Monde | Voir à travers la couture | Dépend de l'approche retenue en #17. Dans les deux cas, une distance de vue de L/2 garantit qu'on ne voit jamais deux fois le même lieu, et la mer n'a pas besoin de copie. Approche A : les îles proches de la couture ont des copies affichées de l'autre côté, sans collision. Approche B : aucune copie ; les objets sautent hors de vue, dans le brouillard. | À trancher |
| 19 | Monde | Distance de vue et horizon | Brouillard qui ferme la vue à 1,5 km. Avec l'approche B de #17, il doit être totalement opaque un peu avant (vers 1,3 km, selon la taille de la plus grande île), pour qu'aucun objet ne soit visible au moment où il saute ; les repères verticaux restent sous cette limite. Repères verticaux (phares, pics) assez hauts pour être lus avant les îles qu'ils signalent. Îles lointaines en version simplifiée (LOD). | Départ |

## Plus tard

| # | Domaine | Problématique | Décision v0.1 | Statut |
| --- | --- | --- | --- | --- |
| 25 | Outils | Outils de design | En v0.1, zones, profondeur et vent sont peints à la main dans des images, et les réglages vivent dans des Resources. Un vrai outil d'édition viendra après le prototype. | Départ |
