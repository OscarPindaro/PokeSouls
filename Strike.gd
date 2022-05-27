extends PlayerState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer: Timer = $StrikeTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func enter(_msg := {}) -> void:
	timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_wait_time() -> float:
	return timer.wait_time

func _on_StrikeTimer_timeout():
	state_machine.transition_to("Idle")
