extends Node2D

@export var mata_scene : PackedScene
@export var pattern_scene : PackedScene
@export var cutter_scene : PackedScene

@onready var mata : Polygon2D= $Mata
@onready var pattern : Polygon2D= $PatternVisualizer

const CUT_WIDTH := 2
const ANGLES := 10
const AREA_THRESHOLD := 60.0
const MAX_MOUSE_DISTANCE := 250.0

var points:PackedVector2Array
var cutting := false

var cutters := []
var current_cutter : PackedVector2Array

signal plant_finished

class PointThreshold:
	var points : int
	var message : String
	func _init(a_points:int, a_message: String):
		points = a_points 
		message = a_message


var points_thresholds := {
	800: PointThreshold.new(3,"PERFECT"),
	1500: PointThreshold.new(2,"GREAT"),
	2300: PointThreshold.new(1,"GOOD"),
	3000: PointThreshold.new(0,"POOR"),
	5000: PointThreshold.new(0,"REALLY_BAD"),
}
const LOWER_THRESHOLD_MESSAGE ="DISGUSTING"

func _ready():
	reset_points()

func reset_points():
	points = PackedVector2Array()
	current_cutter = PackedVector2Array()
	show_cutter()

const FRAMES_TO_SKIP := 4
var skip_frame := 0
func _process(delta):
	skip_frame += 1
	skip_frame %= FRAMES_TO_SKIP
	if skip_frame != 0:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (mata.global_position-get_viewport().get_mouse_position()).length() < MAX_MOUSE_DISTANCE:
		add_point_to_cutter(delta)
		cutting = true
	elif cutting == true:
		finish_cutter()

func add_point_to_cutter(delta:float):
	var mouse_pos = get_viewport().get_mouse_position()
	if not cutting:
		reset_points()
	var current_area = area_of_polygon(current_cutter)
	var old_cutter = current_cutter
	points.append(mouse_pos)
	current_cutter=cutter_polygon()
	var next_area = area_of_polygon(current_cutter)
	if next_area > 100.0 && next_area > current_area+Input.get_last_mouse_velocity().length()*delta*AREA_THRESHOLD*CUT_WIDTH:
		current_cutter = old_cutter
		finish_cutter()
		return
	$CutterParticles.set_emitting(Geometry2D.is_point_in_polygon(mouse_pos, mata.points_to_global(mata.polygon)))
	$CutterParticles.global_position = mouse_pos
	show_cutter()

func cutter_polygon()->PackedVector2Array:
	var final_points := PackedVector2Array(points)
	var reverse_points := PackedVector2Array()
	for point in points:
		var offset = (point - mata.global_position).normalized() * CUT_WIDTH
		reverse_points.append(point + offset)
	for i in reverse_points.size():
		final_points.append(reverse_points[reverse_points.size()-1-i])

	var polygons = Geometry2D.offset_polygon(final_points, CUT_WIDTH)
	if polygons.size() == 0:
		return PackedVector2Array()
	return polygons[0]

func show_cutter():
	var poly = current_cutter
	for cutter in cutters:
		cutter.queue_free()
	cutters = []
	var cutter = cutter_scene.instantiate()
	add_child(cutter)
	cutter.polygon = poly
	cutters.append(cutter)

func finish_cutter():
	show_cutter()
	mata.cut(current_cutter)
	$CutterParticles.set_emitting(false)
	cutting = false

func area_of_polygon(polygon: PackedVector2Array)->float:
	var triangle_indices := Geometry2D.triangulate_polygon(polygon)
	var area := 0.0
	for i in (triangle_indices.size() / 3.0):
		var j = i*3
		var triangle := Triangle.new(polygon[triangle_indices[j]], polygon[triangle_indices[j+1]], polygon[triangle_indices[j+2]])
		area += triangle.get_area()
	return area

func area_of_excluded(poly_a:PackedVector2Array,poly_b:PackedVector2Array)->float:
	var clipped := Geometry2D.clip_polygons(poly_a,poly_b)
	var area := 0.0
	for polygon in clipped:
		area += area_of_polygon(polygon)
	return area

func plant_done():
	var target :PackedVector2Array= pattern.polygon
	var current :PackedVector2Array= mata.polygon
	if not Geometry2D.is_polygon_clockwise(target):
		target.reverse()
	if not Geometry2D.is_polygon_clockwise(current):
		current.reverse()
	var total_error_area = area_of_excluded(current, target) + area_of_excluded(target, current);
	var threshold: PointThreshold
	for value in points_thresholds.keys():
		if total_error_area < value:
			threshold = points_thresholds[value]
			Scoreboard.add_points(threshold.points)
			break

	var feedback := Feedback.new(threshold.message if threshold else LOWER_THRESHOLD_MESSAGE)
	$FeedbackPos.add_child(feedback)
	emit_signal("plant_finished")

func change_plant(new_bonsai):
	reset_points()
	var bonsai_pos = new_bonsai.global_position
	var bonsai_scale = new_bonsai.global_scale
	new_bonsai.get_parent().remove_child(new_bonsai)
	var pos = mata.position
	mata.queue_free()
	mata = mata_scene.instantiate()
	add_child(mata)
	mata.scale = Vector2(.01,.01)
	mata.position = pos

	pattern.queue_free()
	pattern = pattern_scene.instantiate()
	add_child(pattern)
	pattern.position = pos

	mata.add_child(new_bonsai)
	new_bonsai.global_position = bonsai_pos
	new_bonsai.global_scale = bonsai_scale
	await get_tree().process_frame
	new_bonsai.move_to(mata.to_global(Vector2.ZERO))
	var tween = create_tween()
	tween.tween_property(new_bonsai, "scale", Vector2(1.0,1.0),.2)
	tween.tween_property(mata, "scale", Vector2(1.0,1.0),.2)
