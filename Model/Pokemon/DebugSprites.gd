@tool
extends Node2D

#paths
@export var node_path: NodePath
# nodes
@onready var sprites_node : Node2D = get_node(node_path)
@onready var red_circle : Sprite2D = get_node("RedCircle") 
@onready var blue_circle : Sprite2D = get_node("BlueCircle") 
@onready var green_circle : Sprite2D = get_node("GreenCircle") 
@onready var black_circle : Sprite2D = get_node("BlackCircle") 

@export var transparency  = 1.0: get = get_transparency, set = set_transparency # (float, 0, 1, 0.1)
@export var sprite_scale = 0.05: get = get_sprite_scale, set = set_sprite_scale # (float, 0, 1, 0.05)

# setget transparency
func set_transparency(alpha_value : float) -> void:
	if Engine.is_editor_hint():
		pass
	if not Engine.is_editor_hint():
		pass
	transparency = alpha_value
	for child in get_children():
		child.modulate.a = alpha_value

func get_transparency() -> float:
	if Engine.is_editor_hint():
		pass
	if not Engine.is_editor_hint():
		pass
	return transparency

# setget scale
func set_sprite_scale(new_scale : float):
	if Engine.is_editor_hint():
		pass
	if not Engine.is_editor_hint():
		pass
	for child in get_children():
		child.scale.x = new_scale
		child.scale.y = new_scale

func get_sprite_scale() -> float:
	if Engine.is_editor_hint():
		pass
	if not Engine.is_editor_hint():
		pass
	return sprite_scale


func _ready():
	sprites_node.connect("right_position_changed", Callable(self, "on_Sprites_right_position_changed"))
	sprites_node.connect("left_position_changed", Callable(self, "on_Sprites_left_position_changed"))
	sprites_node.connect("center_position_changed", Callable(self, "on_Sprites_center_position_changed"))
	sprites_node.connect("shoot_position_changed", Callable(self, "on_Sprites_shoot_position_changed"))
	set_transparency(transparency)
	set_sprite_scale(sprite_scale)

# signal methods
func on_Sprites_right_position_changed(_old_pos : Vector2, new_pos : Vector2):
	red_circle.position = new_pos


func on_Sprites_left_position_changed(_old_pos : Vector2, new_pos : Vector2):
	blue_circle.position = new_pos

func on_Sprites_center_position_changed(_old_pos : Vector2, new_pos : Vector2):
	green_circle.position = new_pos

func on_Sprites_shoot_position_changed(_old_pos : Vector2, new_pos : Vector2):
	black_circle.position = new_pos

