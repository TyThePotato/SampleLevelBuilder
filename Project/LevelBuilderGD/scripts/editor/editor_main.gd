extends Node
class_name EditorMain

@onready var builder: Node = $editor_builder

func _ready():
	# prepare command system
	CommandManager.editor_main = self

	# prepare initial map
	clear_level()
	create_new_file()
	
	type_test(BaseCommand)

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

# DEBUG FUNCTIONS #

func ping():
	# used for testing command system
	var cmd: CommandPing = CommandPing.new()
	CommandManager.push_command(cmd)
	
func type_test(type):
	print(typeof(type))
