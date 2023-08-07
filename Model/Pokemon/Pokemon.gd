@tool
extends Node2D
class_name Pokemon, "res://Model/Pokemon/Pokemon.png"

# SIGNALS
signal change_animation(sprite_name, direction, animation_name)

# constants
const SECOND: float = 1.0
const IDLE_NAME: String = "Idle"

# paths to resources
var sprite_collab_path: String = "res://Images/SpriteCollab/"
var poke_num_file_path: String = "res://Images/SpriteCollab/poke-numbers.json"
var anim_data_file_path: String = "res://Images/SpriteCollab/sprite/%s/AnimData.json"
var anim_file_path: String = "res://Images/SpriteCollab/sprite/%s/%s"
@onready var IDLE_SPRITE: Sprite2D = $Sprites/Idle

# correnspondences dictionaries
var poke_num_dict: Dictionary
var anim_dict: Dictionary



@export var pokemon_name: String = "": get = get_pk_name, set = set_pk_name

# animation player path
@export var anim_player_path: NodePath
@onready var anim_player: AnimationPlayer = get_node(anim_player_path)

# list of spritesheet of the pokemon
@export var sprites_path: NodePath
@onready var sprites: Array = get_node(sprites_path).get_children()
@export var sprite_names = PackedStringArray()

# this child is used to remove the warning about collision shapes
@onready var uselessCollisionShape: CollisionShape2D = $UselessForWarning

# used since setters are called without gaurantee that ready was called
var is_ready_called = false

# this enumeration is used to map the different directions
# in the animation spritesheet
enum Direction { DOWN, DOWN_RIGHT, RIGHT, UP_RIGHT, UP, UP_LEFT, LEFT, DOWN_LEFT }

@export var animation_direction: Direction: set = set_direction
@onready var old_animation_direction = animation_direction
@export var animation_name: String = "RESET": get = get_anim_name, set = set_anim_name


func set_direction(value) -> void:
	if value != old_animation_direction:
		old_animation_direction = animation_direction
		animation_direction = value
		notify_property_list_changed()
		update_animation()


func set_anim_name(value: String):
	if value in sprite_names or value == "RESET":
		animation_name = value
		notify_property_list_changed()
		update_animation()


func get_anim_name():
	return animation_name


func update_animation():
	emit_signal("change_animation", animation_name, animation_direction, get_full_animation_name())


func get_full_animation_name() -> String:
	var dir_name: String = ""
	for dir in Direction:
		if Direction[dir] == animation_direction:
			dir_name = dir
	if animation_name == "RESET":
		return animation_name
	else:
		return "%s_%s" % [animation_name, dir_name]


func set_pk_name(name: String) -> void:
	# da problemi questa funzione
	if name in poke_num_dict:
		pokemon_name = name
		load_pokemon()
		update_animation()


func get_pk_name():
	return pokemon_name


func _init():
	# load pokemon-folder association in a dictionary
	var file: File = File.new()
	var file_name: String = poke_num_file_path
	var error_value = file.open(file_name, File.READ)
	if error_value != OK:
		push_error("Problem while opening the pokemon-folder association file.")
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	poke_num_dict = test_json_conv.get_data()
	set_anim_name("RESET")


# Loads the animation from the spritesheet in the animation player
func _ready():
	is_ready_called = true
	# removes the redundant collision shape during runtime
	if not Engine.is_editor_hint():
		remove_child(uselessCollisionShape)
	# collects the names of the animation that will be loaded
	sprite_names = []
	for sprite in sprites:
		sprite_names.append(sprite.get_name())
	load_pokemon()
	set_anim_name(animation_name)
	update_animation()


func load_pokemon():
	if not is_ready_called:
		return
	if Engine.is_editor_hint():
		pass
	if not Engine.is_editor_hint():
		pass
	for sprite in sprites:
		var anim_name = sprite.get_name()
		# load the texture sprites and information
		sprite.set_pokemon_name(pokemon_name)
		# load the collision shape
		sprite.load_all()
		create_anim_player_track(sprite, anim_name)
	create_RESET_animation(IDLE_SPRITE)
	update_animation()


func create_anim_player_track(sprite: Sprite2D, anim_name: String):
	# creates an animation from the sprite for each cardinal direction
	for dir in Direction:
		var animation: Animation = Animation.new()
		# sprite animation track
		var sprite_track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.set_length(SECOND)
		animation.set_step(SECOND / sprite.hframes)
		var sprite_path = String(sprite.get_path()) + ":frame"
		animation.track_set_path(sprite_track_index, sprite_path)
		animation.value_track_set_update_mode(sprite_track_index, Animation.UPDATE_DISCRETE)
		# anim creation
		var starting_frame = Direction.get(dir) * sprite.hframes
		var ending_frame = (Direction.get(dir) + 1) * sprite.hframes
		for i in range(starting_frame, ending_frame):
			var time_key: float = (i - starting_frame) * animation.get_step()
			animation.track_insert_key(sprite_track_index, time_key, i)
			#animation.track_insert_key(coll_t_idx, time_key, i)
		animation.set_loop(true)
		# adding animation to player
		var err = anim_player.add_animation_library(anim_name + "_" + dir, animation)
		if err != OK:
			push_error("Problem while adding animation in the animation player.")


func create_RESET_animation(sprite: Sprite2D):
	var animation: Animation = Animation.new()
	var sprite_track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.set_length(SECOND)
	animation.set_step(1)
	var sprite_path = String(sprite.get_path()) + ":frame"
	animation.track_set_path(sprite_track_index, sprite_path)
	animation.value_track_set_update_mode(sprite_track_index, Animation.UPDATE_DISCRETE)
	animation.track_insert_key(sprite_track_index,0,0)
	animation.set_loop(true)
	var err = anim_player.add_animation_library("RESET", animation)
	if err != OK:
		push_error("Problem while adding RESET animation in the animation player.")


# selects the given animation with the given direction
func set_animation(sprite_name: String, dir = Direction.DOWN) -> void:
	set_anim_name(sprite_name)
	set_direction(dir)


func _process(_delta):
	#set_animation("Shoot", Direction.DOWN)
	#collision_container.curr_name = "Shoot"
	pass
