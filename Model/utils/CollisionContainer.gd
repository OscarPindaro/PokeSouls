extends Node2D
class_name CollisionContainer

var frame = 0
var old_frame = 0
var curr_name = "" 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var collisions : Dictionary

# registers a set of collisions to the key "name"
func register_collision(name : String, collision_shapes : Array) -> void:
	collisions[name] = collision_shapes
	for collision in collision_shapes:
		collision.disabled = true
		


func _physics_process(delta):
	if curr_name == "":
		return
	else:
		var collision_poligons : Array = collisions[curr_name]
		collision_poligons[old_frame].disabled = true;
		collision_poligons[old_frame].visible = false;
		collision_poligons[frame].disabled = false;
		collision_poligons[frame].visible = true;
		print(frame)
		old_frame = frame;
	


