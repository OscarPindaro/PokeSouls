extends Node2D
class_name Pokemon, "res://Images/ClassIcons/pokeball.png"

# paths to resources
var sprite_collab_path : String = "Images/SpriteCollab/"
var poke_num_dict_name : String = "poke-numbers.json"
var sprite_folder : String = "sprite/"
var ANIM_DATA_FILENAME : String = "AnimData.json"
# correnspondences dictionaries
var poke_num_dict : Dictionary 
var anim_dict : Dictionary

const SECOND : float = 1.0
const IDLE_NAME : String = "Idle"


export var pokemon_name : String = "" setget set_pk_name, get_pk_name

onready var anim_player : AnimationPlayer = $AnimationPlayer
# list of spritesheet of the pokemon
var sprites

enum Direction {DOWN, DOWN_RIGHT, RIGHT, UP_RIGHT,
UP, UP_LEFT, LEFT, DOWN_LEFT }

func set_pk_name(name : String):
	pokemon_name = name

func get_pk_name():
	return pokemon_name

func _init():
	# load pokemon-folder association
	var file : File = File.new()
	var file_name : String = sprite_collab_path + poke_num_dict_name
	file.open(file_name, File.READ)
	poke_num_dict = parse_json(file.get_as_text())

# Called when the node enters the scene tree for the first time.
func _ready():
	sprites = $Sprites.get_children()
	for sprite in sprites:
		var anim_name = sprite.get_name()
		load_sprite_attributes(sprite, anim_name)
		create_anim_player_track(sprite, anim_name)
	
		
func load_sprite_attributes(sprite : Sprite, anim_name : String):
	# error if pokemon not present
	if !poke_num_dict.has(pokemon_name):
		push_error("The pokemon "+ pokemon_name+
		" is not present in the dictionary.")
	
	#animation loading
	var folder_number = poke_num_dict[pokemon_name]
	var sprite_path = sprite_collab_path + sprite_folder + folder_number + "/"
	var json_anim_path = sprite_path + ANIM_DATA_FILENAME
	var anim_data_file = File.new()
	anim_data_file.open(json_anim_path, File.READ)
	anim_dict = parse_json(anim_data_file.get_as_text())
	var file_name : String = "%s-Anim.png" % anim_name
	# load texture
	var image = Image.new()
	image.load(sprite_path+file_name)
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	sprite.texture = texture
	# load vertical and horizontal frame numbers
	var frame_heigth = get_anim_property(anim_name, "FrameHeight").to_int()
	var frame_width = get_anim_property(anim_name, "FrameWidth").to_int()
	sprite.hframes = sprite.texture.get_width() / frame_width
	sprite.vframes = sprite.texture.get_height() / frame_heigth
	sprite.set_scale(Vector2(2,2))
	sprite.visible = false
	anim_data_file.close()

func get_anim_property(anim_name : String, property_name : String) -> String:
	var anims = anim_dict["AnimData"]["Anims"]["Anim"]
	for anim in anims:
		if anim["Name"] == anim_name:
			if anim.has("CopyOf"):
				return get_anim_property(anim["CopyOf"], property_name)
			else:
				return anim[property_name]
	push_error("The animation " + anim_name + " is not present")
	return ""
	

func create_anim_player_track(sprite : Sprite, anim_name : String):
	# creates an animation from the sprite for each cardinal direction
	for dir in Direction:
		var animation = Animation.new()
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.set_length(SECOND)
		animation.set_step(SECOND/sprite.hframes)
		var sprite_path = String(sprite.get_path())+ ":frame"
		animation.track_set_path(0, sprite_path)
		
		# anim creation
		var starting_frame = Direction.get(dir)*sprite.hframes
		var ending_frame = (Direction.get(dir)+1)*sprite.hframes
		for i in range(starting_frame, ending_frame):
			animation.track_insert_key(track_index, (i-starting_frame)*animation.get_step(), i)
		animation.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)			
		animation.set_loop(true)
		
		# adding animation to player
		anim_player.add_animation(anim_name + "_" +dir, animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_sprite_visibility(sprite_name : String) -> void:
	# default frame is idle
	if not (sprite_name in sprites):
		for sprite in sprites:
			if sprite.name.casecmp_to(IDLE_NAME):
				sprite.visible= true
			else:
				sprite.visible = false 
	else:
		for sprite in sprites:
			if sprite.name.casecmp_to(sprite_name):
				sprite.visible = true
			else:
				false
		
