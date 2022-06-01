extends KinematicBody2D


var parser : SpriteParser

func _init():
	parser = SpriteParser.new()

func _ready():
	parser.load_sprite_animations("Bulbasaur")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
