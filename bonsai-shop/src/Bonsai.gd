extends Node2D

@export var trunk_scene : PackedScene
@export var leaves_scene : PackedScene
@export var flower_scene : PackedScene

@export var trunk_gradient : Gradient

const MIN_PARTS := 10
const MAX_PARTS := 20

const MAX_FLOWERS := 3

const SEGMENT_LENGTH := 10

const MIN_ANGLE := -PI/4
const MAX_ANGLE := PI/4

const MIN_BRANCH_ANGLE := PI/4
const MAX_BRANCH_ANGLE := PI/2

const MAX_DEPTH := 3
const BRANCH_CHANCE := .1

var leaves_spawnpoints := PackedVector2Array()
@onready var color := trunk_gradient.sample(randf())

func _ready():
	var parts := randi_range(MIN_PARTS, MAX_PARTS)
	generate_trunk(Vector2(0,0), parts)
	generate_roots()
	spawn_leaves()
	if randi() %2 == 0:
		spawn_flowers()

func spawn_leaves():
	for point in leaves_spawnpoints:
		var leaves :=leaves_scene.instantiate()
		add_child(leaves)
		var leave_scale :=randf_range(.5,1.0)
		leaves.scale = Vector2(leave_scale,leave_scale)
		leaves.position = point

func spawn_flowers():
	var amount := min(randi_range(1,leaves_spawnpoints.size()),MAX_FLOWERS)
	var candidate_positions := Array(leaves_spawnpoints)
	candidate_positions.shuffle()
	for i in amount:
		var flower_position :Vector2= candidate_positions[i]
		var flower:= flower_scene.instantiate()
		add_child(flower)
		flower.position = flower_position + Vector2(randf_range(-32,32),0)

func generate_roots():
	generate_trunk(Vector2(0,0), 5, .75*PI, 20, false)
	generate_trunk(Vector2(0,0), 5, -.75*PI, 20, false)
	generate_trunk(Vector2(0,0), 5, .75*PI, 20, false)
	generate_trunk(Vector2(0,0), 5, -.75*PI, 20, false)

func generate_trunk(starting_point: Vector2, parts: int, base_rotation:=0.0,  width:= 30, with_leaves := true, depth:=0):
	var trunk := trunk_scene.instantiate()
	add_child(trunk)
	trunk.material.set_shader_parameter("base_color",color)
	trunk.width = width
	trunk.material.set_shader_parameter("rotation",wrapf(base_rotation,0,2*PI))
	var last_point := starting_point
	var trunk_points := PackedVector2Array([last_point])
	for i in parts:
		var vec := Vector2(0,-SEGMENT_LENGTH).rotated(base_rotation+randf_range(MIN_ANGLE, MAX_ANGLE))
		last_point += vec
		trunk_points.append(last_point)
		if with_leaves and (i == parts-1 or (i > parts / 3.0 && randi() % 3 == 0)):
			leaves_spawnpoints.append(last_point)
	trunk.points = trunk_points
	for i in trunk_points.size():
		if i == 0: continue
		if depth < 1 and randf() < BRANCH_CHANCE:
			var point := trunk_points[i]
			var angle := ((randi()%2)*2-1)*randf_range(MIN_BRANCH_ANGLE,MAX_BRANCH_ANGLE)
			generate_trunk(point, parts-i,angle,width_at(point,trunk),with_leaves, depth +1)

func width_at(point:Vector2, line: Line2D):
	var curve := Curve2D.new()
	for p in line.points:
		curve.add_point(p)
	var offset := curve.get_closest_offset(point) / curve.get_baked_length()
	return line.width * line.width_curve.sample_baked(offset)
