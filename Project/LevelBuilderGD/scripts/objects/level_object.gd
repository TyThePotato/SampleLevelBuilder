class_name LevelObject
extends MeshInstance3D

func _init(properties: LevelObjectProperties):
    name = properties.name
    global_position = properties.position
    global_rotation_degrees = properties.rotation
    scale = properties.scale # global?
    
    mesh = BoxMesh.new()

