class_name Player
extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D
@onready var input_dir : Vector2 = Vector2.ZERO
@onready var unarmed_sprite : CompressedTexture2D = preload("res://player/pirate/sprites/pirate_faceless_anim_sprite-sheet_v01.png")
@onready var equiped_sprite : CompressedTexture2D = preload("res://player/pirate/sprites/unarmed.png")
@onready var sprite : Sprite2D = $Sprite2D

@export var move_speed : float = 100.00

@onready var gun : Node2D = null

const BACKWALK_THRESHOLD : float = - 0.7

var walking_direction : Vector2 = Vector2(0, -1)
var facing_direction : Vector2 = Vector2.DOWN
var back_walking : bool = false
var knockback : bool = false
var knockback_velocity : Vector2 = Vector2.ZERO
var knockback_duration : float = 0.0
var knockback_decelaration : float = 500


func _physics_process(_delta: float) -> void:
	
	input_dir = Input.get_vector("left","right","up","down")
	
	if knockback_duration > 0.0:
		velocity = knockback_velocity
		knockback_duration -= _delta
		knockback = true
		
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 
		knockback_decelaration * _delta)
		
		if knockback_duration <= 0:
			knockback = false
			knockback_velocity = Vector2.ZERO
	else:
		velocity = input_dir * move_speed
	move_and_slide()
	#controla o movimento
	
	var idle = !velocity
	var camera = get_viewport().get_camera_2d()
	var mouse_position = camera.get_local_mouse_position()
	var direction_to_mouse = mouse_position.normalized()
	var dot_prod = direction_to_mouse.dot(walking_direction)
	
	if idle:
		back_walking = false
		animation_tree.set("parameters/idle/blend_position", direction_to_mouse)
		if direction_to_mouse.x < 0:
			player_sprite.scale.x = -1
		else:
			player_sprite.scale.x = 1
	
	if knockback:
		animation_tree.set("parameters/knockback/blend_position", direction_to_mouse)
	
	if !idle and !knockback:
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
			
			var aligned : bool = (
				((direction_to_mouse.x < 0 and walking_direction.x < 0) or (walking_direction.x < 0 and direction_to_mouse.x > 0)) or
				((direction_to_mouse.x > 0 and walking_direction.x > 0) or (walking_direction.x > 0 and direction_to_mouse.x < 0)) or
				((direction_to_mouse.y < 0 and walking_direction.x < 0) or (walking_direction.y < 0 and direction_to_mouse.y > 0)) or 
				((direction_to_mouse.y > 0 and walking_direction.y > 0) or (walking_direction.y > 0 and direction_to_mouse.y < 0))
			)
			
			if aligned:
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

func equip_gun(gun_scene: PackedScene) -> void:
	
	if gun and gun.shot_fired.is_connected(_on_gun_shot_fired):
		gun.shot_fired.disconnect(_on_gun_shot_fired)
	
	gun = gun_scene.instantiate()
	add_child(gun)
	gun.equiped = true
	sprite.texture = equiped_sprite
	
	gun.shot_fired.connect(_on_gun_shot_fired)
	
func _on_gun_shot_fired(knockback_dir: Vector2, knockback_force: float, knockback_timer: float) -> void:
	knockback_velocity = knockback_dir * knockback_force
	knockback_duration = knockback_timer
	
