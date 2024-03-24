class_name EditorUI
extends Node

# node references
@export var _sub_viewport: SubViewport
@export var _outliner: OutlinerUI
@export var _properties: SelectionPropertiesUI

# ui variables

# makeshift 2-way dictionary - access value using key and key using value
var _outliner_items := {} # Node3D | TreeItem
var _outliner_nodes := {} # TreeItem | Node3D

func _ready():
    # bind camera to subviewport
    request_camera_bind.emit(_sub_viewport)

# set up outliner tree alignment (grr non-exported properties)
#_outliner_tree.set_column_expand(0, false)

# MENU BUTTONS #
# TODO: better system...?

var _menu_btn_level_table: Array[Signal] = [
                                           Signal(),
                                           Signal(),
                                           Signal(),
                                           Signal(),
                                           btn_editor_exit,
                                           ]

var _menu_btn_edit_table: Array[Signal] = [
                                          btn_edit_new,
                                          btn_edit_delete,
                                          btn_edit_undo,
                                          btn_edit_redo,
                                          btn_ping
                                          ]

var _menu_btn_view_table: Array[Signal] = [
                                          Signal()
                                          ]

func _menu_btn_generic(signal_table: Array[Signal], id: int) -> void:
    if id > signal_table.size() - 1:
        print('UNIMPLEMENTED MENU BUTTON ' + str(id))
        return

    var sig := signal_table[id]

    if sig == null:
        print('UNIMPLEMENTED MENU BUTTON ' + str(id))
        return

    sig.emit()

func _menu_btn_level(id: int) -> void:
    _menu_btn_generic(_menu_btn_level_table, id)

func _menu_btn_edit(id: int) -> void:
    _menu_btn_generic(_menu_btn_edit_table, id)

func _menu_btn_view(id: int) -> void:
    _menu_btn_generic(_menu_btn_view_table, id)

# OUTLINER #

func add_nodes_to_outliner(nodes: Array) -> void:
    _outliner.add_nodes(nodes)

func remove_nodes_from_outliner(nodes: Array) -> void:
    _outliner.remove_nodes(nodes)
    
func refresh_outliner_nodes(nodes: Array) -> void:
    for node in nodes:
        _outliner.restyle_node(node)

func _outliner_item_selected(node):
    node_selected.emit(node)

func _outliner_item_deselected(node):
    node_deselected.emit(node)

# PROPERTIES #

func set_properties_objects(objects: Array):
    _properties.show_object_properties(objects)

func set_properties_terrains(terrains: Array):
    _properties.show_terrains_properties(terrains)

func set_properties_level():
    _properties.show_level_properties()

func set_properties_mixed():
    _properties.show_mixed()

func set_properties_clear():
    _properties.clear()
    
func _property_modified(tag: String, value):
    var dict := { tag : value }
    properties_modified.emit(dict)

# GENERAL #

func selection_updated(nodes: Array):
    # TODO: make sure outliner nodes are selected (and avoid recursion)
    # NOTE: also used for property updates - take into consideration

    var selection_type := ''

    for node: Node in nodes:
        if node is LevelObject:
            if selection_type == '':
                selection_type = 'object'
            elif selection_type != 'object':
                selection_type = 'mixed'
                break

        elif node is Terrain:
            if selection_type == '':
                selection_type = 'terrain'
            elif selection_type != 'terrain':
                selection_type = 'mixed'
                break

        elif node.name == 'Level':
            if selection_type == '':
                selection_type = 'level'
            elif selection_type != 'level':
                selection_type = 'mixed'
                break

    match selection_type:
        'object': set_properties_objects(nodes)
        'terrain': set_properties_terrains(nodes)
        'level': set_properties_level()
        'mixed': set_properties_mixed()
        '': set_properties_clear()


# SIGNALS #

signal request_camera_bind(sub_viewport: SubViewport)

signal node_selected(node: Node3D)
signal node_deselected(node: Node3D)

signal properties_modified(modifications: Dictionary)

# buttons
signal btn_editor_exit

signal btn_edit_new
signal btn_edit_delete

signal btn_edit_undo
signal btn_edit_redo

signal btn_ping
