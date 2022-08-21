extends PlayerState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var move_actions = ["move_right", "move_left", "move_down", "move_up"]
var walk_directions =  ["walk_right", "walk_diag_up", "walk_up", 
"walk_diag_up", "walk_right", "walk_diag_down", "walk_down", "walk_diag_down"]
var orizontal_flips = [true, true, false, false, false, false, false, true]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func enter(_msg := {}) -> void:
	set_velocity_heading()
	player.move_and_collide(player.velocity)

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		state_machine.transition_to("Shoot")
		return
	if Input.is_action_just_pressed("strike"):
		state_machine.transition_to("Strike")
		return
	if is_no_move_action_pressed():
		state_machine.transition_to("Idle")
		return
	
	set_velocity_heading()
	player.move_and_collide(player.velocity)

func update(_delta: float) -> void:
	pass

func set_velocity_heading():
	var velocity = action_to_velocity()
	player.velocity = velocity
	player.set_heading()


func action_to_velocity():
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1	
	velocity = velocity.normalized()
	velocity = velocity * player.speedValue
	return velocity

	
	
func is_no_move_action_pressed() -> bool:
	var bool_var = true
	for move_action in move_actions:
		bool_var = bool_var and not Input.is_action_pressed(move_action)
	return bool_var


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
