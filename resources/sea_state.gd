class_name SeaState
extends Resource

## Hauteurs et longueurs de houle, et la tempête mobile.
## GDD v0.1 § « Système océan » ; décisions #1, #14.
##
## Trois niveaux de danger qu'on distingue d'un coup d'œil : lagune, large, tempête.
## Toutes les hauteurs sont mesurées du creux à la crête.

@export_group("Houle")

## Hauteur dans une lagune abritée, en mètres.
@export var height_lagoon_m: float = 0.3

## Hauteur au large, en mètres : plage basse et haute.
@export var height_open_min_m: float = 1.0
@export var height_open_max_m: float = 2.0

## Longueur d'onde lisible, en mètres. 3 à 8 fois la coque, pour un tangage et un roulis nets.
@export var wavelength_min_m: float = 25.0
@export var wavelength_max_m: float = 60.0

@export_group("Tempête")

## Hauteur des vagues de tempête, en mètres. Courtes et raides : depuis le creux, on lève la
## tête pour voir la crête.
@export var storm_height_min_m: float = 8.0
@export var storm_height_max_m: float = 10.0

## Longueur d'onde en tempête, en mètres.
@export var storm_wavelength_min_m: float = 60.0
@export var storm_wavelength_max_m: float = 80.0

## Nombre de grosses vagues par série, séparées par des accalmies.
@export var storm_series_min: int = 3
@export var storm_series_max: int = 5

## Rayon d'influence de la tempête, en mètres. Visible de loin, donc contournable.
@export var storm_radius_m: float = 400.0

## Vitesse de déplacement de la tempête, en m/s. Plus lente que le bateau : on peut la fuir
## ou la suivre. À 2 m/s elle fait le tour du monde en 25 min, moins d'un cycle de marée.
@export var storm_speed_m_s: float = 2.0
