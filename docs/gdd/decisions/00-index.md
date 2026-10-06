# Décisions techniques v0.1

Oct 7, 2026 · @Jordan

Ce que l'on retient, pour chaque phase et chaque domaine, à partir du GDD v0.1 et de l'onglet Technique. Les numéros (#) renvoient aux problématiques de l'onglet Technique.

**Statuts**

**Décidé** : choix d'architecture retenu pour la v0.1.&#32;

**Départ** : premier choix pour commencer ; on l'ajustera en testant le prototype. **À trancher** : décision encore ouverte.

## Cadre général

| Sujet | Décision v0.1 | Statut |
| --- | --- | --- |
| Moteur | Godot, dernière version stable, rendu Compatibility | Décidé |
| Langage | GDScript ; C# seulement si les mesures de performance l'imposent | Décidé |
| Direction visuelle | Stylisée : la lisibilité passe avant le réalisme | Décidé |
| Unités | 1 unité Godot = 1 mètre, échelle réelle pour la physique | Décidé |
| Source de vérité | Tout ce qui bouge (vagues, marée, vent, tempête) est une fonction pure de la position et du temps du monde : le monde est déterministe | Décidé |

## Échelle : ce qu'elle impose à la technique

Les chiffres d'échelle (bateau, vitesse, taille du monde, marée, tempête) sont définis dans le GDD v0.1, section « Monde & carte », et ne sont pas recopiés ici. Ce qu'ils imposent à la technique :

- **Monde de 3 km** : les vecteurs d'onde sont calés sur cette taille, k = (2π/L)·(n, m). Pas d'origine flottante : la précision des flottants reste inférieure au millimètre.
- **Voilier de 8 m** : la houle lisible a une longueur d'onde de 25 à 60 m, soit 3 à 8 fois la coque, ce qui donne un tangage et un roulis nets.
- **Distance de vue de 1,5 km, soit L/2** : on ne voit jamais deux fois le même lieu à travers la couture. C'est aussi la limite du maillage de l'eau (et des copies d'îles avec l'approche A de #17).
- **Tirant d'eau de 1,2 m et marnage de 3 m** : un récif « de marée » (ouvert à marée haute, fermé à marée basse) a son sommet entre −2,7 m et +0,3 m par rapport au niveau moyen, houle non comprise. C'est la règle de placement des passages.
- **Tempête à 2 m/s** : elle fait le tour du monde en 25 min, soit moins d'un cycle de marée.

## Décisions par phase

Une décision par problématique, rangée dans un sous-onglet par phase, dans l'ordre où on les construira :

- 1\. Fondation : horloge, modèle de vagues, lecture CPU, maillage, tore, debug et performances.
- 2\. Ressenti : flottaison, caméra, voile, déplacement sur le pont, son.
- 3\. Océan et level design : zones de mer, vent, marée et passages, tempête, côtes, rendu de l'eau, îles.
- 4\. Monde et plus tard : couture du tore, distance de vue, et les outils de design repoussés après le prototype.

## À trancher

- Nombre de houles tenable dans la banque globale sur la machine de référence : 6 au départ, à confirmer par mesure à l'étape 1 (#1, #24).
- Valider l'échelle au banc d'essai : sensation de vitesse depuis le pont, durée réelle d'une traversée, lisibilité de la houle à 3 m de hauteur.
- Approche du tore : A (copies) ou B (monde placé autour du joueur) (#17, #18).
- Chavirage dans le prototype : au retour au point de réapparition, l'horloge du monde repart-elle à zéro ou continue-t-elle ?
- Facteur d'accélération du temps à l'ancre (#16).
