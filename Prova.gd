extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speedValue = 5
onready var animSprite = $AnimatedSprite
var last_frame_heading = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	animSprite.play("walk_right")
	animSprite.frame=0
	animSprite.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1	
		
	if velocity == Vector2(1,0):
		animSprite.play("walk_right")
		animSprite.flip_h = false
	elif velocity == Vector2(-1,0):
		animSprite.play("walk_right")
		animSprite.flip_h = true
	elif velocity == Vector2(0,1):
		animSprite.play("walk_down")
	elif velocity == Vector2(0,-1):
		animSprite.play("walk_up")
	elif velocity == Vector2(1,1):
		animSprite.play("walk_diag_down")
		animSprite.flip_h = false
	elif velocity == Vector2(-1,1):
		animSprite.play("walk_diag_down")
		animSprite.flip_h = true
	elif velocity == Vector2(-1,-1):
		animSprite.play("walk_diag_up")
		animSprite.flip_h = true
	elif velocity == Vector2(1,-1):
		animSprite.play("walk_diag_up")
		animSprite.flip_h = false
	else: # idle
		animSprite.stop()
		animSprite.frame = 0
	
	velocity = velocity * speedValue
	move_and_collide(velocity)
