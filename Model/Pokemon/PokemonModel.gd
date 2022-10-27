tool
extends Node2D
class_name PokemonModel

signal sprite_changed(old_sprite, new_sprite)
signal right_position_changed(old_position, new_position)
signal left_position_changed(old_position, new_position)
signal center_position_changed(old_position, new_position)
signal shoot_position_changed(old_position, new_position)

var curr_sprite : PokemonSprite  
var curr_right_pos : Vector2 = Vector2(0,0) setget set_right_pos, get_right_pos
var curr_left_pos : Vector2 = Vector2(0,0) setget set_left_pos, get_left_pos
var curr_center_pos : Vector2 = Vector2(0,0) setget set_center_pos, get_center_pos
var curr_shoot_pos : Vector2 = Vector2(0,0) setget set_shoot_pos, get_shoot_pos

export(NodePath) var default_sprite_path = NodePath("Sprites/Idle")

# child property
export(bool) var collision_visible : bool = false setget set_collision_visible, get_collision_visible

export (PokemonSprite.Centering)  var centering setget set_centering, get_centering


# SETTERS AND GETTERS
# sprite setget
func set_sprite(new_sprite : PokemonSprite):
	var old_sprite = curr_sprite
	curr_sprite = new_sprite
	emit_signal("sprite_changed", old_sprite, new_sprite)

func get_sprite() -> PokemonSprite:
	return curr_sprite

# position setget
# right
func set_right_pos(new_pos : Vector2):
	var old_pos : Vector2 = curr_right_pos
	curr_right_pos = new_pos
	emit_signal("right_position_changed", old_pos, new_pos)

func get_right_pos():
	return curr_right_pos
# left
func set_left_pos(new_pos : Vector2):
	var old_pos : Vector2 = curr_left_pos
	curr_left_pos = new_pos
	emit_signal("left_position_changed", old_pos, new_pos)

func get_left_pos():
	return curr_left_pos
# center
func set_center_pos(new_pos : Vector2):
	var old_pos : Vector2 = curr_center_pos
	curr_center_pos = new_pos
	emit_signal("center_position_changed", old_pos, new_pos)

func get_center_pos():
	return curr_center_pos
# shoot
func set_shoot_pos(new_pos : Vector2):
	var old_pos : Vector2 = curr_shoot_pos
	curr_shoot_pos = new_pos
	emit_signal("shoot_position_changed", old_pos, new_pos)

func get_shoot_pos():
	return curr_shoot_pos

# collision visible
func set_collision_visible(new_value : bool):
	collision_visible = new_value
	for child in get_children():
		child.set_collision_visible(new_value)

func get_collision_visible() -> bool:
	return collision_visible

# centering
func set_centering(new_value):
	centering = new_value
	for child in get_children():
		child.set_centering(new_value)

func get_centering():
	return centering




func _ready():
	curr_sprite = get_node(default_sprite_path)
	set_right_pos(curr_sprite.get_right_position().global_position)
	set_left_pos(curr_sprite.get_left_position().global_position)
	set_center_pos(curr_sprite.get_center_position().global_position)
	set_shoot_pos(curr_sprite.get_shoot_position().global_position)
	if centering != null:
		set_centering(centering)


func _physics_process(_delta):
	# need to use global positions for signaling
	var right_pos : Vector2 = curr_sprite.right_position.global_position 
	if right_pos != get_right_pos():
		set_right_pos(right_pos)
	
	var left_pos : Vector2 = curr_sprite.left_position.global_position 
	if left_pos != get_left_pos():
		set_left_pos(left_pos)

	var center_pos : Vector2 = curr_sprite.center_position.global_position 
	if center_pos != get_center_pos():
		set_center_pos(center_pos)

	var shoot_pos : Vector2 = curr_sprite.shoot_position.global_position 
	if shoot_pos != get_shoot_pos():
		set_shoot_pos(shoot_pos)

# signals
func _on_Pokemon_change_animation(sprite_name, _direction, animation_name):
	if animation_name == "RESET":
		for sprite in get_children():
			if sprite.name == "Idle":
				sprite.set_visible(true)
				set_sprite(sprite)
			else:
				sprite.set_visible(false)
		return
	else:
		for sprite in get_children():
			if sprite.name == sprite_name:
				sprite.set_visible(true)
				set_sprite(sprite)
			else:
				sprite.set_visible(false)

