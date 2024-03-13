extends Node

var terrain_node: Terrain

var terrain_resolution = 32

func create_terrain() -> bool:
	if terrain_node != null:
		return false
	
	terrain_node = Terrain.new()
	terrain_node.resolution = terrain_resolution
	terrain_node.build()
	add_child(terrain_node) # todo: make child of world
	
	print("Created new terrain")
	return true
