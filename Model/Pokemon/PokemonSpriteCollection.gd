tool
extends Node2D
class_name PokemonModel, "res://Model/Pokemon/pokemon_collection.png"

signal sprite_changed(old_sprite, new_sprite)
# this position must be global Vector2 positions
signal right_position_changed(old_position, new_position)
signal left_position_changed(old_position, new_position)
signal center_position_changed(old_position, new_position)
signal shoot_position_changed(old_position, new_position)


# PATHS
const poke_num_file_path: String = "res://Images/SpriteCollab/poke-numbers.json"
const pokemon_sprite_scene_path : String = "res://Model/Pokemon/PokemonSprite.tscn"

# DEFAULT VALUES
var DEFAULT_ANIMATION : String = "Idle"


var curr_sprite : PokemonSprite  
var curr_right_pos : Vector2 = Vector2(0,0) setget set_right_pos, get_right_pos
var curr_left_pos : Vector2 = Vector2(0,0) setget set_left_pos, get_left_pos
var curr_center_pos : Vector2 = Vector2(0,0) setget set_center_pos, get_center_pos
var curr_shoot_pos : Vector2 = Vector2(0,0) setget set_shoot_pos, get_shoot_pos

# child property
export(String) var pokemon_name : String setget set_pokemon_name, get_pokemon_name
export(String) var animation_name : String = "Idle" setget set_animation_name, get_animation_name
export(bool) var collision_visible : bool setget set_collision_visible, get_collision_visible
export (PokemonSprite.Centering)  var centering setget set_centering, get_centering
var pokemon_sprite_scene = preload(pokemon_sprite_scene_path)
export(int) var frame setget set_frame, get_frame

# list of animations
var animation_names : PoolStringArray  = [
	'Walk', 'Attack', 'Strike', 'Shoot', 'Twirl', 
	'Sleep', 'Hurt', 'Idle', 'Swing', 'Double', 'Hop', 'Charge',
	'Rotate', 'Dance', 'Shake', 'EventSleep', 'Wake', 'Eat', 'Tumble',
	'Pose', 'Pull', 'Pain', 'Float', 'DeepBreath', 'Nod', 'Sit', 'LookUp',
	'Sink', 'Trip', 'Laying', 'LeapForth', 'Head', 'Cringe', 'LostBalance', 
	'TumbleBack', 'Faint', 'HitGround', 'Kick', 'SpAttack', 'Withdraw', 'Ricochet',
	'FlapAround', 'Jab', 'Hover', 'TailWhip', 'StandingUp', 'QuickStrike', 'Shock', 
	'MultiScratch', 'Appeal', 'Emit', 'Rumble', 'Sound', 'RearUp', 'Special0', 'Slam',
	'Special1', 'Special2', 'Wiggle', 'Fainted', 'DigIn', 'DigOut', 'MultiStrike', 'Yawn', 
	'RaiseArms', 'CarefulWalk', 'Special3', 'Chop', 'Punch', 'Lick', 'Uppercut', 'Gas', 'Swell', 
	'Stomp', 'Slice', 'Slap', 'Injured']

var poke_dict: Dictionary

# SETTERS AND GETTERS
# sprite setget
func set_sprite(new_sprite : PokemonSprite):
	var old_sprite = curr_sprite
	if old_sprite != null:
		old_sprite.set_visible(false)
	curr_sprite = new_sprite
	curr_sprite.set_visible(true)
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


# Child setters and getters
#pokemon name
func set_pokemon_name(new_name : String)-> void:
	var real_name = new_name.to_lower().capitalize()
	if real_name in poke_dict:
		for poke_sprite in get_children():
			poke_sprite.set_pokemon_name(real_name)
			poke_sprite.set_visible(false)
		pokemon_name = real_name
		set_animation_name(animation_name)
		set_frame(0)
		property_list_changed_notify()
	
		
func get_pokemon_name() -> String:
	return pokemon_name

func set_animation_name(new_name : String):
	if new_name in animation_names:
		animation_name = new_name
		for sprite in get_children():
			if new_name == sprite.get_animation_name():
				set_sprite(sprite)
				set_frame(0)
				property_list_changed_notify()
				return

	
func get_animation_name() -> String:
	return animation_name


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


func set_frame(new_value : int) -> void:
	# if negative value, do nothing
	if new_value < 0:
		property_list_changed_notify()
		return
	# if exceed frames, do nothing
	if curr_sprite != null and new_value >= curr_sprite.vframes * curr_sprite.hframes:
		property_list_changed_notify()
		return
	frame = new_value
	if curr_sprite != null:
		curr_sprite.set_frame(frame)
	

func get_frame()->int:
	return frame


func _init() -> void:
	var file: File = File.new()
	var error_value = file.open(poke_num_file_path, File.READ)
	if error_value != OK:
		push_error("Problem while opening the pokemon-folder association file.")
	poke_dict = parse_json(file.get_as_text())
	file.close()
	

func _ready():
	# instancing of pokemon sprite instances
	if get_child_count() == 0:
		for anim_name in animation_names:
			var poke_sprite = pokemon_sprite_scene.instance()
			poke_sprite.set_animation_name(anim_name)
			poke_sprite.set_visible(false)
			poke_sprite.set_name(anim_name)
			add_child(poke_sprite)
	set_pokemon_name(pokemon_name)
	if get_animation_name() == "":
		set_animation_name(DEFAULT_ANIMATION)
	else:
		set_animation_name(animation_name)
	set_collision_visible(collision_visible)
	set_centering(centering)
	# curr_sprite = get_node(default_sprite_path)
	# set_right_pos(curr_sprite.get_right_position().global_position)
	# set_left_pos(curr_sprite.get_left_position().global_position)
	# set_center_pos(curr_sprite.get_center_position().global_position)
	# set_shoot_pos(curr_sprite.get_shoot_position().global_position)
	# if centering != null:
	# 	set_centering(centering)
	

func _physics_process(_delta):
	# need to use global positions for signaling
	if curr_sprite != null:
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
