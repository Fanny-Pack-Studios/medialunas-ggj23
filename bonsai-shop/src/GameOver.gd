extends Control


func _ready():
	$Label2.text = "Level: %d" % Scoreboard.level
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://src/UI_TitleScreen.tscn")

