@tool
class_name VariatedSprite
extends Sprite2D

@export var variations:Array[Texture]
@export var variation :=0 : set = set_variation

const MATERIAL = preload("res://src/HueVariatedSpriteMaterial.tres")


func _ready():
	material = MATERIAL.duplicate()


func set_hue(hue: float):
	material.set_shader_parameter("hue_rotated", hue)


func set_variation(to_var: int):
	variation = to_var % variations.size()
	texture = variations[variation]
