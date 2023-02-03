extends Node2D

@onready var mata := get_parent()

func _ready():
	var children = get_children()
	for i in children.size():
		children[i].polygon= mata.base_circle(1.0 - i*.05)
		children[i].texture_rotation = (1+i)*PI/(children.size())

func set_shape(poly:PackedVector2Array):
	for child in get_children():
		var results = Geometry2D.intersect_polygons(poly, child.polygon)
		if results.size() >= 1:
			child.polygon = results[0]
