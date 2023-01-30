extends Node2D

@export var cutter_scene :PackedScene

@onready var mata : Polygon2D= $Mata

const CUT_WIDTH := 2
const ANGLES := 10

var points:PackedVector2Array
var cutting := false

var cutters := []
var cutter_polygon : PackedVector2Array

func _ready():
	reset_points()

func reset_points():
	points = PackedVector2Array()

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		add_point_to_cutter()
		cutting = true
	elif cutting == true:
		finish_cutter()

func add_point_to_cutter():
	var mouse_pos = get_viewport().get_mouse_position()
	if not cutting:
		reset_points()
	points.append(mouse_pos)
	show_cutter()

func show_cutter():
	for cutter in cutters:
		cutter.queue_free()
	cutters = []
	var final_points := PackedVector2Array(points)
	var reverse_points := PackedVector2Array()
	for point in points:
		var offset = (point - mata.geo_center).normalized() * CUT_WIDTH
		reverse_points.append(point + offset)
	for i in reverse_points.size():
		final_points.append(reverse_points[reverse_points.size()-1-i])

	var polygons = Geometry2D.offset_polygon(final_points, CUT_WIDTH)
	if polygons.size() == 0:
		return
	var cutter = cutter_scene.instantiate()
	add_child(cutter)
	cutter_polygon = polygons[0]
	cutter.polygon = cutter_polygon
	cutters.append(cutter)

func finish_cutter():
	show_cutter()
	mata.cut(cutter_polygon)
	cutting = false
