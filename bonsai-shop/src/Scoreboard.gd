extends Node

var _score := 0

signal score_changed(to, by)


func add_points(to_add: int):
	_score += to_add
	emit_signal("score_changed", _score, to_add)


func get_points():
	return _score
