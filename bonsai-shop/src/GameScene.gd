extends Node2D

@export var medialuna_scene: PackedScene
var mata_pos :Vector2

func _ready():
	$Trimmer.plant_finished.connect(Callable(self, "pass_bonsai"))
	mata_pos = $Trimmer/Mata.global_position
	Scoreboard.score_changed.connect(Callable(self, 'on_score'))

func pass_bonsai():
	$Trimmer.change_plant($Queue.pop_bonsai())

func on_score(_new_score:int, new_points: int):
	for i in new_points:
		var medialuna = medialuna_scene.instantiate()
		add_child(medialuna)
		medialuna.global_position = mata_pos
		medialuna.travel(Vector2(0,0))
		await get_tree().create_timer(medialuna.TIME/2.0).timeout
