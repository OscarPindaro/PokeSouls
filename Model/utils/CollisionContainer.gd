tool
extends Node2D
class_name CollisionContainer

var collision_arr : Array
var curr_frame : int = 0


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

func change_frame(new_frame : int):
	var old_frame = curr_frame
	curr_frame = new_frame

	var old_collision : CollisionPolygon2D = collision_arr[old_frame]
	old_collision.disabled = true
	old_collision.visible = false

	if curr_frame < collision_arr.size():
		collision_arr[curr_frame].disabled = false
		collision_arr[curr_frame].visible = true





