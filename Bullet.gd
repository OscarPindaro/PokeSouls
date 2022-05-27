class_name Bullet
extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var bullAnimation = $BulletAnimation
var distance: float = 0
var speed = 5
var heading: float = 0
export var max_distance: float = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	bullAnimation.play("bulletAnimation")
	set_as_toplevel(true)
	
func _process(delta):
	pass

func _physics_process(delta): 
	var a = Vector2.RIGHT
	a = a.rotated(heading)*speed
	var collision: KinematicCollision2D = move_and_collide(a)
	if collision != null:
		pass
	distance += speed*delta
	if distance > max_distance:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
