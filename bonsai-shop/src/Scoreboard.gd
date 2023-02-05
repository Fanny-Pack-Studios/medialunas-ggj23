extends Node

var _score := 0
var lastScore := 0

var level := 1

signal score_changed(to, by)
signal level_changed(to)


func add_points(to_add: int):
	_score += to_add
	lastScore = to_add
	emit_signal("score_changed", _score, to_add)
	if _score >= get_target_points():
		level += 1
		_score = 0
		level_changed.emit(level)


func get_points():
	return _score


func get_target_points():
	return level * 5
