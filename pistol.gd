extends Node2D

var bullet = preload("res://bullet.tscn")
var sprite = preload("res://guns.png")

@onready var equiped : bool = false : set = _set_equiped, get = _get_equiped
@onready var hand_sprite : Sprite2D = $HandSprite

func _process(_delta: float) -> void:
	if equiped:
		look_at(get_global_mouse_position())
		
		rotation_degrees = wrap(rotation_degrees, 0, 360)
		
		if rotation_degrees > 90 and rotation_degrees < 270:
			scale.y = -1
		else:
			scale.y = 1
			
		if Input.is_action_pressed("fire"):
			var bullet_instance = bullet.instantiate()
			
			get_tree().root.add_child(bullet_instance)
			bullet_instance.global_position = global_position
			bullet_instance.rotation = rotation
	

func _set_equiped(new_value : bool) -> void:
	equiped = new_value
	
	if equiped:
		hand_sprite.visible = true
	else:
		hand_sprite.visible = false
	
func _get_equiped() -> bool:
	return equiped
	
