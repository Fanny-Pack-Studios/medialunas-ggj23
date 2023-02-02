@tool
extends Polygon2D


func _ready():
	var pts := PackedVector2Array()
	var rsd := PackedVector2Array()
	for i in 32:
		pts.append(Vector2(100.0,0.0).rotated(i * 2 * PI / 32))
	var ps = [PackedInt32Array(range(0,32)), PackedInt32Array(range(32,64))]
	rsd = pts
	rsd.reverse()
	for p in rsd:
		pts.append(p*.5)
	polygon = pts
	polygons = ps
