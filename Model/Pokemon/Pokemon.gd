@icon("res://Model/Pokemon/Pokemon.png")
extends Node2D
class_name Pokemon

@export var speed: float = 100.


@onready var sprite_collection: PokemonSpriteCollection = %PokemonSprites
@onready var pokemon_characrer_body: CharacterBody2D = $PokemonBody2D

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

	
	# handle state transition
	velocity = velocity.normalized() * speed 
	if velocity.length() > -1e-5 and velocity.length() < 1e-5:
		velocity = Vector2.ZERO
		$StateChart.send_event("not_pressing_movement")
	else:
		# handle velocity direction
		var direction = PokemonSpriteCollection.vector_to_direction(velocity)
		sprite_collection.set_animation_direction(direction)
		$StateChart.send_event("pressing_movement")
	
	pokemon_characrer_body.velocity = velocity
	pokemon_characrer_body.move_and_slide()

	


func _on_idle_state_entered():
	sprite_collection.set_animation_name("Idle")
	sprite_collection.play = false


func _on_walk_state_entered():
	sprite_collection.set_animation_name("Walk")
	sprite_collection.play = true
