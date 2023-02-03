@tool
extends Polygon2D

const BASE_DISTANCE := 80
const CENTER_OFFSET := .9
const ANGLES := 40

@onready var dirt := $Dirt

func _ready():
	set_shape(generate_points(
		BASE_DISTANCE, Vector2(0, BASE_DISTANCE*CENTER_OFFSET)
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
	var scores := []
	scores.resize(results.size())
	scores.fill(0)
	for i in results.size():
		for point in $PointsToInclude.get_children():
			if(Geometry2D.is_point_in_polygon(point.global_position, results[i])):
				scores[i] += 1
	var max_score := 0
	var idx := 0
	for i in scores.size():
		if scores[i] > max_score:
			max_score = scores[i]
			idx = i
	set_shape(points_to_local(results[idx]))


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
