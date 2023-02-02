extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_press_enter_pressed():
	$PressEnter.visible = false
	$MenuOptions.visible = true


func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://src/GameScene.tscn")


func _on_settings_pressed():
	$MenuOptions.visible = false
	$SettingsPanel.visible = true


func _on_back_settings_pressed():
	$SettingsPanel.visible = false
	$MenuOptions.visible = true
