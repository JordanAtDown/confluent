extends GutTest

## Verrouille les invariants chiffrés du GDD sur les .tres de resources/.
## Un échec ici veut dire qu'une valeur a dérivé du GDD, pas que le code est cassé :
## lire docs/gdd/gdd.md § « Monde & carte » avant de corriger.

var world: WorldScale
var boat: BoatSpec
var tide: TideCycle
var sea: SeaState

func before_each() -> void:
	world = load("res://resources/world_scale.tres")
	boat = load("res://resources/boat_spec.tres")
	tide = load("res://resources/tide_cycle.tres")
	sea = load("res://resources/sea_state.tres")

func test_les_ressources_se_chargent() -> void:
	assert_not_null(world, "world_scale.tres")
	assert_not_null(boat, "boat_spec.tres")
	assert_not_null(tide, "tide_cycle.tres")
	assert_not_null(sea, "sea_state.tres")

func test_distance_de_vue_vaut_la_moitie_du_monde() -> void:
	# Sinon on voit deux fois le même lieu à travers la couture du tore.
	assert_almost_eq(world.view_distance_m, world.world_size_m / 2.0, 0.1)

func test_brouillard_opaque_avant_la_distance_de_vue() -> void:
	# Aucun objet ne doit être visible au moment où il saute de l'autre côté (#19).
	assert_lt(world.fog_opaque_distance_m, world.view_distance_m)

func test_la_tempete_accelere_le_bateau() -> void:
	assert_gt(boat.speed_storm_m_s, boat.speed_fair_weather_m_s)

func test_houle_lisible_de_3_a_8_fois_la_coque() -> void:
	# Ce rapport donne un tangage et un roulis nets sur une coque de 8 m.
	assert_between(sea.wavelength_min_m / boat.hull_length_m, 3.0, 8.0)
	assert_between(sea.wavelength_max_m / boat.hull_length_m, 3.0, 8.0)

func test_sommet_dun_recif_de_maree_deduit_du_marnage_et_du_tirant_deau() -> void:
	# Praticable à marée haute : sommet sous (marnage / 2) - tirant d'eau.
	assert_almost_eq(tide.tidal_crest_max_m, tide.range_m / 2.0 - boat.draft_m, 0.01)
	# Fermé à marée basse : sommet au-dessus de -(marnage / 2) - tirant d'eau.
	assert_almost_eq(tide.tidal_crest_min_m, -tide.range_m / 2.0 - boat.draft_m, 0.01)

func test_on_peut_fuir_la_tempete() -> void:
	# « Plus lente que le bateau : on peut la fuir ou la suivre. »
	assert_lt(sea.storm_speed_m_s, boat.speed_fair_weather_m_s)

func test_la_tempete_boucle_le_monde_en_moins_dun_cycle_de_maree() -> void:
	var tour_du_monde_s: float = world.world_size_m / sea.storm_speed_m_s
	assert_lt(tour_du_monde_s, tide.period_s)

func test_une_sortie_tient_dans_une_maree() -> void:
	# Une traversée complète par beau temps doit être courte devant un cycle de marée.
	var traversee_s: float = world.world_size_m / boat.speed_fair_weather_m_s
	assert_lt(traversee_s, tide.period_s)
