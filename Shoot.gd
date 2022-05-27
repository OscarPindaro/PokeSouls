extends PlayerState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bulletScene =  preload("res://Bullet.tscn")
onready var timer: Timer = $ShootTimer

func enter(_msg := {}) -> void:
	var bullet = bulletScene.instance()
	player.add_child(bullet)
	# THIS IS VERY BAD, IT'S A MOMENTARY SOLUTION
	# bullet has been set to top level, not super clear but also not so terrible
	bullet.transform = bullet.transform.rotated(player.heading)
	bullet.heading = player.heading
	bullet.position = player.position
	timer.start()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(_delta: float) -> void:
#	player.animations.play("shoot_right")
#	var n_frames = player.animations.frames.get_frame_count("shoot_right")
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_wait_time() -> float:
	return timer.wait_time

func _on_ShootTimer_timeout():
	state_machine.transition_to("Idle")
