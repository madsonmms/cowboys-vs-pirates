extends Area2D
class_name Gun

@export_enum("pistol", "shotgun") var weapon_type = "pistol"
@export var packed_scene : PackedScene

@onready var sprite : Sprite2D = $Sprite2D

var weapon_data = WeaponData
var weapon_stats = WeaponStats
var is_pickable := true

func _ready() -> void:
	
	weapon_data = WeaponResourceManager.get_data(weapon_type)
	weapon_stats = WeaponResourceManager.get_stats(weapon_type)
	
	if weapon_data and weapon_data.world_texture:
		sprite.texture = weapon_data.world_texture
		
	
	body_entered.connect(_on_body_entered)
	add_to_group("floor_weapons")
	
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		if packed_scene:
			body.equip_gun(packed_scene)
		queue_free()
