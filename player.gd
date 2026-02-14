class_name Player
extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D
@onready var input_dir : Vector2 = Vector2.ZERO
@export var move_speed : float = 100.00

var walking_direction : Vector2 = Vector2(0, -1)
var facing_direction : Vector2 = Vector2.DOWN
var back_walking : bool = false

func _physics_process(_delta: float) -> void:
	
	#controla o movimento
	input_dir = Input.get_vector("left","right","up","down")
	
	velocity = input_dir * move_speed
	move_and_slide()
	
	var idle = !velocity
	var camera = get_viewport().get_camera_2d()
	var mouse_position = camera.get_local_mouse_position()
	var direction_to_mouse = mouse_position.normalized()
	
	if !idle:
		walking_direction = velocity.normalized()
		animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
		
		print_debug("Walking: ", walking_direction, "  Mouse: ", sign(mouse_position))
		
		if direction_to_mouse.x < 0:
			player_sprite.scale.x = -1
		elif direction_to_mouse.x > 0:
			player_sprite.scale.x = 1
		
		if direction_to_mouse.x > 0 and walking_direction.x < 0:
			back_walking = true
			animation_tree.set("parameters/BackWalking/blend_position", direction_to_mouse)
		elif direction_to_mouse.x < 0 and walking_direction.x > 0:
			back_walking = true
			animation_tree.set("parameters/BackWalking/blend_position", direction_to_mouse)
		elif direction_to_mouse.x < 0 and walking_direction.x < 0 or walking_direction.x < 0 and direction_to_mouse.x > 0:
			back_walking = false
			animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
		elif direction_to_mouse.x > 0 and walking_direction.x > 0 or walking_direction.x > 0 and direction_to_mouse.x < 0:
			back_walking = false
			animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
			
		if direction_to_mouse.y > 0 and walking_direction.y < 0:
			back_walking = true
			animation_tree.set("parameters/BackWalking/blend_position", direction_to_mouse)
		elif direction_to_mouse.y < 0 and walking_direction.y > 0:
			back_walking = true
			animation_tree.set("parameters/BackWalking/blend_position", direction_to_mouse)
		elif direction_to_mouse.y < 0 and walking_direction.y < 0 or walking_direction.y < 0 and direction_to_mouse.y > 0:
			back_walking = false
			animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
		elif direction_to_mouse.y > 0 and walking_direction.y > 0 or walking_direction.y > 0 and direction_to_mouse.y < 0:
			back_walking = false
			animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
			
		
			
		
		
		#if walking_direction.x != sign(mouse_position.x):
			#back_walking = true
			#animation_tree.set("parameters/BackWalking/blend_position", mouse_position)
		#elif walking_direction.x == sign(mouse_position.x):
			#back_walking = false
			#
		#if walking_direction.y != sign(mouse_position.y):
			#back_walking = true
			#animation_tree.set("parameters/BackWalking/blend_position", -mouse_position)
		#elif walking_direction.y == sign(mouse_position.y):
			#back_walking = false
		#
		#if walking_direction.y != sign(mouse_position.y) and walking_direction.x == sign(mouse_position.x):
			#back_walking = false
		#elif walking_direction.x != sign(mouse_position.x) and walking_direction.y == sign(mouse_position.y):
			#back_walking = false
		
		
		
		
			#animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
		#print_debug(back_walking)
		#
		#if x_mouse_position != walking_direction.x or y_mouse_position != walking_direction.y:
			#
			#
			#animation_tree.set("parameters/BackWalking/blend_position", facing_direction)
		#else:
			#back_walking = false
			#animation_tree.set("parameters/Walk/blend_position", facing_direction)
		#
		#if x_mouse_position < 0:
			#player_sprite.scale.x = - 1
			#animation_tree.set("parameters/Walk/blend_position",- walking_direction)
		#elif x_mouse_position > 0:
			#player_sprite.scale.x = 1
			#animation_tree.set("parameters/Walk/blend_position", walking_direction)


	if idle:
		if mouse_position.x < 0:
			player_sprite.scale.x = -1
		else:
			player_sprite.scale.x = 1
		animation_tree.set("parameters/idle/blend_position", mouse_position)
	
	
	

	
