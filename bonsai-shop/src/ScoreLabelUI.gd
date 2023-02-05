extends Control

@onready var scoreLabel : Label= $Score
@onready var timerLabel : Label= $Timer
@onready var levelLabel : Label= $Level

func level_up(_level):
	levelLabel.scale = Vector2(2.0,2.0)
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(levelLabel, "scale",Vector2(1.0,1.0), 1.5)

func _ready():
	Scoreboard.level_changed.connect(level_up)

func _process(_delta):
	scoreLabel.text = "%d / %d" %[Scoreboard.get_points(), Scoreboard.get_target_points()]
	timerLabel.text = "%d" %(get_node("/root/GameScene/ActualTimer").get_time_left())
	levelLabel.text = "Level: %d" % Scoreboard.level
