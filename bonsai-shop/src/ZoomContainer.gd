extends SubViewportContainer

@onready var viewPort = $Zoom

# Called when the node enters the scene tree for the first time.
func _ready():
	viewPort.world_2d = get_viewport().world_2d
