@tool
extends Node2D
class_name PokemonSpriteCollection, "res://Model/Pokemon/pokemon_collection.png"

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
var curr_right_pos : Vector2 = Vector2(0,0): get = get_right_pos, set = set_right_pos
var curr_left_pos : Vector2 = Vector2(0,0): get = get_left_pos, set = set_left_pos
var curr_center_pos : Vector2 = Vector2(0,0): get = get_center_pos, set = set_center_pos
var curr_shoot_pos : Vector2 = Vector2(0,0): get = get_shoot_pos, set = set_shoot_pos

# pokemon animation pplayer
@onready var poke_anim_player: PokemonAnimationPlayer = $PokemonAnimationPlayer
@onready var sprites: Node2D = $Sprites

# child property
@export var pokemon_name: String = "Bulbasaur": get = get_pokemon_name, set = set_pokemon_name
@export var animation_name: String = "Idle": get = get_animation_name, set = set_animation_name
@export (PokemonSprite.Centering)  var centering : get = get_centering, set = set_centering
var pokemon_sprite_scene = preload(pokemon_sprite_scene_path)
@export var frame: int: get = get_frame, set = set_frame
@export var play: bool = false: set = set_play
@export var collision_visible: bool: get = get_collision_visible, set = set_collision_visible
@export var visual_debug: bool: set = set_visual_debug

# list of animations
var animation_names : PackedStringArray  = [
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
	# this tries to solve the reload problem
	if sprites == null:
		return
	if poke_anim_player == null:
		return
	if real_name in poke_dict:
		for poke_sprite in sprites.get_children():
			poke_sprite.set_pokemon_name(real_name)
			poke_sprite.set_visible(false)
		pokemon_name = real_name
		set_animation_name(animation_name)
		set_frame(0)
		notify_property_list_changed()
		poke_anim_player.build_animations()
		self.set_animation_property()

func set_animation_property() -> void:
	var direction = poke_anim_player.Direction.get(poke_anim_player.Direction.DOWN)
	if direction == null:
		direction = "DOWN"
	if self.play == true:
		poke_anim_player.play("%s_%s" %  [animation_name, direction])
	else:
		poke_anim_player.set_assigned_animation("%s_%s" %  [animation_name, direction])

func get_pokemon_name() -> String:
	return pokemon_name

func set_animation_name(new_name : String):
	if sprites == null:
		return
	if poke_anim_player == null:
		return
		
	if new_name in animation_names:
		animation_name = new_name
		
		for sprite in sprites.get_children():
			if new_name == sprite.get_animation_name():
				set_sprite(sprite)
				set_frame(0)
				self.set_animation_property()
				# poke_anim_player.stop()
				notify_property_list_changed()
				return

	
func get_animation_name() -> String:
	return animation_name


# collision visible
func set_collision_visible(new_value : bool):
	if sprites == null:
		return
	if poke_anim_player == null:
		return
	collision_visible = new_value
	for child in sprites.get_children():
		child.set_collision_visible(new_value)

func get_collision_visible() -> bool:
	return collision_visible

func set_visual_debug(debug_value : bool) -> void:
	if sprites == null:
		return
	if poke_anim_player == null:
		return
	visual_debug = debug_value
	for child in sprites.get_children():
		child.set_debug(visual_debug)

# centering
func set_centering(new_value):
	if sprites == null:
		return
	if poke_anim_player == null:
		return
	centering = new_value
	for child in sprites.get_children():
		child.set_centering(new_value)

func get_centering():
	return centering


func set_frame(new_value : int) -> void:
	# if negative value, do nothing
	if new_value < 0:
		notify_property_list_changed()
		return
	# if exceed frames, do nothing
	if curr_sprite != null and new_value >= curr_sprite.vframes * curr_sprite.hframes:
		notify_property_list_changed()
		return
	frame = new_value
	if curr_sprite != null:
		curr_sprite.set_frame(frame)
	

func get_frame()->int:
	return frame

func set_play(play_value)-> void:
	if play_value == true:
		poke_anim_player.play()
	else:
		poke_anim_player.stop()
	play = play_value

func _init() -> void:
	var file: File = File.new()
	var error_value = file.open(poke_num_file_path, File.READ)
	if error_value != OK:
		push_error("Problem while opening the pokemon-folder association file.")
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	poke_dict = test_json_conv.get_data()
	file.close()

func _ready():
	# instancing of pokemon sprite instances
	# a lot of garbage code since it's a mess creating tools
	if sprites == null:
		sprites = $Sprites
	if sprites.get_child_count() == 0:
		for anim_name in animation_names:
			var poke_sprite = pokemon_sprite_scene.instantiate()
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
	poke_anim_player.build_animations()
	self.set_animation_property()
	# poke_anim_player.stop()
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
