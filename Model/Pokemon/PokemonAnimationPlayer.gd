@tool
extends AnimationPlayer
class_name PokemonAnimationPlayer


@export var sprites_path: NodePath
@onready var sprites: Node2D = get_node(sprites_path)


# this enumeration is used to map the different directions
# in the animation spritesheet
enum Direction { DOWN, DOWN_RIGHT, RIGHT, UP_RIGHT, UP, UP_LEFT, LEFT, DOWN_LEFT }

var SECOND : float = 1

func _ready():
	pass


func build_animations() -> void:
	delete_all_animations()
	for sprite in sprites.get_children():
		# creates an animation from the sprite for each cardinal direction
		for dir in Direction:
			var animation: Animation = Animation.new()
			# sprite animation track
			var sprite_track_index = animation.add_track(Animation.TYPE_VALUE)
			animation.set_length(SECOND)
			animation.set_step(SECOND / sprite.hframes)
			var sprite_path = String(sprite.get_path()) + ":frame"
			animation.track_set_path(sprite_track_index, sprite_path)
			animation.value_track_set_update_mode(sprite_track_index, Animation.UPDATE_DISCRETE)
			# anim creation
			var starting_frame = Direction.get(dir) * sprite.hframes
			var ending_frame = (Direction.get(dir) + 1) * sprite.hframes
			for i in range(starting_frame, ending_frame):
				var time_key: float = (i - starting_frame) * animation.get_step()
				animation.track_insert_key(sprite_track_index, time_key, i)
				#animation.track_insert_key(coll_t_idx, time_key, i)
			animation.set_loop(true)
			# adding animation to player
			var anim_name = sprite.name
			var err = self.add_animation_library(anim_name + "_" + dir, animation)
			if err != OK:
				push_error("Problem while adding animation in the animation player.")

func delete_all_animations() -> void:
	var animation_names : PackedStringArray = self.get_animation_list()
	for anim_name in animation_names:
		self.remove_animation_library(anim_name)
