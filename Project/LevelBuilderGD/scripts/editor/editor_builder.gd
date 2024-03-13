extends Node

var terrain_node: Terrain
var grid_node: GridRenderer

var terrain_resolution = 32

func initialize_level() -> void:
	# create grid
	create_grid()
	
	# create initial level geometry
	create_terrain()

func create_terrain() -> bool:
	if terrain_node != null:
		return false
	
	terrain_node = Terrain.new()
	terrain_node.resolution = terrain_resolution
	terrain_node.build()
	add_child(terrain_node) # todo: make child of world

	return true
	
func create_grid() -> bool:
	if grid_node != null:
		return false
		
	grid_node = GridRenderer.new()
	add_child(grid_node) # todo: make child of world
		
	return true
