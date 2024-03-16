class_name EditorBuilder
extends Node

var level_root_node: Node3D

var terrain_node: Terrain
var grid_node: GridRenderer

var terrain_resolution: int = 32

func initialize_level() -> void:
	# create root node
	level_root_node = Node3D.new()
	level_root_node.name = 'level_root'
	add_child(level_root_node)
	
	# create grid
	create_grid()
	
	# create initial level geometry
	create_terrain()

func add_object(object: LevelObject):
	level_root_node.add_child(object)
	
func remove_object(object: LevelObject):
	level_root_node.remove_child(object)
	object.queue_free()

func create_terrain() -> bool:
	if terrain_node != null:
		return false
	
	terrain_node = Terrain.new()
	terrain_node.resolution = terrain_resolution
	terrain_node.build()
	level_root_node.add_child(terrain_node)

	return true
	
func create_grid() -> bool:
	if grid_node != null:
		return false
		
	grid_node = GridRenderer.new()
	add_child(grid_node)
		
	return true
