class_name Player
extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D
@onready var input_dir : Vector2 = Vector2.ZERO
@export var move_speed : float = 100.00

var walking_direction : Vector2 = Vector2(0, -1)
var facing_direction : Vector2 = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	
	#controla o movimento
	input_dir = Input.get_vector("left","right","up","down")
	
	velocity = input_dir * move_speed
	move_and_slide()
	
	var idle = !velocity
	var camera = get_viewport().get_camera_2d()
	var mouse_position = camera.get_local_mouse_position()
	
	if !idle:
		walking_direction = velocity.normalized()
		
		if walking_direction.x > 0 and mouse_position.x < 0:
			player_sprite.scale.x = -1
			facing_direction = Vector2(-1, 0)
			
		
		print_debug(walking_direction.x, mouse_position.x)
		
		
	
	if idle:
		if mouse_position.x < 0:
			player_sprite.scale.x = -1
		else:
			player_sprite.scale.x = 1
		animation_tree.set("parameters/idle/blend_position", mouse_position)
	
	
	
		
	
	#animation_tree.set("parameters/idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/walk/blend_position", facing_direction)
	
