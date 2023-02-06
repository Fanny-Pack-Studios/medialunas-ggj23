@tool
extends Node3D

@onready var positions := $Positions
@onready var multimeshs := [$Maple, $Pine]

func _ready():
	if not Engine.is_editor_hint():
		return
	var global_positions = read_positions()

	for multimesh in multimeshs:
		multimesh.multimesh.instance_count = 0 


	var mesh_positions := []
	mesh_positions.resize(multimeshs.size())
	for global_pos in global_positions:
		var mesh_id = randi()%multimeshs.size()
		if mesh_positions[mesh_id] == null:
			mesh_positions[mesh_id] = []
		mesh_positions[mesh_id].append(
			Transform3D(Basis(),global_pos)
		)
	for mesh_id in mesh_positions.size():
		var multimesh =  multimeshs[mesh_id].multimesh
		multimesh.set_instance_count(mesh_positions[mesh_id].size())
		var transforms = mesh_positions[mesh_id]
		for i in transforms.size():
			multimesh.set_instance_transform(i,transforms[i])

func read_positions()->Array[Vector3]:
	var global_positions := []
	for child in positions.get_children():
		global_positions.append(child.global_transform.origin)
	global_positions.shuffle()
	return global_positions
