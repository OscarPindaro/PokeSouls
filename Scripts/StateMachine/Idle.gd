extends PlayerState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var move_actions = ["move_right", "move_left", "move_down", "move_up"]

func enter(_msg := {}) -> void:
	# this implementation does not allows linting for owner
	player.velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update(delta: float) -> void:
	hanlde_animation()
	handle_input()
	#shoot transition
#	if Input.is_action_just_pressed("shoot"):
#		state_machine.transition_to("Shoot")
#		return
#	for move_action in move_actions:
#		if Input.is_action_pressed(move_action):
#			state_machine.transition_to("Walk")
#			return
#	if Input.is_action_pressed("strike"):
#		state_machine.transition_to("Strike")
#		return

func handle_input():
	pass

func handle_animation():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
