class_name WorldScale
extends Resource

## Échelle du monde torique. GDD v0.1 § « Monde & carte », tableau « Échelle et rythme ».
##
## Ces valeurs ne sont pas libres : [member view_distance_m] vaut la moitié de
## [member world_size_m], sinon on voit deux fois le même lieu à travers la couture.

## Côté du monde, en mètres. Cale les vecteurs d'onde : k = (2π/L)·(n, m).
@export var world_size_m: float = 3000.0

## Distance de vue, en mètres. Doit rester à world_size_m / 2.
@export var view_distance_m: float = 1500.0

## Distance à laquelle le brouillard est totalement opaque. Un peu avant la distance de vue,
## pour qu'aucun objet ne soit visible au moment où il saute de l'autre côté du tore (#19).
@export var fog_opaque_distance_m: float = 1300.0

## Résolution de la carte des zones : poids des houles, vent, courant. 128 ≈ 23 m par pixel.
@export var zone_map_resolution: int = 128
