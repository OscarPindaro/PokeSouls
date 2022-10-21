tool
extends Sprite
class_name PokemonSprite

# PATHS
var poke_num_file_path: String = "res://Images/SpriteCollab/poke-numbers.json"
var anim_data_path: String = "res://Images/SpriteCollab/sprite/%s/AnimData.json"
var texture_path: String = "res://Images/SpriteCollab/sprite/%s/%s"
var error_texture_path: String = "res://Images/PokemonDebug/error_texture.png"
var loaded_error : bool = false
# key : pokemon name, value : string folder (es: "Bulbasaur" : "0001")
var poke_dict: Dictionary
# contains information about the animation of the pokemon
var animation_dict: Dictionary

export(String) var pokemon_name = "Bulbasaur" setget set_pokemon_name, get_pokemon_name
export(String) var animation_name : String= "Idle" setget set_animation_name, get_animation_name
var animation_names : PoolStringArray = [
	'Walk', 'Attack', 'Strike', 'Shoot', 'Twirl', 
	'Sleep', 'Hurt', 'Idle', 'Swing', 'Double', 'Hop', 'Charge',
	'Rotate', 'Dance', 'Shake', 'EventSleep', 'Wake', 'Eat', 'Tumble',
	'Pose', 'Pull', 'Pain', 'Float', 'DeepBreath', 'Nod', 'Sit', 'LookUp',
	'Sink', 'Trip', 'Laying', 'LeapForth', 'Head', 'Cringe', 'LostBalance', 
	'TumbleBack', 'Faint', 'HitGround', 'Kick', 'SpAttack', 'Withdraw', 'Ricochet',
	'FlapAround', 'Jab', 'Hover', 'TailWhip', 'StandingUp', 'QuickStrike', 'Shock', 
	'MultiScratch', 'Appeal', 'Emit', 'Rumble', 'Sound', 'RearUp', 'Special0', 'Slam',
	'Special1', 'Special2', 'Wiggle', 'Fainted', 'DigIn', 'DigOut', 'MultiStrike', 'Yawn', 
	'RaiseArms', 'CarefulWalk', 'Special3', 'Chop', 'Punch', 'Lick', 'Uppercut', 'Gas', 'Swell', 
	'Stomp', 'Slice', 'Slap', 'Injured']


# the name of the sprite is the animation name
# frame characteristics
var frame_width : float
var frame_heigth : float

#center of a pixel
var PIXEL_OFFEST = 0.5 

# Arrays that contain information about the offsets
# Green -> Center
# Black -> shooting point
# Red -> right hand
# Blue -> left hand
var right_offsets: Array
var left_offsets: Array
var center_offsets: Array
var shoot_offsets: Array
# offsets position
var right_position : Position2D setget , get_right_position
var left_position : Position2D setget , get_left_position
var center_position : Position2D setget , get_center_position
var shoot_position : Position2D setget , get_shoot_position
# name of the nodes
var RIGHT_POS_NAME : String =  "RightPosition"
var LEFT_POS_NAME : String =  "LeftPosition"
var CENTER_POS_NAME : String =  "CenterPosition"
var SHOOT_POS_NAME : String =  "ShootPosition"


# Constants
var RED = Color(1, 0, 0)
var BLUE = Color(0, 0, 1)
var GREEN = Color(0, 1, 0)
var BLACK = Color(0, 0, 0)

# Collisions
var collision_container : CollisionContainer
var COLLISIONS_NODE_NAME : String = "Collisions"
export(bool) var collision_visible : bool = false setget set_collision_visible, get_collision_visible

enum Centering {LEFT_CORNER, CENTERED, CENTERED_OFFSET}
export (Centering)  var centering setget set_centering, get_centering

# SETTERS AND GETTERS
# pokemon name
func set_pokemon_name(new_name : String):
	new_name = lower_and_capitalize(new_name)
	if new_name in poke_dict:
		pokemon_name = new_name

func get_pokemon_name() -> String:
	return pokemon_name

func lower_and_capitalize(string : String)-> String:
	return string.to_lower().capitalize()
# collision_visible
func set_collision_visible(new_value : bool):
	collision_visible = new_value
	var collision_node : CollisionContainer = get_node(COLLISIONS_NODE_NAME)
	# handles if called before ready
	if collision_node != null:
		get_node(COLLISIONS_NODE_NAME).set_visible(new_value)

func get_collision_visible() -> bool:
	return collision_visible

# centering
# overrides the usage of centered flag, so that it's easier to handle transformations
func set_centering(new_value):
	if centering == Centering.CENTERED_OFFSET:
		position += center_position.position
	elif centering == Centering.CENTERED:
		position += Vector2(frame_width/2, frame_heigth/2)
	centering = new_value
	set_centered(false)
	if centering == Centering.LEFT_CORNER:
		set_centered(false)
	elif centering == Centering.CENTERED:
		position -= Vector2(frame_width/2, frame_heigth/2)
	elif centering == Centering.CENTERED_OFFSET:
		position -= center_position.position
	property_list_changed_notify()

func get_centering():
	return centering

# position nodes
func get_right_position() -> Position2D:
	return right_position

func get_left_position() -> Position2D:
	return left_position

func get_center_position() -> Position2D:
	return center_position

func get_shoot_position() -> Position2D:
	return shoot_position

# animation name
func set_animation_name(new_name : String) -> void:
	if new_name in animation_names:
		animation_name = new_name
		load_all()


func get_animation_name() -> String:
	return animation_name

#******************** END SETGET ***********
func _init() -> void:
	var file: File = File.new()
	var error_value = file.open(poke_num_file_path, File.READ)
	if error_value != OK:
		push_error("Problem while opening the pokemon-folder association file.")
	poke_dict = parse_json(file.get_as_text())
	file.close()

func _ready():
	create_positions()
	load_all()
	connect("frame_changed", self, "on_frame_changed")

func create_positions() -> void:
	right_position = Position2D.new()
	right_position.name = RIGHT_POS_NAME
	left_position = Position2D.new()
	left_position.name = LEFT_POS_NAME
	center_position = Position2D.new()
	center_position.name = CENTER_POS_NAME
	shoot_position = Position2D.new()
	shoot_position.name = SHOOT_POS_NAME


func load_all():
	loaded_error = false
	load_sprite()
	add_positions_to_tree()
	load_offsets()
	add_collision_container_to_tree()
	load_collisions()
	on_frame_changed()

func load_sprite() -> void:
	# preprocessing, resetting old properties
	clear_offsets()
	#add_positions()
	# error if pokemon not present
	if !poke_dict.has(pokemon_name):
		push_warning("The pokemon " + pokemon_name + " is not present in the dictionary.")
		load_error_texture()
		return 
	var folder_number = poke_dict[pokemon_name]
	var anim_data_file = File.new()
	var err = anim_data_file.open(anim_data_path % [folder_number], File.READ)
	if err != OK:
		load_error_texture()
	else:
		# load animation texture
		animation_dict = parse_json(anim_data_file.get_as_text())
		# "strike" bay be corrected to "hit", for example
		var anim_name: String = get_anim_property(animation_name, "Name")
		if anim_name == "":
			load_error_texture()
		else:
			self.texture = load(texture_path % [folder_number, get_anim_filename(anim_name)])
			self.texture.flags = 0
			frame_heigth = get_anim_property(animation_name, "FrameHeight").to_int()
			frame_width = get_anim_property(animation_name, "FrameWidth").to_int()
			self.hframes = int(self.texture.get_width() / frame_width)
			self.vframes = int(self.texture.get_height() / frame_heigth)
			self.visible = true

	anim_data_file.close()

func clear_offsets():
	right_offsets.clear()
	left_offsets.clear()
	center_offsets.clear()
	shoot_offsets.clear()

func load_error_texture() -> void:
	loaded_error = true
	texture = load(error_texture_path)
	hframes = 1
	vframes = 1
	visible = true
	texture.flags = 0
	frame_width = texture.get_width()
	frame_heigth = texture.get_height() 

func get_anim_filename(anim_name: String) -> String:
	var anims = animation_dict["AnimData"]["Anims"]["Anim"]
	for anim in anims:
		if anim["Name"] == anim_name:
			if anim.has("CopyOf"):
				return get_anim_filename(anim["CopyOf"])
			else:
				return "%s-Anim.png" % anim["Name"]
	push_error("Something went wrong while finding the filename")
	return ""

func get_anim_property(anim_name: String, property_name: String) -> String:
	var anims = animation_dict["AnimData"]["Anims"]["Anim"]
	for anim in anims:
		if anim["Name"] == anim_name:
			if anim.has("CopyOf"):
				return get_anim_property(anim["CopyOf"], property_name)
			else:
				return anim[property_name]
	push_warning("The animation " + anim_name + " is not present.")
	return ""

func add_positions_to_tree():
	if self.get_node_or_null(RIGHT_POS_NAME) == null:
		print("right position", right_position)
		right_position.set_owner(self)
	if self.get_node_or_null(LEFT_POS_NAME) == null:
		add_child(self.left_position)
		left_position.set_owner(self)
	if self.get_node_or_null(CENTER_POS_NAME) == null:
		add_child(self.center_position)
		center_position.set_owner(self)
	if self.get_node_or_null(SHOOT_POS_NAME) == null:
		add_child(self.shoot_position)
		shoot_position.set_owner(self)
	right_position = get_node(RIGHT_POS_NAME)
	left_position = get_node(LEFT_POS_NAME)
	center_position = get_node(CENTER_POS_NAME)
	shoot_position = get_node(SHOOT_POS_NAME)	

func load_offsets():
	if loaded_error:
		var text_dims : Vector2 = Vector2(texture.get_width()/2, texture.get_height()/2)
		right_offsets.append(text_dims)
		left_offsets.append(text_dims)
		center_offsets.append(text_dims)
		shoot_offsets.append(text_dims)
		return 
	#load offset texture
	var folder_number = poke_dict[pokemon_name]
	var anim_name: String = get_anim_property(animation_name, "Name")
	var file_name = "%s-Offsets.png" % [anim_name]
	var offset_text_path = texture_path % [folder_number, file_name]
	var texture = load(offset_text_path)
	texture.flags = 0
	# convert to image
	var image: Image = texture.get_data()
	# vframes is the number of vertical frames in the sprite
	for i in range(vframes):
		for j in range(hframes):
			var red_pos: Vector2 = get_color_position(
				image,
				RED,
				frame_heigth * i,
				frame_heigth * (i + 1),
				frame_width * j,
				frame_width * (j + 1)
			)
			var blue_pos: Vector2 = get_color_position(
				image,
				BLUE,
				frame_heigth * i,
				frame_heigth * (i + 1),
				frame_width * j,
				frame_width * (j + 1)
			)
			var green_pos: Vector2 = get_color_position(
				image,
				GREEN,
				frame_heigth * i,
				frame_heigth * (i + 1),
				frame_width * j,
				frame_width * (j + 1)
			)
			var black_pos: Vector2 = get_color_position(
				image,
				BLACK,
				frame_heigth * i,
				frame_heigth * (i + 1),
				frame_width * j,
				frame_width * (j + 1)
			)
			right_offsets.append(red_pos)
			left_offsets.append(blue_pos)
			center_offsets.append(green_pos)
			shoot_offsets.append(black_pos)

func get_color_position(
	image: Image, color: Color, start_row: int, end_row: int, start_col: int, end_col: int
) -> Vector2:
	image.lock()
	for i in range(start_row, end_row):
		for j in range(start_col, end_col):
			var pixel_value = image.get_pixel(j, i)
			if pixel_value.is_equal_approx(color):
				image.unlock()
				return Vector2(j - start_col +PIXEL_OFFEST, i - start_row + PIXEL_OFFEST)
	image.unlock()
	return Vector2(0, 0)

func load_collisions() -> void:
	if self.texture == null:
		push_error("Error while loading collisions. Try to call load_properties before this method")
	var collisions_arr : Array = CollisionExctractor.new().get_collision_polygons(self)
	collision_container.add_collisions(collisions_arr)

func add_collision_container_to_tree():
	if self.get_node_or_null(COLLISIONS_NODE_NAME) == null:
		collision_container = CollisionContainer.new()
		collision_container.set_name(COLLISIONS_NODE_NAME)
		add_child(collision_container)
		collision_container.set_owner(self)
	else:
		collision_container = self.get_node(COLLISIONS_NODE_NAME)
		collision_container.remove_collisions()

func on_frame_changed():
	# var old_right_pos : Vector2 = right_position.position
	# var old_left_pos : Vector2 = left_position.position
	var old_center_pos : Vector2 = center_position.position
	# var old_shoot_pos : Vector2 = shoot_position.position

	right_position.position = right_offsets[frame]
	left_position.position = left_offsets[frame]
	center_position.position = center_offsets[frame]
	shoot_position.position = shoot_offsets[frame]
	
	if centering == Centering.LEFT_CORNER:
		pass
	elif centering == Centering.CENTERED:
		pass
	elif centering == Centering.CENTERED_OFFSET:
		position += old_center_pos
		position -= center_position.position

	collision_container.change_frame(frame)
