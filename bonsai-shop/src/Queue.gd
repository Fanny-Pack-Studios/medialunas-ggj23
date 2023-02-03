@tool
extends Node2D

@export var bonsai_scene:PackedScene
@export var visible_in_queue:= 5

const BONSAI_SEPARATION := 125

var queue := []

func add_to_queue(pos := Vector2.ZERO):
	var bonsai := bonsai_scene.instantiate()
	add_child(bonsai)
	bonsai.position = pos
	queue.append(bonsai)

func pop_bonsai():
	add_to_queue(position_for_bonsai(visible_in_queue)) # cola infinita
	var popped = queue.pop_front()
	for i in queue.size():
		queue[i].move_to(to_global(position_for_bonsai(i)))
	return popped

func position_for_bonsai(in_pos:int)->Vector2:
	return Vector2((visible_in_queue-in_pos-1)*BONSAI_SEPARATION,0)

func _ready():
	for i in visible_in_queue:
		add_to_queue(position_for_bonsai(i))
