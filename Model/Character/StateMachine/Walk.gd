tool
extends CharacterState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called when the current state of the state machine is set to this node
func enter_state() -> void:
	print("Dentro walk")

# Called when the current state of the state machine is switched to another one
func exit_state() -> void:
	print("fuori walk")

# Called every frames, for real time behaviour
# Use a return "State_node_name" or return Node_reference to change the current state of the state machine at a given time
func update_state(_delta: float) -> void:
	print("pisello")
	print(character)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
