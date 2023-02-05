class_name Feedback
extends Sprite2D

const DURATION := 1.2

const TEXTURES_MAP: Dictionary = {
	"PERFECT":preload("res://assets/UI/UI Assets/feedback_asset/png/feedback_perfect.png"),
	"GREAT":preload("res://assets/UI/UI Assets/feedback_asset/png/feedback_great.png"),
	"GOOD":preload("res://assets/UI/UI Assets/feedback_asset/png/feedback_good.png"),
	"POOR":preload("res://assets/UI/UI Assets/feedback_asset/png/feedback_poor.png"),
	"REALLY_BAD":preload("res://assets/UI/UI Assets/feedback_asset/png/feedback_reallybad.png"),
	"DISGUSTING":preload("res://assets/UI/UI Assets/feedback_asset/png/feedback_disgusting.png")
}

func _init(feedback_name: String):
	assert(TEXTURES_MAP.keys().has(feedback_name), "INVALID FEEDBACK NAME!")
	texture = TEXTURES_MAP[feedback_name]

func _ready():
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "position:y", -100, DURATION)
	tween.tween_property(
		self, "scale", Vector2(.4, .4), DURATION
	)
	tween.tween_property(self, "modulate:a", 0.0, DURATION)
	await tween.finished
	queue_free()
