class_name LevelObject
extends MeshInstance3D

var id: int

func _init(properties: LevelObjectProperties):
	name = properties.name
	position = properties.position
	rotation_degrees = properties.rotation
	scale = properties.scale # global?
	
	mesh = BoxMesh.new()
	
