extends KinematicBody2D


var parser : SpriteParser

func _init():
	parser = SpriteParser.new()

func _ready():
	var a = parser.load_sprite_animations("Bulbasaur")
	add_child(a)
	a.position = Vector2(100,100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
