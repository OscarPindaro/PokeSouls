tool
extends Node2D
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

