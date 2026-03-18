extends Node

var stats_cache: Dictionary = {}
var data_cache: Dictionary = {}

const WEAPON_PATHS = {
	"pistol": {
		"stats": "res://weapons/resources/pistol_stats.tres",
		"data": "res://weapons/resources/pistol_data.tres"
	},
	"shotgun": {
		"stats": null,
		"data": null
	}
}

func get_stats(weapon_id: String) -> WeaponStats:
	if stats_cache.has(weapon_id):
		return stats_cache[weapon_id]
	
	if not WEAPON_PATHS.has(weapon_id):
		push_error("Weapon ID not found: ", weapon_id)
		return null
	
	var stats = load(WEAPON_PATHS[weapon_id]["stats"])
	stats_cache[weapon_id] = stats
	return stats
	

func get_data(weapon_id: String) -> WeaponData:
	if data_cache.has(weapon_id):
		return data_cache[weapon_id]
		
	if not WEAPON_PATHS.has(weapon_id):
		push_error("Weapon ID not found: ", weapon_id)
		return null
	
	var data = load(WEAPON_PATHS[weapon_id]["data"])
	data_cache[weapon_id] = data
	return data

func get_data_and_stats(weapon_id: String) -> Dictionary:
	return {
		"stats": get_stats(weapon_id),
		"data": get_data(weapon_id)
	}
	
func get_all_weapon_ids() -> Array:
	return WEAPON_PATHS.keys()
	
func pre_load_all():
	
	for weapon_id in WEAPON_PATHS.keys():
		get_stats(weapon_id)
		get_data(weapon_id)
