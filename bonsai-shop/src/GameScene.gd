extends Node2D


func _ready():
	$Trimmer.plant_finished.connect(Callable(self, "pass_bonsai"))


func pass_bonsai():
	$Trimmer.change_plant($Queue.pop_bonsai())
