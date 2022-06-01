extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var directions = ["left", "up_left", "up", "up_right", "right", 
"down_right", "down", "down_left"]

var sprite_collab_path = "Images/SpriteCollab/"
var poke_num_dict_name : String = "poke-numbers.json"

var poke_num_dict : Dictionary 

func _init():
	# load assocition between pokemon and folder name
	var file : File = File.new()
	var file_name : String = sprite_collab_path + poke_num_dict_name
	file.open(file_name, File.READ)
	poke_num_dict = parse_json(file.get_as_text())
	print(poke_num_dict)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_sprite_animations(pokemon_name : String):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
