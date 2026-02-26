extends Area2D
class_name Gun

@export var packed_scene : PackedScene

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		if packed_scene:
			body.equip_gun(packed_scene)
		queue_free()
