class_name EditorMain
extends Node

# prefabs
@export var editor_camera_prefab: PackedScene

# node references
@onready var builder: EditorBuilder = $editor_builder

# level properties
var level_name: String = 'New Level'

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
	builder.initialize_level()
	
	print('New level prepared')
	
func clear_level():
	print('Level cleared')

# EDITING FUNCTIONS #

func objects_new(properties: Array[LevelObjectProperties]) -> Array[LevelObject]:
	var ret_array: Array[LevelObject] = []
	for props in properties:
		var obj = LevelObject.new(props)
		builder.add_object(obj)
		ret_array.append(obj)
		
	return ret_array
	
func objects_delete(objects: Array[LevelObject]) -> void:
	for object in objects:
		builder.remove_object(object)

# COMMAND FUNCTIONS #

func cmd_object_new():
	var cmd := CommandObjectNew.new(LevelObjectProperties.new())
	CommandManager.insert_command(cmd, true)

func cmd_undo():
	CommandManager.revert_last_command()
	print('Undo command')

func cmd_redo():
	CommandManager.execute_next_command()
	print('Redo command')

func cmd_ping():
	# used for testing command system
	var cmd := CommandPing.new()
	CommandManager.insert_command(cmd, true)