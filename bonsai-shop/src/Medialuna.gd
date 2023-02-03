extends Node2D

const ROT_SPEED := 2*PI
const TIME := 1.0


func _ready():
	$Sprite.scale = Vector2(.1, .1)


func travel(to_pos: Vector2):
	var tween = create_tween()
	tween.tween_property($Sprite, "scale", Vector2(0.0, 0.0), TIME)
	tween.parallel().tween_property(self, "global_position", to_pos, TIME)
	await tween.finished
	queue_free()


func _process(delta):
	$Sprite.rotation += delta * ROT_SPEED
