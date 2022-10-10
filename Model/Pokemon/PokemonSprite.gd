tool
extends Sprite
class_name PokemonSprite


var poke_num_file_path : String = "res://Images/SpriteCollab/poke-numbers.json"
var anim_data_path : String = "res://Images/SpriteCollab/sprite/%s/AnimData.json"
var texture_path : String = "res://Images/SpriteCollab/sprite/%s/%s"
var error_texture_path : String = "res://Images/error_texture.png"
# key : pokemon name, value : string folder (es: "Bulbasaur" : "0001")
var poke_dict : Dictionary
var animation_dict : Dictionary



func _init() -> void:
	var file : File = File.new()
	var error_value = file.open(poke_num_file_path, File.READ)
	if error_value != OK:
		push_error("Problem while opening the pokemon-folder association file.")
	poke_dict = parse_json(file.get_as_text())

func load_properties(name : String):
	# the name of the sprite is the animation name
	var animation_name = get_name()
	# error if pokemon not present
	if !poke_dict.has(name):
		push_error("The pokemon "+ name+
		" is not present in the dictionary.")
	var folder_number = poke_dict[name]
	var anim_data_file = File.new()
	var err = anim_data_file.open(anim_data_path % [folder_number], File.READ)
	if err != OK:
		load_error_texture()
	else:
		# load animation texture
		animation_dict = parse_json(anim_data_file.get_as_text())
		self.texture = load( texture_path % [folder_number, get_anim_filename(animation_name)])
		self.texture.flags = 0
		var frame_heigth = get_anim_property(animation_name, "FrameHeight").to_int()
		var frame_width = get_anim_property(animation_name, "FrameWidth").to_int()
		self.hframes = self.texture.get_width() / frame_width
		self.vframes = self.texture.get_height() / frame_heigth
		self.visible = false
	
	anim_data_file.close()     


func get_anim_filename(anim_name : String) -> String:
	var anims = animation_dict["AnimData"]["Anims"]["Anim"]
	for anim in anims:
		if anim["Name"] == anim_name:
			if anim.has("CopyOf"):
				return get_anim_filename(anim["CopyOf"])
			else:
				return "%s-Anim.png" % anim["Name"]
	push_error("Something went wrong while finding the filename")
	return ""

func get_anim_property(anim_name : String, property_name : String) -> String:
	var anims = animation_dict["AnimData"]["Anims"]["Anim"]
	for anim in anims:
		if anim["Name"] == anim_name:
			if anim.has("CopyOf"):
				return get_anim_property(anim["CopyOf"], property_name)
			else:
				return anim[property_name]
	push_error("The animation " + anim_name + " is not present.")
	return ""


func load_error_texture() -> void:
	self.texture = load(error_texture_path)
	