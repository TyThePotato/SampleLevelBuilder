class_name CommandNodeModify
extends BaseCommand

var _nodes_ids: PackedInt32Array
var _new_properties: Array[Dictionary]
var _old_properties: Array[Dictionary]

func _init(ids: PackedInt32Array, old: Array[Dictionary], new: Array[Dictionary]):
    human_readable_name = 'Modify ' + str(ids.size()) + ' Node'
    if ids.size() > 1:
        human_readable_name += 's'
        
    _nodes_ids = ids
    _new_properties = new
    _old_properties = old

# Apply property changes
func execute_command():
    for i in range(_nodes_ids.size()):
        editor_main.node_modify_by_id(_nodes_ids[i], _new_properties[i])

# Revert property changes
func execute_command_revert():
    for i in range(_nodes_ids.size()):
        editor_main.node_modify_by_id(_nodes_ids[i], _old_properties[i])
