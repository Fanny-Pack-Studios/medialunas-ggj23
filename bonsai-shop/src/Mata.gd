extends Polygon2D

const MIN_DISTANCE := 120
const CENTER_OFFSET := .9
const ANGLES := 20

var geo_center: Vector2


func _ready():
	geo_center = global_position
	global_position = Vector2.ZERO
	generate_points()


func generate_points():
	var points := PackedVector2Array()
	var center := (
		geo_center
		+ Vector2(0, MIN_DISTANCE * CENTER_OFFSET)
	)
	for i in ANGLES:
		var point_offset := Vector2(MIN_DISTANCE, 0).rotated(
			i * 2 * PI / ANGLES
		)
		points.append(point_offset + center)
	polygon = points


func cut(new_polygon: PackedVector2Array):
	var results = Geometry2D.clip_polygons(polygon, new_polygon)
	for result in results:
		if Geometry2D.is_point_in_polygon(geo_center, result):
			polygon = result
			return
