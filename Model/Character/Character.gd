extends Node2D
class_name Character


var curr_pokemon : Pokemon

onready var pokemons = $Pokemons.get_children()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	curr_pokemon = pokemons[0]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
