extends Control

@onready var scoreLabel : Label= $Score
@onready var timerLabel : Label= $Timer


func _process(_delta):
	scoreLabel.text = "%d" %Scoreboard.get_points()
	timerLabel.text = "%d" %(get_node("/root/GameScene/ActualTimer").get_time_left())
