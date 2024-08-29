extends Node3D


func _ready():
	Scoreboard.score_changed.connect(on_score)


func on_score(_to_points, _delta):
	$capy/AnimationPlayer.play("macetaAction")
