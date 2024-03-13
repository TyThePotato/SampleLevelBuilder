extends Node

@onready var builder = $editor_builder

func _ready():
	clear_map()
	create_new_file()

# FILE FUNCTIONS #

func create_new_file():
	prepare_new_map()
	
func open_file():
	pass
	
func save_to_file():
	pass


# MAP FUNCTIONS #

func prepare_new_map():
	builder.initialize_level()
	
	print('New map prepared')
	
func clear_map():
	print('Map cleared')
