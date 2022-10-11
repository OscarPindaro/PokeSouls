tool
extends State
class_name CharacterState

var character: Character


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready before player state " + name)
	yield(owner, "ready")
	character = owner as Character
	print("ready after player state " + name)
	assert(character != null)
	._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
