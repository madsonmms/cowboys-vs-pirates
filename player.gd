class_name Player
extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D
@onready var input_dir : Vector2 = Vector2.ZERO
@export var move_speed : float = 100.00

var last_facing_direction : Vector2 = Vector2(0, -1) 

func _physics_process(_delta: float) -> void:
	
	#controla o movimento
	input_dir = Input.get_vector("left","right","up","down")
	
	velocity = input_dir * move_speed
	move_and_slide()
	
	var idle = !velocity
	
	if !idle:
		last_facing_direction = velocity.normalized()
		
	if last_facing_direction.x < 0:
		player_sprite.scale.x = -1
	else:
		player_sprite.scale.x = 1
		
	
	animation_tree.set("parameters/idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/walk/blend_position", last_facing_direction)
	
