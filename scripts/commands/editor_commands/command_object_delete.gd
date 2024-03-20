class_name CommandObjectDelete
extends BaseCommand

var _objects_properties: Array[LevelObjectProperties] = [] # information to reconstruct objects
var _objects_ids : PackedInt32Array # information to deconstruct objects

func _init(objects: Array[LevelObject]):
	human_readable_name = 'Delete ' + str(objects.size()) + ' Object'
	if objects.size() > 1:
		human_readable_name += 's'

	_objects_ids = PackedInt32Array()
	_objects_ids.resize(objects.size())

	var i := 0
	for object in objects:
		var props := LevelObjectProperties.new()
		props.from_level_object(object)

		_objects_properties.append(props)
		_objects_ids[i] = object.id	
	
		i += 1

# Remove object
func execute_command():
	editor_main.objects_delete_by_id(_objects_ids)

# Create object
func execute_command_revert():
	editor_main.objects_new(_objects_properties)
	# ids should already be known so there is no need to retrieve them like in CommandObjectNew
