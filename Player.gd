class_name Player
extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speedValue = 5
onready var animations: AnimatedSprite = $Animations
export var velocity = Vector2.ZERO
export var heading: float = 0
onready var state_machine: StateMachine = $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.get_class())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	
func set_heading():
	# base case if velocity is zero, it may be problematic
	if velocity.length() == 0:
		heading = 0
		return
	heading = velocity.angle()

func get_state_name():
	return state_machine.state.name
