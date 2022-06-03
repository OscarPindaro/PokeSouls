class_name SpriteParser
extends Node


var directions = ["left", "up_left", "up", "up_right", "right", 
"down_right", "down", "down_left"]

var anim_names = ["Walk","Attack", "Shoot"]

var sprite_collab_path : String = "Images/SpriteCollab/"
var poke_num_dict_name : String = "poke-numbers.json"
var sprite_folder : String = "sprite/"

var poke_num_dict : Dictionary 
var anim_dict : Dictionary


func _init():
	# load assocition between pokemon and folder name
	var file : File = File.new()
	var file_name : String = sprite_collab_path + poke_num_dict_name
	file.open(file_name, File.READ)
	poke_num_dict = parse_json(file.get_as_text())


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_sprite_animations(pokemon_name : String):
	if !poke_num_dict.has(pokemon_name):
		push_error("The pokemon "+ pokemon_name+
		" is not present in the dictionary.")
	var folder_number = poke_num_dict[pokemon_name]
	var sprite_path = sprite_collab_path + sprite_folder + folder_number + "/"
	var json_anim_path = sprite_path + "AnimData.json"
	var anim_data_file = File.new()
	anim_data_file.open(json_anim_path, File.READ)
	anim_dict = parse_json(anim_data_file.get_as_text())
	
	for anim_name in anim_names:
		var file_name : String = "%s-Anim.png" % anim_name
		var frames : Sprite = Sprite.new()
		frames.texture = load(sprite_path+file_name)
		var frame_heigth = get_anim_property(anim_name, "FrameHeight").to_int()
		var frame_width = get_anim_property(anim_name, "FrameWidth").to_int()
		var hframes : int = frames.texture.get_width() / frame_width
		var vframes : int = frames.texture.get_height() / frame_heigth
		print(hframes," " ,vframes)
		frames.frame = 0
		frames.region_enabled = true
		frames.region_rect = Rect2(0,0,frame_width, frame_heigth)
		return frames

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
