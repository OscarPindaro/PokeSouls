extends Node
class_name CollExtract

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var EPSILON = 0


# returns a collision polygon for each sprite frame of a given sprite sheet,
# whith the left corner of the frame in the origin of the carthesian plane.
static func get_collision_polygons(sprite: Sprite2D, epsilon=0.) -> Array:
	var coll_pols: Array = []
	var bm = BitMap.new()
	var frame_width: int = sprite.texture.get_width() / sprite.hframes
	var frame_heigth: int = sprite.texture.get_height() / sprite.vframes
	bm.create_from_image_alpha(sprite.texture.get_image())

	for j in range(sprite.vframes):
		for i in range(sprite.hframes):
			var rect: Rect2 = Rect2(i * frame_width, j * frame_heigth, frame_width, frame_heigth)
			bm.grow_mask(1, rect)
			var my_array = bm.opaque_to_polygons(rect, epsilon)
			# var min_row: int = j * frame_heigth
			# var min_col: int = i * frame_width
			# var max_row: int = min_row + frame_heigth
			# var max_col: int = min_col + frame_width
			var poly: CollisionPolygon2D = CollisionPolygon2D.new()
			var pointArr = PackedVector2Array()

			for p in my_array[0]:
				pointArr.append(p)
			for p in my_array[0]:
				for q in my_array[0]:
					if p.x == q.x and p.y == q.y and p != q:
						print("aaaaaaaa")
			poly.polygon = pointArr
			poly.position.y -= 2 * j * frame_heigth  # no idea why needs to muliply by 2
			coll_pols.append(poly)
	return coll_pols


# returns the number of true bits in the rectangle from (min_row, min_col) to (max_row, max_col), where
# these points are the upper-left and down-right edge
static func get_true_bit_count_rect(map: BitMap, min_row: int, min_col: int, max_row: int, max_col: int):
	var n_bits = 0
	for row_index in range(min_row, max_row):
		for col_index in range(min_col, max_col):
			# the index are reversed because the rows are mapped to y
			# while the cols are mapped to x
			if map.get_bitv(Vector2(col_index, row_index)):
				n_bits += 1
	return n_bits
