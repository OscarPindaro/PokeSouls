extends Node

var move_actions = ["move_right", "move_left", "move_down", "move_up"]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func is_moving() -> bool:
	for move_action in move_actions:
		if Input.is_action_pressed(move_action):
			return true
	return false


func is_shooting() -> bool:
	if Input.is_action_just_pressed("shoot"):
		return true
	return false
