extends Node
# This class is used to extract the information about the position of the centre, right hand, left hand and mouth
# of a given pokemon. The information is gathered from png files where:
# GREEN -> center of the pokemon
# BLACK -> shoot origin
# RED -> right hand
# BLUE -> left hand

enum POSITION_TYPE { CENTER, SHOOT, RIGHT_HAND, BLUE_HAND }


func _ready():
	pass  # Replace with function body.


func extract_positions():
	pass
