class_name Triangle
extends Object

var a: Vector2
var b: Vector2
var c: Vector2


func _init(a_in: Vector2, b_in: Vector2, c_in: Vector2):
	a = a_in
	b = b_in
	c = c_in


func get_area():
	# https://mathopenref.com/coordtrianglearea.html
	return abs(
		(
			(
				a.x * (b.y - c.y)
				+ b.x * (c.y - a.y)
				+ c.x * (a.y - b.y)
			)
			/ 2.0
		)
	)
