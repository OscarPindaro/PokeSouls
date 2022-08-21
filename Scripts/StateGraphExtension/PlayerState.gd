tool
extends State
class_name PlayerState

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready before player state " + name)
	yield(owner, "ready")
	player = owner as Player
	print("ready after player state " + name)
	assert(player != null)
	._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
