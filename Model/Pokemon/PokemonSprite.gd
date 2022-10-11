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
# Arrays that contain information about the offsets
export var red_offsets: Array
export var blue_offsets: Array
export var green_offsets: Array
export var black_offsets: Array

# Constants
var RED = Color(1, 0, 0)
var BLUE = Color(0, 1, 0)
var GREEN = Color(0, 0, 1)
var BLACK = Color(1, 1, 1)


func _init() -> void:
	var file: File = File.new()
	var error_value = file.open(poke_num_file_path, File.READ)
	if error_value != OK:
		push_error("Problem while opening the pokemon-folder association file.")
	poke_dict = parse_json(file.get_as_text())


func _ready():
	clear_offsets()


func load_properties(name: String) -> void:
	# preprocessing, resetting old properties
	clear_offsets()
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
		var frame_heigth = get_anim_property(animation_name, "FrameHeight").to_int()
		var frame_width = get_anim_property(animation_name, "FrameWidth").to_int()
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
			red_offsets.append(red_pos)
			blue_offsets.append(blue_pos)
			green_offsets.append(green_pos)
			black_offsets.append(black_pos)


func get_color_position(
	image: Image, color: Color, start_row: int, end_row: int, start_col: int, end_col: int
) -> Vector2:
	image.lock()
	for i in range(start_row, end_row):
		for j in range(start_col, end_col):
			var pixel_value = image.get_pixel(j, i)
			if pixel_value.is_equal_approx(color):
				image.unlock()
				return Vector2(i - start_row, j - start_col)
	image.unlock()
	return Vector2(0, 0)


func clear_offsets():
	red_offsets.clear()
	blue_offsets.clear()
	green_offsets.clear()
	black_offsets.clear()


func load_error_texture() -> void:
	self.texture = load(error_texture_path)
