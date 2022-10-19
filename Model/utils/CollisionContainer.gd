tool
extends Node2D
class_name CollisionContainer

var collision_arr : Array

func _ready():
	collision_arr = []

func add_collisions(collision_shapes : Array):
	collision_arr = collision_shapes
	for collision in collision_shapes:
		collision.disabled = true
		collision.visible = false
		add_child(collision)

func remove_collisions():
	for collision in collision_arr:
		collision.queue_free()
	collision_arr = []


