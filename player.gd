class_name Player
extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D
@onready var input_dir : Vector2 = Vector2.ZERO
@export var move_speed : float = 100.00

const BACKWALK_THRESHOLD : float = - 0.7

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
	var dot_prod = direction_to_mouse.dot(walking_direction)
	
	if !idle:
		walking_direction = velocity.normalized()
		animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
		
		var is_backwalking = dot_prod < BACKWALK_THRESHOLD
		
		if is_backwalking:
			
			var mouse_opposite_horizontal: bool = (direction_to_mouse.x > 0 and walking_direction.x < 0) or (direction_to_mouse.x < 0 and walking_direction.x > 0)
			var mouse_opposite_vertical: bool = (direction_to_mouse.y > 0 and walking_direction.y < 0) or (direction_to_mouse.y < 0 and walking_direction.y > 0)
			
			if mouse_opposite_horizontal or mouse_opposite_vertical:
				back_walking = true
				animation_tree.set("parameters/BackWalking/blend_position", direction_to_mouse)
				
		else:
			if direction_to_mouse.x < 0 and walking_direction.x < 0 or walking_direction.x < 0 and direction_to_mouse.x > 0:
				back_walking = false
				animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
			elif direction_to_mouse.x > 0 and walking_direction.x > 0 or walking_direction.x > 0 and direction_to_mouse.x < 0:
				back_walking = false
				animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
			elif direction_to_mouse.y < 0 and walking_direction.y < 0 or walking_direction.y < 0 and direction_to_mouse.y > 0:
				back_walking = false
				animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
			elif direction_to_mouse.y > 0 and walking_direction.y > 0 or walking_direction.y > 0 and direction_to_mouse.y < 0:
				back_walking = false
				animation_tree.set("parameters/Walk/blend_position", direction_to_mouse)
			
		update_sprite_orientation(walking_direction, direction_to_mouse, dot_prod)

func update_sprite_orientation(walking_dir: Vector2, mouse_dir: Vector2, dot: float) -> void:
	
	var has_horizontal_dir: bool = walking_dir.x != 0
	var has_vertical_dir: bool = walking_dir.y != 0
	
	if has_horizontal_dir and has_vertical_dir:
		
		handle_diagonal(walking_dir.x, mouse_dir, dot)
		
		
		
	
	if has_horizontal_dir and !has_vertical_dir:
		handle_pure_horizontal(walking_dir.x, mouse_dir.x, dot)
		
	if has_vertical_dir and !has_horizontal_dir:
		handle_pure_vertical(mouse_dir.x, dot)



func handle_pure_horizontal(walking_dir: float, mouse_dir: float, dot: float) -> void:
	
	if walking_dir > 0:
		if mouse_dir < 0 and dot < -0.7:
			player_sprite.scale.x = -1
		else:
			player_sprite.scale.x = 1
	if walking_dir < 0:
		if dot > 0.7:
			player_sprite.scale.x = -1
		if mouse_dir > 0 and dot < -0.7:
			player_sprite.scale.x = 1

func handle_pure_vertical(mouse_dir : float, dot: float) -> void:
	
	if mouse_dir < 0:
		if dot < 0.7 and dot > -0.7:
			player_sprite.scale.x = -1
		elif dot < -0.7:
			player_sprite.scale.x = 1
	elif mouse_dir > 0:
		if dot < 0.7:
			player_sprite.scale.x = 1

func handle_diagonal(walking_dir: float, mouse_dir: Vector2, dot: float) -> void:
	var is_backwalking: bool = dot < 0.0
	
	if walking_dir > 0:
		if is_backwalking:
			back_walking = true
			animation_tree.set("parameters/BackWalking/blend_position", mouse_dir)
			if dot > -0.99:
				player_sprite.scale.x = -1
		else:
			player_sprite.scale.x = 1
				
	if walking_dir < 0:
		if is_backwalking:
			back_walking = true
			animation_tree.set("parameters/BackWalking/blend_position", mouse_dir)
			if dot > -0.99:
				player_sprite.scale.x = 1
		else:
			player_sprite.scale.x = -1
