extends Sprite

# paths to resources
var sprite_collab_path : String = "Images/SpriteCollab/"
var poke_num_dict_name : String = "poke-numbers.json"
var sprite_folder : String = "sprite/"
var ANIM_DATA_FILENAME : String = "AnimData.json"
# correnspondences dictionaries
var poke_num_dict : Dictionary 
var anim_dict : Dictionary

func _init():
	# load assocition between pokemon and folder name
	var file : File = File.new()
	var file_name : String = sprite_collab_path + poke_num_dict_name
	file.open(file_name, File.READ)
	poke_num_dict = parse_json(file.get_as_text())
	
func _ready():	
	var a =load_sprite_animation("Bulbasaur", "Attack")
	
func load_sprite_animation(pokemon_name : String, anim_name : String):
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
	self.texture = load(sprite_path+file_name)
	var frame_heigth = get_anim_property(anim_name, "FrameHeight").to_int()
	var frame_width = get_anim_property(anim_name, "FrameWidth").to_int()
	self.hframes = self.texture.get_width() / frame_width
	self.vframes = self.texture.get_height() / frame_heigth
	
	var walkAnimation = Animation.new()
	walkAnimation.add_track(0)
	walkAnimation.set_length(1)
	walkAnimation.set_step(1.0/vframes)

	var path = String(self.get_path()) + ":frame"
	walkAnimation.track_set_path(0, path)
	var delta_step = walkAnimation.step
	for i in hframes:
		print(delta_step)
		walkAnimation.track_insert_key(0, delta_step*i, i)
	walkAnimation.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
	walkAnimation.loop = 1
	
	self.position = Vector2(400,400)

	var aPlayer = AnimationPlayer.new()
	aPlayer.add_animation("walk", walkAnimation)
	aPlayer.set_current_animation("walk")
	aPlayer.play("walk")
	add_child(aPlayer)
	return aPlayer
	

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
