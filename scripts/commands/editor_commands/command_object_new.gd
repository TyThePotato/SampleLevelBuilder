class_name CommandObjectNew
extends BaseCommand

var _objects_properties: Array[LevelObjectProperties] = [] # information to construct objects
var _objects_ids : PackedInt32Array # information to deconstruct objects

func _init(properties: Array[LevelObjectProperties]):
	human_readable_name = 'Create ' + str(properties.size()) + ' Object'
	if properties.size() > 1:
		human_readable_name += 's'

	_objects_properties = properties

# Create object
func execute_command():
	var objects := editor_main.objects_new(_objects_properties)

	# store object ids on first execution
	if _objects_ids.is_empty():
		_objects_ids.resize(objects.size())
	
		var i := 0
		for object in objects:
			_objects_ids[i] = object.id
			_objects_properties[i].id = object.id # assuming properties is in the same order... is it?
			i += 1

# Remove object
func execute_command_revert():
	editor_main.objects_delete_by_id(_objects_ids)
