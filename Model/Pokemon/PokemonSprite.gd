tool
extends Sprite
class_name PokemonSprite

# PATHS
var poke_num_file_path: String = "res://Images/SpriteCollab/poke-numbers.json"
var anim_data_path: String = "res://Images/SpriteCollab/sprite/%s/AnimData.json"
var texture_path: String = "res://Images/SpriteCollab/sprite/%s/%s"
var error_texture_path: String = "res://Images/error_texture.png"
# key : pokemon name, value : string folder (es: "Bulbasaur" : "0001")
var poke_dict: Dictionary
# contains information about the animation of the pokemon
var animation_dict: Dictionary

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
var right_position : Position2D
var left_position : Position2D
var center_position : Position2D
var shoot_position : Position2D
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


func _init() -> void:
	var file: File = File.new()
	var error_value = file.open(poke_num_file_path, File.READ)
	if error_value != OK:
		push_error("Problem while opening the pokemon-folder association file.")
	poke_dict = parse_json(file.get_as_text())


func _ready():
	right_position = Position2D.new()
	right_position.name = RIGHT_POS_NAME
	left_position = Position2D.new()
	left_position.name = LEFT_POS_NAME
	center_position = Position2D.new()
	center_position.name = CENTER_POS_NAME
	shoot_position = Position2D.new()
	shoot_position.name = SHOOT_POS_NAME
	clear_offsets()
	add_positions()
	add_collisions()
	connect("frame_changed", self, "on_frame_changed")

func add_positions():
	if self.get_node(RIGHT_POS_NAME) == null:
		add_child(right_position)
		right_position.set_owner(self.get_owner())
	if self.get_node(LEFT_POS_NAME) == null:
		add_child(self.left_position)
		left_position.set_owner(self.get_owner())
	if self.get_node(CENTER_POS_NAME) == null:
		add_child(self.center_position)
		center_position.set_owner(self.get_owner())
	if self.get_node(SHOOT_POS_NAME) == null:
		add_child(self.shoot_position)
		shoot_position.set_owner(self.get_owner())
	right_position = get_node(RIGHT_POS_NAME)
	left_position = get_node(LEFT_POS_NAME)
	center_position = get_node(CENTER_POS_NAME)
	shoot_position = get_node(SHOOT_POS_NAME)

func add_collisions():
	if self.get_node(COLLISIONS_NODE_NAME) == null:
		collision_container = CollisionContainer.new()
		collision_container.set_name(COLLISIONS_NODE_NAME)
		add_child(collision_container)
		collision_container.set_owner(self.get_owner())
	else:
		collision_container = self.get_node(COLLISIONS_NODE_NAME)
		collision_container.remove_collisions()


func load_properties(name: String) -> void:
	# preprocessing, resetting old properties
	clear_offsets()
	add_positions()
	# the name of the sprite is the animation name
	var animation_name = get_name()
	# error if pokemon not present
	if !poke_dict.has(name):
		push_error("The pokemon " + name + " is not present in the dictionary.")
	var folder_number = poke_dict[name]
	var anim_data_file = File.new()
	var err = anim_data_file.open(anim_data_path % [folder_number], File.READ)
	if err != OK:
		load_error_texture()
	else:
		# load animation texture
		animation_dict = parse_json(anim_data_file.get_as_text())
		self.texture = load(texture_path % [folder_number, get_anim_filename(animation_name)])
		self.texture.flags = 0
		frame_heigth = get_anim_property(animation_name, "FrameHeight").to_int()
		frame_width = get_anim_property(animation_name, "FrameWidth").to_int()
		self.hframes = self.texture.get_width() / frame_width
		self.vframes = self.texture.get_height() / frame_heigth
		self.visible = false
		# load red position
		load_offsets(animation_name, folder_number)

	anim_data_file.close()


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
	push_error("The animation " + anim_name + " is not present.")
	return ""


func load_offsets(animation_name: String, folder_number: String):
	# image properties
	var frame_heigth: int = get_anim_property(animation_name, "FrameHeight").to_int()
	var frame_width: int = get_anim_property(animation_name, "FrameWidth").to_int()
	var hframes: int = self.texture.get_width() / frame_width
	var vframes: int = self.texture.get_height() / frame_heigth
	#load offset texture
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


func clear_offsets():
	right_offsets.clear()
	left_offsets.clear()
	center_offsets.clear()
	shoot_offsets.clear()


func load_error_texture() -> void:
	self.texture = load(error_texture_path)

func load_collisions() -> void:
	if self.texture == null:
		push_error("Error while loading collisions. Try to call load_properties before this method")
	var collisions_arr : Array = CollisionExctractor.new().get_collision_polygons(self)
	collision_container.add_collisions(collisions_arr)

func on_frame_changed():
	right_position.position = right_offsets[frame]
	left_position.position = left_offsets[frame]
	center_position.position = center_offsets[frame]
	shoot_position.position = shoot_offsets[frame]
	if centered:
		right_position.position -= Vector2(frame_width/2, frame_heigth/2)
		left_position.position -= Vector2(frame_width/2, frame_heigth/2)
		center_position.position -= Vector2(frame_width/2, frame_heigth/2)
		shoot_position.position -= Vector2(frame_width/2, frame_heigth/2)
