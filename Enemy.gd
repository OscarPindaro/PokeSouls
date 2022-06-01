class_name Enemy
extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var velocity = Vector2(rng.randf_range(-7,7), rng.randf_range(-7,7))*10
	move_and_slide(velocity)
