extends Node2D

signal shot_fired(knockback_direction: Vector2, knockback_force: float, knockback_timer : float)

var bullet = preload("res://weapons/pistol/pistol_bullet.tscn")
var sprite = preload("res://weapons/sprites/guns.png")

@onready var equiped : bool = false : set = _set_equiped, get = _get_equiped
@onready var hand_sprite : Sprite2D = $HandSprite
@onready var gun_muzzle : Marker2D = $Marker2D
@onready var timer : Timer

@export var knockback_force : float = 20.0
@export var knockback_timer : float = 0.5
@export var shoot_cooldown : float = 2.0

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = shoot_cooldown
	timer.one_shot = true
	add_child(timer)

func _process(_delta: float) -> void:
	if equiped:
		look_at(get_global_mouse_position())
		
		rotation_degrees = wrap(rotation_degrees, 0, 360)
		
		if rotation_degrees > 90 and rotation_degrees < 270:
			scale.y = -1
		else:
			scale.y = 1
		
		
		if timer.time_left <= 0:
			if Input.is_action_just_pressed("fire"):
				var bullet_instance = bullet.instantiate()
				timer.start()
				
				get_tree().root.add_child(bullet_instance)
				bullet_instance.global_position = gun_muzzle.global_position
				bullet_instance.rotation = rotation
				
				var knockback_dir = Vector2.LEFT.rotated(rotation)
				shot_fired.emit(knockback_dir, knockback_force, knockback_timer)
	

func _set_equiped(new_value : bool) -> void:
	equiped = new_value
	
	if equiped:
		hand_sprite.visible = true
	else:
		hand_sprite.visible = false
	
func _get_equiped() -> bool:
	return equiped
	
