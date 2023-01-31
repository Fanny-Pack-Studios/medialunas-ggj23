extends Polygon2D

const MIN_DISTANCE := 120
const CENTER_OFFSET := .9
const ANGLES := 20


func _ready():
	generate_points()


func generate_points():
	var points := PackedVector2Array()
	var center := Vector2(0, MIN_DISTANCE * CENTER_OFFSET)
	for i in ANGLES:
		var point_offset := Vector2(MIN_DISTANCE, 0).rotated(
			i * 2 * PI / ANGLES
		)
		points.append(point_offset + center)
	polygon = points


func cut(new_polygon: PackedVector2Array):
	var results = Geometry2D.clip_polygons(get_points(), new_polygon)
	for result in results:
		if Geometry2D.is_point_in_polygon(global_position, result):
			set_points(result)
			return


func get_points() -> PackedVector2Array:
	var new_points := PackedVector2Array()
	for point in polygon:
		new_points.append(to_global(point))
	return new_points


func set_points(new_points: PackedVector2Array):
	var points := PackedVector2Array()
	for point in new_points:
		points.append(to_local(point))
	polygon = points
