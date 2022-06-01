class_name SpriteParser
extends Node


var directions = ["left", "up_left", "up", "up_right", "right", 
"down_right", "down", "down_left"]

var anim_names = ["Walk","Attack", "Shoot"]

var sprite_collab_path : String = "Images/SpriteCollab/"
var poke_num_dict_name : String = "poke-numbers.json"
var sprite_folder : String = "sprite/"

var poke_num_dict : Dictionary 


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
	var anim_dict : Dictionary = parse_json(anim_data_file.get_as_text())
	
	for anim_name in anim_names:
		print(anim_name)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
