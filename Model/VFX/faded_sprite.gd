extends Sprite2D

@export var lifetime: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fade(duration: float = lifetime):
	var transparent = modulate
	transparent.a = 0.0
	var tween = get_tree().create_tween()
	tween.interpolate_value()