tool
extends Node2D


export(float, 0, 1, 0.1) var transparency  = 1.0 setget set_transparency, get_transparency

func set_transparency(alpha_value : float) -> void:
	if Engine.editor_hint:
		pass
	if not Engine.editor_hint:
		pass
	transparency = alpha_value
	for child in get_children():
		child.modulate.a = alpha_value

func get_transparency() -> float:
	if Engine.editor_hint:
		pass
	if not Engine.editor_hint:
		pass
	return transparency

func _ready():
	set_transparency(transparency)