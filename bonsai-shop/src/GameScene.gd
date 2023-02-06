extends Node2D

@export var medialuna_scene: PackedScene
var mata_pos :Vector2
const TIMER_TIME := 60

func _ready():
	Scoreboard.reset()
	$Trimmer.plant_finished.connect(pass_bonsai)
	mata_pos = $Trimmer/Mata.global_position
	Scoreboard.score_changed.connect(on_score)
	Scoreboard.level_changed.connect(on_level)
	$ActualTimer.start(TIMER_TIME)
	$ActualTimer.timeout.connect(on_timeout)

func pass_bonsai():
	$Trimmer.change_plant($Queue.pop_bonsai())

func on_score(_new_score:int, new_points: int):
	for i in new_points:
		var medialuna = medialuna_scene.instantiate()
		add_child(medialuna)
		medialuna.global_position = mata_pos
		medialuna.travel(Vector2(0,0))
		await get_tree().create_timer(medialuna.TIME/2.0).timeout

func on_level(_level):
	$ActualTimer.stop()
	$ActualTimer.start(TIMER_TIME)

func on_timeout():
	get_tree().change_scene_to_file("res://src/GameOver.tscn")
