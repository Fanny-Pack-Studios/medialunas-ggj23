extends Control

@onready var scoreLabel : Label= $Score
@onready var partialScoreLabel : Label= $Score2
@onready var timerLabel : Label= $Timer


func _process(delta):
	scoreLabel.text = "Croassiants: %d" %Scoreboard.get_points()
	timerLabel.text = "Time: %d" %(get_node("/root/GameScene/ActualTimer").get_time_left())
