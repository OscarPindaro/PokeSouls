extends Position2D
class_name Position2DList

export(int) var frame = 0
var points: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func add_point(vect: Vector2) -> void:
	points.append(vect)


func _process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
