class_name TideCycle
extends Resource

## La marée : un décalage vertical global ajouté à la hauteur des vagues.
## GDD v0.1 § « Système océan / Marée » ; décisions #7, #8, #16.
##
## Les îles et les récifs ne bougent pas, c'est l'eau qui monte et descend. Aucune collision
## ne s'active ni ne se désactive : la praticabilité se déduit de la profondeur sous la coque.

## Durée d'un cycle complet, en secondes. 2400 s = 40 min, plus long qu'une traversée :
## une sortie en mer se planifie autour d'une seule marée.
@export var period_s: float = 2400.0

## Marnage, du plus bas au plus haut, en mètres.
@export var range_m: float = 3.0

## Facteur d'accélération du temps à l'ancre. C'est ainsi qu'on attend la bonne marée.
## Statut « à trancher » dans le GDD (#16).
@export var anchor_time_scale: float = 10.0

@export_group("Placement des passages")

## Un récif « de marée » — ouvert à marée haute, fermé à marée basse — a son sommet entre ces
## deux hauteurs par rapport au niveau moyen, houle non comprise. Déduit de range_m et du
## tirant d'eau de [BoatSpec] : règle de placement, pas un réglage libre.
@export var tidal_crest_min_m: float = -2.7
@export var tidal_crest_max_m: float = 0.3
