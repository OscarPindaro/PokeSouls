extends Node
class_name CollisionExctractor

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var EPSILON = 0

func get_collision_polygons(sprite : Sprite) -> Array:
	var coll_pols : Array = []
	var bm = BitMap.new()
	var frame_width = sprite.texture.get_width() / sprite.hframes
	var frame_heigth = sprite.texture.get_height() / sprite.vframes
	bm.create_from_image_alpha(sprite.texture.get_data())
	for j in range(sprite.vframes):
		for i in range(sprite.hframes):
			var rect : Rect2 = Rect2(i*frame_width, j*frame_heigth, frame_width, frame_heigth)
			var my_array = bm.opaque_to_polygons(rect, EPSILON)
			var poly : CollisionPolygon2D = CollisionPolygon2D.new()
			var pointArr = PoolVector2Array()
			for p in my_array[0]:
				pointArr.append(p)
			poly.polygon = pointArr
			poly.position.y -= 2*j*frame_heigth # no idea why needs to muliply by 2
			coll_pols.append(poly)
			poly.position.x -= frame_width/2
			poly.position.y -= frame_heigth/2

	return coll_pols
