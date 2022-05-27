extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var directions = ["left", "up_left", "up", "up_right", "right", 
"down_right", "down", "down_left"]

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	print("aaaa ", owner)
	player = owner as Player
	assert(player != null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var state_name = player.get_state_name()
	select_animation(state_name)

func _on_StateMachine_transitioned(state_name):
	select_animation(state_name)

func select_direction():
		# there are 8 possible directions
		var delta_step = 2*PI/8
		#mapping the angle between 0 and 2PI, this means that 0 is the vector (-1,0)
		var translated_heading = player.heading + PI
		# subtracing delta_step/2 since each action is a slice centered in the direction,
		# and the admissible variable are between direction +- delta_step/2
		# no idea why +1, module 8 avoids overflowing
		var direction_index = (int((translated_heading-delta_step/2)/delta_step)+1)%8
		return direction_index

func select_animation(state_name: String):
	speed_scale = 1
	var dir_name = directions[select_direction()]
	var anim_name = ""
	if state_name == "Walk":
		# use lookup arrays to select animation
		anim_name = "walk_%s" % dir_name
		play(anim_name)
	elif state_name == "Shoot":
		anim_name = "shoot_%s" % dir_name
		play(anim_name)
		var target_time: float = get_node("../StateMachine/Shoot/ShootTimer").wait_time
		speed_scale = speed_scale_computation(target_time, anim_name)
	elif state_name == "Idle":
		anim_name = "walk_%s" % dir_name
		play(anim_name)
		frame = 0
		stop()
	elif state_name == "Strike":
		anim_name = "strike_%s"%dir_name
		play(anim_name)
		var target_time: float = get_node("../StateMachine/Strike/StrikeTimer").wait_time
		speed_scale = speed_scale_computation(target_time, anim_name)
	else:
		print_debug("Unable to handle the state %s"%state_name)

func speed_scale_computation(target_time:float, anim_name:String) -> float:
	var n_frames: float = frames.get_frame_count(anim_name)
	var target_fps: float = n_frames / target_time
	return target_fps / frames.get_animation_speed(anim_name)
