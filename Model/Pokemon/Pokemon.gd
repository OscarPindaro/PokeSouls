tool
extends Node2D
class_name Pokemon, "res://Model/Pokemon/Pokemon.png"

# SIGNALS
signal change_animation(sprite_name, direction, animation_name)



# paths to resources
var sprite_collab_path : String = "res://Images/SpriteCollab/"
var poke_num_dict_name : String = "poke-numbers.json"
var sprite_folder : String = "sprite/"
var ANIM_DATA_FILENAME : String = "AnimData.json"
onready var IDLE_SPRITE : Sprite = $Sprites/Idle


# correnspondences dictionaries
var poke_num_dict : Dictionary 
var anim_dict : Dictionary

# constants
const SECOND : float = 1.0
const IDLE_NAME : String = "Idle"

export var pokemon_name : String = "" setget set_pk_name, get_pk_name

# animation player path
export (NodePath) var anim_player_path
onready var anim_player : AnimationPlayer = get_node(anim_player_path)

# list of spritesheet of the pokemon
export(NodePath) var sprites_path
onready var sprites : Array = get_node(sprites_path).get_children()
export(Array) var sprite_names : Array

export(NodePath) var collision_container_path : NodePath
onready var collision_container = get_node(collision_container_path)

# this child is used to remove the warning about collision shapes
onready var uselessCollisionShape : CollisionShape2D = $UselessForWarning

# used since setters are called without gaurantee that ready was called
var is_ready_called = false

# this enumeration is used to map the different directions
# in the animation spritesheet
enum Direction {DOWN, DOWN_RIGHT, RIGHT, UP_RIGHT,
UP, UP_LEFT, LEFT, DOWN_LEFT }


export(Direction) var animation_direction setget set_direction
onready var old_animation_direction = animation_direction
export(String) var animation_name = "RESET" setget set_anim_name, get_anim_name

func set_direction(value) -> void:
	if value != old_animation_direction:
		old_animation_direction = animation_direction
		animation_direction = value
		update_animation()

func set_anim_name(value : String):
	if value in sprite_names or value == "RESET":
		animation_name = value
		update_animation()
		return
	

func get_anim_name():
	return animation_name

func update_animation():
	emit_signal("change_animation", 
		animation_name,
		animation_direction,
		get_full_animation_name()
		)

func get_full_animation_name() -> String:
	var dir_name : String = ""
	for dir in Direction:
		if Direction[dir] == animation_direction:
			dir_name = dir
	if animation_name == "RESET":
		return animation_name
	else:
		return "%s_%s" % [animation_name, dir_name]
	
	


func set_pk_name(name : String) -> void:
	# da problemi questa funzione
	if name in poke_num_dict:
		pokemon_name = name
		load_pokemon()
		update_animation()

func get_pk_name():
	return pokemon_name

func _init():
	# load pokemon-folder association in a dictionary
	var file : File = File.new()
	var file_name : String = sprite_collab_path + poke_num_dict_name
	var error_value = file.open(file_name, File.READ)
	if error_value != OK:
		push_error("Problem while opening the pokemon-folder association file.")
	poke_num_dict = parse_json(file.get_as_text())
	set_anim_name("RESET")

# Loads the animation from the spritesheet in the animation player
func _ready():
	is_ready_called = true
	# removes the redundant collision shape
	if not Engine.editor_hint:
		remove_child(uselessCollisionShape)
	sprite_names = []
	for sprite in sprites:
		sprite_names.append(sprite.get_name())
	load_pokemon()
	set_anim_name(animation_name)

	
	
func load_pokemon():
	if not is_ready_called:
		return
	#collision_container.reset_collisions()
	if Engine.editor_hint:
		pass
	if not Engine.editor_hint:
		pass
	collision_container.reset_collisions()
	for sprite in sprites:
		var anim_name = sprite.get_name()
		load_sprite_attributes(sprite, anim_name)
		load_collision_attributes(sprite, anim_name)
		create_anim_player_track(sprite, anim_name)
	create_RESET_animation(IDLE_SPRITE)

# loads the information about animations, the spritesheet and sets
# the correct parameters for the sprite
func load_sprite_attributes(sprite : Sprite, anim_name : String):
	# error if pokemon not present
	if !poke_num_dict.has(pokemon_name):
		push_error("The pokemon "+ pokemon_name+
		" is not present in the dictionary.")
	#loads the animation data
	var folder_number = poke_num_dict[pokemon_name]
	var sprite_path = sprite_collab_path + sprite_folder + folder_number + "/"
	var json_anim_path = sprite_path + ANIM_DATA_FILENAME
	var anim_data_file = File.new()
	anim_data_file.open(json_anim_path, File.READ)
	anim_dict = parse_json(anim_data_file.get_as_text())
	var file_name : String = "%s-Anim.png" % anim_name
	# loads the spritesheet as a texture
	sprite.texture = load(sprite_path+file_name)
	sprite.texture.flags = 0
	var frame_heigth = get_anim_property(anim_name, "FrameHeight").to_int()
	var frame_width = get_anim_property(anim_name, "FrameWidth").to_int()
	sprite.hframes = sprite.texture.get_width() / frame_width
	sprite.vframes = sprite.texture.get_height() / frame_heigth
	sprite.visible = false
	anim_data_file.close()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

func load_collision_attributes(sprite : Sprite, anim_name : String) -> void:
	var coll_polys : Array = CollisionExctractor.new().get_collision_polygons(sprite)
	collision_container.register_collision(anim_name, coll_polys)	

func get_anim_property(anim_name : String, property_name : String) -> String:
	var anims = anim_dict["AnimData"]["Anims"]["Anim"]
	for anim in anims:
		if anim["Name"] == anim_name:
			if anim.has("CopyOf"):
				return get_anim_property(anim["CopyOf"], property_name)
			else:
				return anim[property_name]
	push_error("The animation " + anim_name + " is not present.")
	return ""
	

func create_anim_player_track(sprite : Sprite, anim_name : String):
	# creates an animation from the sprite for each cardinal direction
	for dir in Direction:
		var animation : Animation = Animation.new()
		# sprite animation track
		var sprite_track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.set_length(SECOND)
		animation.set_step(SECOND/sprite.hframes)
		var sprite_path = String(sprite.get_path())+ ":frame"
		animation.track_set_path(sprite_track_index, sprite_path)
		animation.value_track_set_update_mode(sprite_track_index, Animation.UPDATE_DISCRETE)
		
		#collision animation track		
		var coll_t_idx = animation.add_track(Animation.TYPE_VALUE)
		var collision_path = String(collision_container.get_path()) + ":frame"
		animation.track_set_path(coll_t_idx, collision_path)
		animation.value_track_set_update_mode(coll_t_idx, Animation.UPDATE_DISCRETE)
			
		# anim creation
		var starting_frame = Direction.get(dir)*sprite.hframes
		var ending_frame = (Direction.get(dir)+1)*sprite.hframes
		for i in range(starting_frame, ending_frame):
			var time_key : float = (i-starting_frame)*animation.get_step()
			animation.track_insert_key(sprite_track_index, time_key, i)
			animation.track_insert_key(coll_t_idx, time_key, i)
					
		animation.set_loop(true)
		
		# adding animation to player
		var err = anim_player.add_animation(anim_name + "_" +dir, animation)
		if err != OK:
			push_error("Problem while adding animation in the animation player.")

func create_RESET_animation(sprite : Sprite):
	var animation : Animation = Animation.new()
	var sprite_track_index = animation.add_track(Animation.TYPE_VALUE)
	var sprite_path = String(sprite.get_path())+ ":frame"
	animation.track_set_path(sprite_track_index, sprite_path)
	var coll_t_idx = animation.add_track(Animation.TYPE_VALUE)
	var collision_path = String(collision_container.get_path()) + ":frame"
	animation.track_set_path(coll_t_idx, collision_path)
	animation.track_insert_key(sprite_track_index, 0, 0)
	animation.track_insert_key(coll_t_idx, 0, 0)
	animation.set_loop(true)
	var err = anim_player.add_animation("RESET", animation)
	if err != OK:
		push_error("Problem while adding RESET animation in the animation player.")



# selects the given animation with the given direction
func set_animation(sprite_name : String, dir=Direction.DOWN) -> void:
	set_anim_name(sprite_name)
	set_direction(dir)

				
func _process(_delta):
	#set_animation("Shoot", Direction.DOWN)
	#collision_container.curr_name = "Shoot"
	pass

		
