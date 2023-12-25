@icon("res://Model/Pokemon/Pokemon.png")
extends Node2D

@export var speed: float = 100.


@onready var sprite_collection: PokemonSpriteCollection = $PokemonSpriteCollection

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_collection.play = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	# handle velocity direction
	var direction = PokemonSpriteCollection.vector_to_direction(velocity)
	sprite_collection.set_animation_direction(direction)
	
	# handle state transition
	velocity = velocity.normalized() * speed * delta
	if velocity.length() > -1e-5 and velocity.length() < 1e-5:
		velocity = Vector2.ZERO
		$StateChart.send_event("not_pressing_movement")

	else:
		$StateChart.send_event("pressing_movement")
	
	

	sprite_collection.position += velocity

	


func _on_idle_state_entered():
	sprite_collection.set_animation_name("Idle")


func _on_walk_state_entered():
	sprite_collection.set_animation_name("Walk")
