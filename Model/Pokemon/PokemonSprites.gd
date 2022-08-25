tool
extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_AnimationPlayer_animation_changed(old_name:String, new_name:String):
	if new_name == "RESET":
		for sprite in get_children():
			if sprite.name == "Idle":
				sprite.set_visible(true)
			else:
				sprite.set_visible(false)
		return
	else:
		var first_underscore_pos : int = 0
		var found : bool = false
		for i in range(new_name.length()):
			if not found:
				if new_name[i] == "_":
					found = true;
					first_underscore_pos = i
		var name : String = new_name.substr(0,first_underscore_pos)
		print(name)
		for sprite in get_children():
			if sprite.name == name:
				sprite.set_visible(true)
			else:
				sprite.set_visible(false)

func _on_Pokemon_change_animation(sprite_name, _direction, animation_name):
	if animation_name == "RESET":
		for sprite in get_children():
			if sprite.name == "Idle":
				sprite.set_visible(true)
			else:
				sprite.set_visible(false)
		return
	else:
		for sprite in get_children():
			if sprite.name == sprite_name:
				sprite.set_visible(true)
			else:
				sprite.set_visible(false)

