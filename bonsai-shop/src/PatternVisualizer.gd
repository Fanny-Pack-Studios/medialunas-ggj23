@tool
extends Polygon2D

@export var pattern : Pattern : set = set_pattern

func set_pattern(new_pattern:Pattern):
	pattern = new_pattern
	if new_pattern:
		polygon = new_pattern.get_points()
	

var time := 0.0
func _process(delta:float):
	time += delta
	var alpha = (sin(time)+1.0)/8.0
	color.a = alpha
