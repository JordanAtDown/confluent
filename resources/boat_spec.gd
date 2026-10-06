class_name BoatSpec
extends Resource

## Le voilier et la caméra du pont. GDD v0.1 § « Monde & carte » et « Système océan » ;
## décisions #9, #10, #12.

@export_group("Coque")

## Longueur de la coque, en mètres. Fixe l'échelle de la houle lisible : 25 à 60 m de longueur
## d'onde, soit 3 à 8 fois la coque.
@export var hull_length_m: float = 8.0

## Tirant d'eau, en mètres. Un passage est praticable quand la profondeur sous la coque le dépasse.
@export var draft_m: float = 1.2

## Nombre de points de flottaison interrogeant hauteur(x, z, t).
@export_range(1, 16) var buoyancy_point_count: int = 6

@export_group("Allure")

## Vitesse par beau temps, en m/s.
@export var speed_fair_weather_m_s: float = 5.0

## Vitesse maximale par vent de tempête, en m/s.
@export var speed_storm_m_s: float = 8.0

## Demi-angle de la zone morte face au vent. Impossible de remonter dedans : il faut louvoyer.
@export_range(0.0, 90.0) var no_go_angle_deg: float = 45.0

@export_group("Caméra")

## Hauteur des yeux au-dessus de l'eau, en mètres.
@export var eye_height_m: float = 3.0

## Champ de vision, en degrés.
@export_range(1.0, 179.0) var camera_fov_deg: float = 75.0

## Part du roulis du bateau reprise par la caméra, amortie. Au-delà, mal des transports.
@export_range(0.0, 1.0) var camera_roll_follow: float = 0.4
