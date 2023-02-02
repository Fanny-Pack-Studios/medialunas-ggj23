@tool
extends Polygon2D

@export var pattern : Pattern : set = set_pattern

var patterns := {
	'Crown' : preload("res://src/Patterns/Crown.tres"),
	'Diamond' : preload("res://src/Patterns/Diamond.tres"),
	'Egg' : preload("res://src/Patterns/Egg.tres"),
	'Square' : preload("res://src/Patterns/Square.tres"),
	'Trap' : preload("res://src/Patterns/Trap.tres"),
	'Triangle' : preload("res://src/Patterns/Triangle.tres"),
}

func _ready():
	set_pattern(patterns.values()[randi() % patterns.keys().size()])

func set_pattern(new_pattern:Pattern):
	pattern = new_pattern
	if new_pattern:
		polygon = new_pattern.get_points()
	

var time := 0.0
func _process(delta:float):
	time += delta
	var alpha = (sin(time)+1.0)/8.0
	color.a = alpha
