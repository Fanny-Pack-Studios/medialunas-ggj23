extends Polygon2D

const BASE_DISTANCE := 80
const CENTER_OFFSET := 1.0
const ANGLES := 20

@onready var dirt := $Dirt

func _ready():
	set_shape(generate_points(
		BASE_DISTANCE, Vector2(0, BASE_DISTANCE)
	))


func generate_points(at_distance: float, center := Vector2(0, 0)) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in ANGLES:
		var point_offset := Vector2(at_distance, 0).rotated(
			-i * 2 * PI / ANGLES
		)
		points.append(point_offset + center)
	return points


func cut(new_polygon: PackedVector2Array):
	var results = Geometry2D.clip_polygons(get_points(), new_polygon)
	for result in results:
		if Geometry2D.is_point_in_polygon(global_position, result):
			set_shape(points_to_local(result))
			return


func get_points() -> PackedVector2Array:
	var new_points := PackedVector2Array()
	for point in polygon:
		new_points.append(to_global(point))
	return new_points


func points_to_global(new_points: PackedVector2Array):
	var points := PackedVector2Array()
	for point in new_points:
		points.append(to_global(point))
	return points


func points_to_local(new_points: PackedVector2Array):
	var points := PackedVector2Array()
	for point in new_points:
		points.append(to_local(point))
	return points

func set_shape(new_points: PackedVector2Array):
	polygon = new_points
	var dirt_polygon := PackedVector2Array()
	for point in new_points:
		dirt_polygon.append(point * .95)
	dirt.polygon = dirt_polygon
