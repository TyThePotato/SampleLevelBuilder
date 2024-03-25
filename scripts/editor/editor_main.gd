class_name EditorMain
extends Node

# prefabs
@export var editor_camera_prefab: PackedScene

# assets
@export var default_material: Material

# node references
# TODO: autoload?
@onready var builder: EditorBuilder = $editor_builder
@onready var ui: EditorUI = $canvas/ui_main

var _level_root_node: LevelRoot

# level properties
var level_name: String = 'New Level'

var _last_id: int = 0
var _selected_objects := []

func _ready():
    # prepare command system
    CommandManager.editor_main = self
    CommandManager.clear_all_history()

    # prepare initial map
    prepare_new_level()

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
    clear_level()

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
    # simply reload scene
    get_tree().reload_current_scene()

# EDITING FUNCTIONS #

func objects_new(properties: Array[LevelObjectProperties]) -> Array[LevelObject]:
    var ret_array: Array[LevelObject] = []
    for props in properties:
        var obj := LevelObject.new(props)
        obj.material_override = default_material

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

func objects_delete(objects: Array) -> void:
    # deselect objects (if selected)
    nodes_deselect(objects)
    
    var valid_objects := []
    
    for object in objects:
        if object is LevelObject:
            valid_objects.append(object)
            builder.remove_object(object)

    ui.remove_nodes_from_outliner(valid_objects)

func objects_delete_by_id(objects_ids: PackedInt32Array) -> void:
    var objects := get_objects_from_ids(objects_ids)
    objects_delete(objects)

func nodes_select(nodes: Array) -> void:
    for node in nodes:
        if not _selected_objects.has(node):
            _selected_objects.append(node)

    nodes_selected.emit(_selected_objects)

func nodes_deselect(nodes: Array) -> void:
    for i in range(_selected_objects.size() - 1, -1, -1):
        if (nodes.has(_selected_objects[i])):
            _selected_objects.remove_at(i)

    nodes_selected.emit(_selected_objects)

func nodes_modify(nodes: Array[Node3D], modifications: Dictionary) -> void:
    for node in nodes:
        for key in modifications:
            var val = modifications[key]
            node.set(key, val)
        
            if node is LevelObject:
                (node as LevelObject).refresh_mesh()
                    
    nodes_modified.emit(nodes)

func node_select(object: Node3D) -> void:
    nodes_select([object])

func node_deselect(object: Node3D) -> void:
    nodes_deselect([object])

func node_modify(object: Node3D, modifications: Dictionary) -> void:
    nodes_modify([object], modifications)
    
func node_modify_by_id(id: int, modifications: Dictionary) -> void:
    var target = null
    
    var nodes := get_objects_from_ids(PackedInt32Array([id]))
    if nodes.size() > 0:
        target = nodes[0]

    if target != null:
        node_modify(target, modifications)

func selection_clear() -> void:
    # TODO: affect UI
    _selected_objects.clear()

func selection_delete() -> void:
    var level_objects: Array[LevelObject] = []
    for obj in _selected_objects:
        if obj is LevelObject:
            level_objects.append(obj)

    objects_delete(level_objects)

func selection_modify(modifications: Dictionary) -> void:
    nodes_modify(_selected_objects, modifications)
    selection_modified.emit(_selected_objects)

# GENERAL #

func get_objects_from_ids(ids: PackedInt32Array) -> Array:
    var objects := []
    if _level_root_node.id in ids:
        objects.append(_level_root_node)
    
    for node in _level_root_node.get_children():
        var id = node.get('id')
        if id != null and ids.has(id):
            objects.append(node)

    return objects
    
func get_node_property_dict(node: Node3D, properties: Array) -> Dictionary:
    var dict := {}

    for prop in properties:
        var val = node.get(prop)
        if val != null:
            dict[prop] = val

    return dict
    
func get_new_object_name(base: String) -> String:
    if not _level_root_node.has_node(base):
        return base
    
    var i := 2
    var unique := false
    while not unique: # oh boy! i love while loops!
        if not _level_root_node.has_node(base + str(i)):
            unique = true
        else:
            i += 1
            
    return base + str(i)

# COMMAND FUNCTIONS #

func cmd_object_new():
    var props := LevelObjectProperties.new()
    props.name = get_new_object_name('New Object')

    var cmd := CommandObjectNew.new([props])
    CommandManager.insert_command(cmd, true)

func cmd_object_delete():
    var level_objects: Array[LevelObject] = []
    for obj in _selected_objects:
        if obj is LevelObject:
            level_objects.append(obj)
        
    if level_objects.size() == 0:
        return

    var cmd := CommandObjectDelete.new(level_objects)
    CommandManager.insert_command(cmd, true)

func cmd_selection_modify(modifications: Dictionary):
    var ids: Array[int]
    var old_mods: Array[Dictionary]
    var new_mods: Array[Dictionary]
    
    for i in range(_selected_objects.size()):
        var obj = _selected_objects[i]
        var id = obj.get('id')
        if id != null:
            ids.append(id)
            old_mods.append(get_node_property_dict(obj, modifications.keys()))
            new_mods.append(modifications)
        
    # execute
    var cmd := CommandNodeModify.new(PackedInt32Array(ids), old_mods, new_mods)
    CommandManager.insert_command(cmd, true)

func cmd_undo():
    CommandManager.revert_last_command()

func cmd_redo():
    CommandManager.execute_next_command()

func cmd_ping():
    # used for testing command system
    var cmd := CommandPing.new()
    CommandManager.insert_command(cmd, true)

# SIGNALS #

signal nodes_selected(nodes: Array)
signal nodes_modified(nodes: Array)
    
signal selection_modified(nodes: Array)
