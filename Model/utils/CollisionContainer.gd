tool
extends Node2D
class_name CollisionContainer


var collisions : Dictionary

var collisions_array : Array
var old_collision : CollisionPolygon2D

export(PoolVector2Array) var a

var frame = 0
var old_frame = 0
var curr_name = "" 



func reset_collisions() -> void:
	for child in get_children():
		remove_child(child)
	collisions = {}

# registers a set of collisions to the key "name"
func register_collision(name : String, collision_shapes : Array) -> void:
	collisions[name] = collision_shapes
	for collision in collision_shapes:
		collision.disabled = true
		collision.visible = false
		add_child(collision)
		
		
func _physics_process(_delta):
	if Engine.editor_hint:
		pass
	if not Engine.editor_hint:
		pass
	if curr_name == "":
		return
	else:
		if old_collision != null:
			old_collision.disabled = true;
			old_collision.visible = false
		if frame < collisions_array.size():
			collisions_array[frame].disabled = false
			collisions_array[frame].visible = true
			a = collisions_array[frame].polygon

		old_frame = frame
		if old_frame < collisions_array.size():
			old_collision = collisions_array[old_frame]

func _on_Pokemon_change_animation(sprite_name, _direction, _animation_name):
	collisions_array = collisions[sprite_name]
	curr_name = sprite_name
