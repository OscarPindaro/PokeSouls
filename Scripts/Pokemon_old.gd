extends KinematicBody2D

# paths to resources
var sprite_collab_path : String = "Images/SpriteCollab/"
var poke_num_dict_name : String = "poke-numbers.json"
var sprite_folder : String = "sprite/"
var ANIM_DATA_FILENAME : String = "AnimData.json"
# correnspondences dictionaries
var poke_num_dict : Dictionary 
var anim_dict : Dictionary

var a : AnimationPlayer

func _init():
	# load assocition between pokemon and folder name
	var file : File = File.new()
	var file_name : String = sprite_collab_path + poke_num_dict_name
	file.open(file_name, File.READ)
	poke_num_dict = parse_json(file.get_as_text())
	load_sprite_animation("Pikachu", "Walk")


func load_sprite_animation(pokemon_name : String, anim_name : String):
	pass
	if !poke_num_dict.has(pokemon_name):
			push_error("The pokemon "+ pokemon_name+
			" is not present in the dictionary.")
	# create paths and load anims info file
	var folder_number = poke_num_dict[pokemon_name]
	var sprite_path = sprite_collab_path + sprite_folder + folder_number + "/"
	var json_anim_path = sprite_path + ANIM_DATA_FILENAME
	var anim_data_file = File.new()
	anim_data_file.open(json_anim_path, File.READ)
	anim_dict = parse_json(anim_data_file.get_as_text())
	# creation of a sprite
	var file_name : String = "%s-Anim.png" % anim_name
	var spritesheet : Sprite = Sprite.new()
	add_child(spritesheet)
	spritesheet.texture = load(sprite_path+file_name)
	var frame_heigth = get_anim_property(anim_name, "FrameHeight").to_int()
	var frame_width = get_anim_property(anim_name, "FrameWidth").to_int()
	var hframes : int = spritesheet.texture.get_width() / frame_width
	var vframes : int = spritesheet.texture.get_height() / frame_heigth
	
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.set_length(1)
	animation.set_step(1/vframes)
	var path = String(spritesheet.get_path())+ ":frame"
	print(spritesheet.get_path())
	animation.track_set_path(0, path)
	
	spritesheet.frame = 0
	spritesheet.region_enabled = true
	spritesheet.region_rect = Rect2(0,0,frame_width, frame_heigth)
	spritesheet.position = Vector2(500,500)
	
	for i in vframes:
		animation.track_insert_key(track_index, i*animation.get_step(), i)
	animation.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)			
	animation.set_loop(true)
	
	var aPlayer = AnimationPlayer.new()
	add_child(aPlayer)
	aPlayer.add_animation("walk", animation)
	aPlayer.set_current_animation("walk")
	aPlayer.play("walk")
	a = aPlayer

func _ready():
	pass

func _process(delta):
	a.play("walk")


func get_anim_property(anim_name : String, property_name : String) -> String:
	var anims = anim_dict["AnimData"]["Anims"]["Anim"]
	var property = null
	for anim in anims:
		if anim["Name"] == anim_name:
			if anim.has("CopyOf"):
				return get_anim_property(anim["CopyOf"], property_name)
			else:
				return anim[property_name]
	push_error("The animation " + anim_name + " is not present")
	return ""
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
