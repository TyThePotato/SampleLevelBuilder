class_name EditorMain
extends Node

# prefabs
@export var editor_camera_prefab: PackedScene

# node references
# TODO: autoload?
@onready var builder: EditorBuilder = $editor_builder
@onready var ui: EditorUI = $canvas/ui_main

var _level_root_node: Node3D

# level properties
var level_name: String = 'New Level'

var _last_id: int = 0
var _selected_objects: Array[Node3D] = []

func _ready():
	# prepare command system
	CommandManager.editor_main = self

	# prepare initial map
	clear_level()
	create_new_file()

# EDITOR FUNCTIONS #

func create_editor_camera(sub_viewport: SubViewport):
	var cam : Camera3D = editor_camera_prefab.instantiate()
	
	# add default offset
	cam.position += Vector3(0, 3, 0)

	sub_viewport.add_child(cam)
	
	print('Editor camera created')

func editor_exit():
	# TODO: confirmation prompt
	get_tree().quit()

# FILE FUNCTIONS #

func create_new_file():
	prepare_new_level()
	
func open_file():
	pass
	
func save_to_file():
	pass


# LEVEL FUNCTIONS #

func prepare_new_level():
	# create root
	_level_root_node = builder.initialize_level()
	
	# create initial terrain
	var terrain := builder.create_terrain()

	ui.add_nodes_to_outliner([_level_root_node, terrain])
	
	print('New level prepared')
	
func clear_level():
	# TODO: delete all geometry & reset ui
	print('Level cleared')

# EDITING FUNCTIONS #

func objects_new(properties: Array[LevelObjectProperties]) -> Array[LevelObject]:
	var ret_array: Array[LevelObject] = []
	for props in properties:
		var obj = LevelObject.new(props)
	
		if props.id != -1:
			obj.id = props.id
			if props.id > _last_id: _last_id = props.id
		else:
			_last_id += 1
			obj.id = _last_id
		
		builder.add_object(obj)
		ret_array.append(obj)
		
	ui.add_nodes_to_outliner(ret_array)

	return ret_array
	
func objects_delete(objects: Array[LevelObject]) -> void:
	# deselect objects (if selected)
	nodes_deselect(objects)
	
	for object in objects:
		builder.remove_object(object)
		
	ui.remove_nodes_from_outliner(objects)
	
func objects_delete_by_id(objects_ids: PackedInt32Array) -> void:
	var objects = get_objects_from_ids(objects_ids)
	objects_delete(objects)

func nodes_select(nodes: Array[Node3D]) -> void:
	for node in nodes:
		if not _selected_objects.has(node):
			_selected_objects.append(node)
	
func nodes_deselect(nodes: Array) -> void:
	for i in range(_selected_objects.size() - 1, -1, -1):
		if (nodes.has(_selected_objects[i])):
			_selected_objects.remove_at(i)
	
func node_select(object: Node3D) -> void:
	nodes_select([object])
	
func node_deselect(object: Node3D) -> void:
	nodes_deselect([object])
	
func selection_clear() -> void:
	# TODO: hotkey (esc)
	_selected_objects.clear()
	
	# TODO: affect UI
	
func selection_delete() -> void:
	var level_objects: Array[LevelObject] = []
	for obj in _selected_objects:
		if obj is LevelObject:
			level_objects.append(obj)
			
	objects_delete(level_objects)

# GENERAL #

func get_objects_from_ids(ids: PackedInt32Array):
	var objects: Array[LevelObject] = []
	for node in _level_root_node.get_children():
		var obj := node as LevelObject
		if obj == null: continue
			
		if ids.has(obj.id):
			objects.append(obj)
			
	return objects

# COMMAND FUNCTIONS #

func cmd_object_new():
	var props := LevelObjectProperties.new()
	var rand_pos := Vector3(randf() * 10, 1, randf() * 10)
	props.position = rand_pos
	
	var cmd := CommandObjectNew.new([props])
	CommandManager.insert_command(cmd, true)

func cmd_object_delete():
	var level_objects: Array[LevelObject] = []
	for obj in _selected_objects:
		if obj is LevelObject:
			level_objects.append(obj)
			
	var cmd := CommandObjectDelete.new(level_objects)
	CommandManager.insert_command(cmd, true)

func cmd_undo():
	CommandManager.revert_last_command()

func cmd_redo():
	CommandManager.execute_next_command()

func cmd_ping():
	# used for testing command system
	var cmd := CommandPing.new()
	CommandManager.insert_command(cmd, true)
