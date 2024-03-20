class_name CommandObjectNew
extends BaseCommand

var _object_properties: LevelObjectProperties
var _object: LevelObject

func _init(properties: LevelObjectProperties):
    human_readable_name = 'New Object'
    _object_properties = properties

# Create object
func execute_command():
    _object = editor_main.objects_new([_object_properties])[0]

# Remove object
func execute_command_revert():
    editor_main.objects_delete([_object])